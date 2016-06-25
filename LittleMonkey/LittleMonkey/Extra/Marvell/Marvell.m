//
//  Marvell.m
//  HelloToy
//
//  Created by huanglurong on 16/2/23.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "Marvell.h"
#import "sys/sysctl.h"
#import "zlib.h"


#define MsgCount 100
CFHTTPMessageRef messageArray[MsgCount];

@interface Marvell(){
    
    unsigned char bssid[6];
    char passphrase[64];
    unsigned long passCRC;
    NSTimer *sendInterval;
}



@property(nonatomic,assign) BOOL invalidPassphrase;
@property(nonatomic,assign) int passLen;

@property (assign, nonatomic) NSInteger state;
@property (assign, nonatomic) NSInteger substate;

@property (nonatomic,strong) NSMutableArray *arr_clients;

@end


@implementation Marvell
-(id)init{

    if (self = [super init]) {
        
        NSLog(@"Init Marvell");
        sendInterval = nil;
        _state = 0;
        _substate = 0;
        self.arr_clients = [NSMutableArray arrayWithCapacity:10];

    }
    
    return self;
}

-(void)dealloc{
    NSLog(@"unInit Marvell");
    [self closeServer];
}


#pragma mark - public

- (void)startTransmitting:(BOOL)isWifi{
    
   
    _passLen = [_wifiPassWord length];
    
    const char *temp = [_wifiPassWord UTF8String];
    
    int int_temp = [Marvell getIPAddress];
    
    Byte data[5];
    
    data[0] = (Byte)(int_temp >> 24) & 0xff;;
    data[1] = (Byte)(int_temp >> 16) & 0xff;
    data[2] = (Byte)(int_temp >> 8) & 0xff;
    data[3] = (Byte)int_temp & 0xff;
    
    Byte checkMask;
    if (isWifi) {
        checkMask = (Byte)0xe0;
    }else{
        checkMask = (Byte)0xf0;
    }
    for(int i=0; i<4;i++) {
        if(data[i] == 0) {
            data[i]++;
            checkMask |= 1 << i;
        }
    }
    data[4] = checkMask;
    
    strcpy(passphrase, temp);
    
    for(int i=0;i<5;i++) {
        passphrase[_passLen+i] = data[i];
    }
    passphrase[_passLen+5] = 0;
    _passLen += 5;
    unsigned char *str = (unsigned char *)passphrase;
    passCRC = crc32(0, str, _passLen);
    passCRC = passCRC & 0xffffffff;
    
    NSLog(@"Passphrase %d %s", _passLen, passphrase);
    NSLog(@"CRC32 %lu", passCRC);
    

    sendInterval =[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(statemachine) userInfo:nil repeats:YES];

}

- (void)stopTransmitting
{
    if(sendInterval != nil){
        [sendInterval invalidate];
        sendInterval = nil;
    }
    
}


#pragma mark - private 

/***************** 创建服务器相关 ***************/

- (void)startServerWithDelegate:(id)delegate{

    _serverSocket = [[AsyncSocket alloc] initWithDelegate:self];
    NSError *err = nil;
    if ([_serverSocket acceptOnPort:SS_PORT error:&err]) {
        NSLog(@"accept ok");
    }else{
        NSLog(@"accept failed");
    }
    
    if (err) {
        NSLog(@"error:%@",err);
    }
    
    self.delegate = delegate;
    
}

- (void)closeServer{

    if(self.serverSocket != nil){
        NSLog(@"Close server");
        [_serverSocket setDelegate:nil];
        [_serverSocket disconnect];
        self.serverSocket = nil;
    }

    self.delegate = nil;
}

- (BOOL) isServerStarted{

    if (_serverSocket == nil) {
        return NO;
    }else{
        return YES;
    }
    
}

#pragma mark get Current WiFi Name

-(NSString *)currentWifiSSID
{
    // Does not work on the simulator.
    NSString *ssid_str = nil;
    NSString *bssid_str = nil;
    NSArray *testArray = [[NSArray alloc] init];
    NSArray *ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());
    NSString *temp;
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)ifnam));
        NSLog(@"String %@", info);
        if (info[@"SSID"]) {
            ssid_str = info[@"SSID"];
            NSLog(@"ssid %@", ssid_str);
            bssid_str = info[@"BSSID"];
            NSLog(@"bssid %@", bssid_str);
            testArray = [bssid_str componentsSeparatedByString:@":"];
            NSScanner *aScanner;
            unsigned int te;
            for (int i = 0; i < 6; i++) {
                temp = [testArray objectAtIndex:i];
                aScanner = [NSScanner scannerWithString:temp];
                [aScanner scanHexInt: &te];
                bssid[i] = te;
            }
        
        }
    }
    
    _wifiBSSID = bssid_str;
    
    return ssid_str;
}


- (BOOL)isPassphrassInvalid{

    if ((_passLen >= 8 && _passLen < 64) || (_passLen == 0)) {
        return _invalidPassphrase = NO;
        
    } else {
        return _invalidPassphrase = YES;
    }

    return _invalidPassphrase;
    
}


/***************** 创建udp广播发送wifi相关 ***************/


-(void) xmitRaw:(int) u data:(int) m substate:(int) l
{
    int sock;
    struct sockaddr_in addr;
    NSMutableString* getnamebyaddr = [NSMutableString stringWithFormat:@"239.%d.%d.%d", u, m, l];
    const char * d_addr = [getnamebyaddr UTF8String];
    
    if ((sock = socket(PF_INET, SOCK_DGRAM, 0)) < 0) {
        NSLog(@"ERROR: broadcastMessage - socket() failed");
        return;
    }
    
    bzero((char *)&addr, sizeof(struct sockaddr_in));
    
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = inet_addr(d_addr);
    addr.sin_port        = htons(1234);
    
    u = u & 0x7f;
    
    if ((sendto(sock, "a", 1, 0, (struct sockaddr *) &addr, sizeof(addr))) != 1) {
        NSLog(@"Errno %d", errno);
        NSLog(@"ERROR: broadcastMessage - sendto() sent incorrect number of bytes");
        return;
    }
    
    close(sock);
}


-(void)xmitState0:(int)substate
{
    int i, j, k;
    
    k = bssid[2  * substate];
    j = bssid[2 * substate + 1];
    i = _substate;
    
    [self xmitRaw:i data: j substate: k];
}

-(void)xmitState1
{
    int u = (0x01 << 5) | (0x0);
    [self xmitRaw:u data:_passLen substate: _passLen];
}

-(void)xmitState2:(int)substate LengthPassphrase:(int)len
{
    int u = _substate | (0x2 << 5);
    int l = (0xff & passphrase[2 * substate]);
    int m;
    if (len == 2)
        m = (0xff & passphrase[2 * _substate + 1]);
    else
        m = 0;
    [self xmitRaw:u data:m substate:l];
}

-(void)xmitState3: (int)substate
{
    int i, j, k;
    
    k = (int) (passCRC >> ((2 * _substate + 0) * 8)) & 0xff;
    j = (int) (passCRC >> ((2 * _substate + 1) * 8)) & 0xff;
    i = substate | (0x3 << 5);
    
    [self xmitRaw:i data: j substate: k];
}

-(void)statemachine
{
   
    NSLog(@"%d",_substate);
    switch(_state) {
        case 0:
            if (_substate == 3) {
                _state = 1;
                _substate = 0;
            } else {
                [self xmitState0:_substate];
                _substate++;
            }
            break;
        case 1:
            [self xmitState1];
            _substate = 0;
            if (_passLen == 0) {
                _state = 3;
            } else {
                _state = 2;
            }
            break;
        case 2:
            [self xmitState2:_substate LengthPassphrase:2];
            _substate++;
            if (_passLen % 2 == 1) {
                if (_substate * 2 == _passLen - 1) {
                    [self xmitState2:_substate LengthPassphrase: 1];
                    _state = 3;
                    _substate = 0;
                }
            } else {
                if (_substate * 2 == _passLen) {
                    _state = 3;
                    _substate = 0;
                }
            }
            break;
        case 3:
            [self xmitState3:_substate];
            _substate++;
            if (_substate == 2) {
                _substate = 0;
                _state = 0;
            }
            break;
        default:
            NSLog(@"MRVL: I should not be here!");
    }
}

#pragma mark - AsyncSocket Delegate

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket{
    
    NSNumber *tag = nil;
    AsyncSocket *clientSocket = newSocket;
    
     NSMutableDictionary *client = [[NSMutableDictionary alloc]initWithCapacity:5];

    for (NSUInteger idx=0; idx!=MsgCount; idx++) {
        if(messageArray[idx]==nil){
            messageArray[idx] = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, TRUE);
            tag = [NSNumber numberWithLong:(long)idx];
            break;
        }
    }
    
    if(tag == nil)
        return;
    
    [client setObject:clientSocket forKey:@"Socket"];
    [client setObject:tag forKey:@"Tag"];
    [_arr_clients addObject:client];
    NSLog(@"New socket client, %d", [tag intValue]);
    

}


- (NSRunLoop *)onSocket:(AsyncSocket *)sock wantsRunLoopForNewSocket:(AsyncSocket *)newSocket{
    NSLog(@"wants runloop for new socket");
    return [NSRunLoop currentRunLoop];
}


- (BOOL)onSocketWillConnect:(AsyncSocket *)sock{
    NSLog(@"will connect");
    return YES;
}


- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"did connect to host");

    
    NSNumber *tag = nil;
    NSDictionary *client;
    
    
    for (NSDictionary *object in self.arr_clients) {
        if([object objectForKey:@"Socket"] ==sock){
            tag = [object objectForKey:@"Tag"];
            client = object;
            break;
        }
    }
    
    NSData *data = [self.delegate onServerSendMessage];
    if (data != nil) {
        [sock writeData:data withTimeout:20 tag:[[client objectForKey:@"Tag"] longValue]];
    }
    

}


- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{


}


- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{



}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{

    NSLog(@"onSocket %p willDisconnectWithError %@",sock,err);

}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    
    NSLog(@"socket did didsconnect");
    
    NSNumber *tag = nil;
    NSDictionary *disconnnectedClient;
    
    
    for (NSDictionary *object in self.arr_clients) {
        if([object objectForKey:@"Socket"] ==sock){
            tag = [object objectForKey:@"Tag"];
            disconnnectedClient = object;
            break;
        }
    }
    
    CFRelease(messageArray[[tag intValue]]);
    messageArray[[tag intValue]] = nil;
    [self.arr_clients removeObject: disconnnectedClient];
    

}

#pragma mark - tool
/*!!!!!!!!!!!!
 retriving the SSID of the connected network
 @return value: the SSID of currently connected wifi
 '!!!!!!!!!!*/
+ (NSString*)ssidForConnectedNetwork{
    NSArray *interfaces = (__bridge_transfer NSArray*)CNCopySupportedInterfaces();
    NSDictionary *info = nil;
    for (NSString *ifname in interfaces) {
        info = (__bridge_transfer NSDictionary*)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
        if (info && [info count]) {
            break;
        }
        info = nil;
    }
    
    NSString *ssid = nil;
    
    if ( info ){
        ssid = [info objectForKey:@"SSID"];
    }
    info = nil;
    return ssid? ssid:@"";
    
    
}

/*!!!!!!!!!!!!!
 retrieving the IP Address from the connected WiFi
 @return value: the wifi address of currently connected wifi
 */
+ (int)getIPAddress {
    NSString *address = @"";
    int int_addr;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String for IP
                    int_addr = ((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr.s_addr;
                    NSLog(@"%d",int_addr);
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                    //                    NSLog(@"subnet mask == %@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)]);
                    //
                    //                    NSLog(@"dest mask == %@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)]);
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free/release memory
    freeifaddrs(interfaces);
    return int_addr;
}

+ (NSString *)getNetMask{
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String for IP
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free/release memory
    freeifaddrs(interfaces);
    return address;
    
}

@end
