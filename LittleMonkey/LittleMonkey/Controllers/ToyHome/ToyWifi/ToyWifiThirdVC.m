//
//  ToyWifiThirdVC.m
//  LittleMonkey
//
//  Created by Hcat on 16/6/5.
//  Copyright © 2016年 CivetCatsTeam. All rights reserved.
//

#import "ToyWifiThirdVC.h"

#import "EASYLINK.h"
#import "Marvell.h"
#import "Reachability.h"
#import "NDToyAPI.h"

#import "ToyInfoSettingVC.h"


#define EASYLINK_TIMEOUT 60.0
#define LINKCHANGETIME 5.0

@interface ToyWifiThirdVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_tip;

@property(nonatomic,strong)NSMutableDictionary *deviceIPConfig;

@property(nonatomic,strong) EASYLINK *easylink_config;

@property(nonatomic,strong) NSTimer* easyLinkTimeOut;

@property(nonatomic,strong) NSString *bindCode;

@property(nonatomic,assign) BOOL isWifiOpen;

@property (assign, nonatomic) BOOL isTimeOut;

@property(assign,nonatomic) BOOL isMarvell;

@property(nonatomic,strong) Marvell *marvell_config;

@property(nonatomic,strong) NSTimer *changeLink;

@end

@implementation ToyWifiThirdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (_type == ToyWifiSetType) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveWifiNotification:) name:NOTIFICATION_REMOTE_WIFI object:nil];
        
    }
    

    [self initData];
    
    _easyLinkTimeOut = [NSTimer scheduledTimerWithTimeInterval:EASYLINK_TIMEOUT target:self selector:@selector(configTimeOut) userInfo:nil repeats:NO];
    
    
    _changeLink = [NSTimer scheduledTimerWithTimeInterval:LINKCHANGETIME target:self selector:@selector(changeLinkMethods) userInfo:nil repeats:YES];;
    
    
    if (_type == ToySetType) {
        
        [[GCDQueue mainQueue] execute:^{
            
            [self loadToyFind];
            
        } afterDelay:5*NSEC_PER_SEC];
        
    }
    
}

- (void)initView{
    
    self.imageV_tip.layer.cornerRadius = 220/2;
    self.imageV_tip.layer.borderWidth = 4.f;
    self.imageV_tip.layer.borderColor = [RGB(230, 230, 230) CGColor];
    self.imageV_tip.layer.masksToBounds = YES;
    
}


- (void)initData{
    self.deviceIPConfig = [[NSMutableDictionary alloc] initWithCapacity:5];
    _isWifiOpen = NO;
    _isMarvell = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self initView];
    
    
    if (_isMarvell) {
        
        if(_marvell_config == nil){
            
            self.marvell_config = [[Marvell alloc]init];
            [_marvell_config startServerWithDelegate:self];
            
        }
        
    }else{
        
        if(_easylink_config == nil){
            
            self.easylink_config = [[EASYLINK alloc]init];
            [_easylink_config startFTCServerWithDelegate:self];
            
        }
        
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    if (_isMarvell) {
        
        if(_marvell_config != nil){
            
            [_marvell_config stopTransmitting];
            [_marvell_config closeServer];
            _marvell_config = nil;
        }
        
    }else{
        
        if(_easylink_config != nil){
            [_easylink_config stopTransmitting];
            [_easylink_config closeFTCServer];
            _easylink_config = nil;
        }
        
    }
    
    if (_easyLinkTimeOut.isValid) {
        [_easyLinkTimeOut invalidate];
        _easyLinkTimeOut = nil;
    }
    
    if (_changeLink.isValid) {
        
        [_changeLink invalidate];
        _changeLink = nil;
        
    }
    
    self.isTimeOut = YES;
    
    [super viewWillDisappear:animated];
}


-(NSString *)bindCode{
    if (!_bindCode) {
        NSNumber * date = [NSNumber numberWithDouble:((int)[[NSDate date] timeIntervalSince1970]%1024)];
        _bindCode =  [date stringValue];
    }
    return _bindCode;
}

#pragma mark - privateMethods

- (void)changeLinkMethods{
    
    _isMarvell = !_isMarvell;
    
    if (_isMarvell) {
        
        [self marvellStart];
        if(_easylink_config != nil){
            [_easylink_config stopTransmitting];
        }
        
    }else{
        
        [self easylinkStart];
        if(_marvell_config != nil){
            [_marvell_config stopTransmitting];
        }
        
    }
    
}


#pragma mark - Button Action

- (IBAction)handleBtnCancelClicked:(id)sender {
    
    [self handleBtnBackClicked];
}

#pragma mark - Private Function

- (void)marvellStart{
    
    if (_marvell_config == nil) {
        
        self.marvell_config = [[Marvell alloc] init];
        [_marvell_config startServerWithDelegate:self];
    }
    
    [self marvellStartTransmitting];
    
}

- (void)marvellStartTransmitting{
    
    Reachability *wifiReachability = [Reachability reachabilityForLocalWiFi];  //监测Wi-Fi连接状态
    [wifiReachability startNotifier];
    NetworkStatus netStatus = [wifiReachability currentReachabilityStatus];
    if ( netStatus == NotReachable ){
        
        // No activity if no wifi
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"WiFi not available. Please check your WiFi connection" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        
        return;
        
    }else {
        if (_isWifiOpen == NO) {
            
            _isWifiOpen = YES;
            
        }
    }
    
    _marvell_config.wifiSSID = [_marvell_config currentWifiSSID];
    _marvell_config.wifiPassWord = [_wifiPWD length] ? _wifiPWD : @"";
    
    if (_type == ToySetType) {
        
        [_marvell_config startTransmitting:NO];
        
    }else{
        
        [_marvell_config startTransmitting:YES];
        
    }
    
}



- (void)easylinkStart{
    
    if( _easylink_config == nil){
        self.easylink_config = [[EASYLINK alloc]init];
        [_easylink_config startFTCServerWithDelegate:self];
    }
    
    [self startTransmitting];
    
}

- (void)startTransmitting{
    
    NSArray *wlanConfigArray;
    
    Reachability *wifiReachability = [Reachability reachabilityForLocalWiFi];  //监测Wi-Fi连接状态
    [wifiReachability startNotifier];
    NetworkStatus netStatus = [wifiReachability currentReachabilityStatus];
    if ( netStatus == NotReachable ){
        
        // No activity if no wifi
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"WiFi not available. Please check your WiFi connection" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        
        return;
        
    }else {
        if (_isWifiOpen == NO) {
            
            _isWifiOpen = YES;
            [_deviceIPConfig setObject:@YES forKey:@"DHCP"];
            [_deviceIPConfig setObject:[EASYLINK getIPAddress] forKey:@"IP"];
            [_deviceIPConfig setObject:[EASYLINK getNetMask] forKey:@"NetMask"];
            [_deviceIPConfig setObject:[EASYLINK getGatewayAddress] forKey:@"GateWay"];
            [_deviceIPConfig setObject:[EASYLINK getGatewayAddress] forKey:@"DnsServer"];
            
        }
    }
    
    NSString *ssid = [_wifiSSID length] ? _wifiSSID : @"";
    NSString *passwordKey = [_wifiPWD length] ? _wifiPWD : @"";
    NSString *userInfo = [self getSendText];
    NSNumber *dhcp = [NSNumber numberWithBool:[[_deviceIPConfig objectForKey:@"DHCP"] boolValue]];
    NSString *ipString = [[_deviceIPConfig objectForKey:@"IP"] length] ? [_deviceIPConfig objectForKey:@"IP"] : @"";
    NSString *netmaskString = [[_deviceIPConfig objectForKey:@"NetMask"] length] ? [_deviceIPConfig objectForKey:@"NetMask"] : @"";
    NSString *gatewayString = [[_deviceIPConfig objectForKey:@"GateWay"] length] ? [_deviceIPConfig objectForKey:@"GateWay"] : @"";
    NSString *dnsString = [[_deviceIPConfig objectForKey:@"DnsServer"] length] ? [_deviceIPConfig objectForKey:@"DnsServer"] : @"";
    if([[_deviceIPConfig objectForKey:@"DHCP"] boolValue] == YES) ipString = @"";
    
    wlanConfigArray = [NSArray arrayWithObjects: ssid, passwordKey, dhcp, ipString, netmaskString, gatewayString, dnsString, nil];
    if(userInfo!=nil){
        const char *temp = [userInfo cStringUsingEncoding:NSUTF8StringEncoding];
        [_easylink_config prepareEasyLinkV2_withFTC:wlanConfigArray info:[NSData dataWithBytes:temp length:strlen(temp)]];
    }else{
        [_easylink_config prepareEasyLinkV2_withFTC:wlanConfigArray info:nil];
    }
    
    [_easylink_config transmitSettings];
    
}

-(NSString *)getSendText{
    
    NSString *t_ip = [ShareFun getIPWithHostName:ND_SERVERURL_IP];
    
    if (ND_SERVERURL_TYPE == 1) {
        
        t_ip = [ShareFun getIPWithHostName:ND_SERVERURL_IP];
        
    }else{
        
        t_ip = ND_SERVERURL_IP;
        
    }
    
    NSLog(@"%@",_bindCode);
    
    if (_type == ToySetType) {
        
        return [NSString stringWithFormat:@"ND,0,%@,%@,%@,B,%@",t_ip,ND_SERVERURL_PORT,[[ShareValue sharedShareValue].user_id stringValue],self.bindCode];
        
    }else{
        
        return [NSString stringWithFormat:@"ND,0,%@,%@,%@,C,%@",t_ip,ND_SERVERURL_PORT,[[ShareValue sharedShareValue].user_id stringValue],self.bindCode];
        
    }
    
}




-(void)loadToyFind{
    
    __weak __typeof(*& self) weakSelf = self;
    
    NDToyFindParams *params = [[NDToyFindParams alloc] init];
    params.bind_code = @([self.bindCode intValue]);
    [NDToyAPI toyFindWithParams:params completionBlockWithSuccess:^(Toy *data) {
        
        if (data) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [ShowHUD showSuccess:NSLocalizedString(@"配置成功", nil) configParameter:^(ShowHUD *config) {
            } duration:0.5 inView:self.view];
            
            // 保存为当前玩具
            
            [ShareValue sharedShareValue].toyDetail = data;
            
            // 释放easylink
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (weakSelf.easyLinkTimeOut.isValid) {
                    [weakSelf.easyLinkTimeOut invalidate];
                    weakSelf.easyLinkTimeOut = nil;
                }
                
                if (weakSelf.changeLink.isValid) {
                    [weakSelf.changeLink invalidate];
                    weakSelf.changeLink = nil;
                }
                
                
                if (weakSelf.marvell_config != nil) {
                    
                    [_marvell_config stopTransmitting];
                    [_marvell_config closeServer];
                    _marvell_config = nil;
                    
                }
                
                if( weakSelf.easylink_config != nil){
                    
                    [weakSelf.easylink_config stopTransmitting];
                    [weakSelf.easylink_config closeFTCServer];
                    weakSelf.easylink_config = nil;
                    
                }
                
            });
            
            ToyInfoSettingVC *toyInfoSettingVC = [[ToyInfoSettingVC alloc] init];
            toyInfoSettingVC.toy = data;
            [weakSelf.navigationController pushViewController:toyInfoSettingVC animated:YES];
        
        }else{
            
            if (!weakSelf.isTimeOut) {
                
                [[GCDQueue mainQueue] execute:^{
                    
                    [weakSelf loadToyFind];
                    
                } afterDelay:5 * NSEC_PER_SEC];
                
            }
        }
        
    } Fail:^(int code, NSString *failDescript) {
        
        if(code == 611){
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [ShowHUD showError:NSLocalizedString(@"玩具绑定失败", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
            
            if (weakSelf.marvell_config != nil) {
                
                [_marvell_config stopTransmitting];
                [_marvell_config closeServer];
                _marvell_config = nil;
                
            }
            
            if( weakSelf.easylink_config != nil){
                
                [weakSelf.easylink_config stopTransmitting];
                [weakSelf.easylink_config closeFTCServer];
                weakSelf.easylink_config = nil;
                
            }
            
            if (weakSelf.easyLinkTimeOut.isValid) {
                [weakSelf.easyLinkTimeOut invalidate];
                weakSelf.easyLinkTimeOut = nil;
            }
            
        }else{
            
            if (!weakSelf.isTimeOut) {
                
                [[GCDQueue mainQueue] execute:^{
                    
                    [weakSelf loadToyFind];
                    
                } afterDelay:5 * NSEC_PER_SEC];
                
            }
        }
        
    }];
    
}

#pragma mark - NSNotification

-(void)receiveWifiNotification:(NSNotification *)notification{
    
    NSDictionary *dict = notification.userInfo ;
    NSString *t_type = [dict objectForKey:@"type"];
    if (t_type && [t_type isEqual:@"wifi"]) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if(_type == ToyWifiSetType){
            
            [ShowHUD showSuccess:NSLocalizedString(@"配置成功", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
    
            [[GCDQueue mainQueue] execute:^{
                
                for (UIViewController *t_vc in self.navigationController.viewControllers) {
                    
                    if ([t_vc isKindOfClass:[self.navigationController.viewControllers[self.navigationController.viewControllers.count-4] class]]) {
                        [self.navigationController popToViewController:t_vc animated:YES];
                        return;
                    }
                }
                
            } afterDelay:1.5f*NSEC_PER_SEC];
            
        }
        
    }
}


#pragma mark - linkTimeOut

- (void)configTimeOut{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    self.isTimeOut = YES;
    
    [ShowHUD showTextOnly:NSLocalizedString(@"配置超时", nil) configParameter:^(ShowHUD *config) {
    } duration:3.f inView:self.view];
    
    [self marvellConfigTimeOut];
    
    [self easyLinkConfigTimeOut];
    
    if (self.easyLinkTimeOut.isValid) {
        [self.easyLinkTimeOut invalidate];
        self.easyLinkTimeOut = nil;
    }
    
    if (self.changeLink.isValid) {
        [self.changeLink invalidate];
        self.changeLink = nil;
    }
    
    [[GCDQueue mainQueue] execute:^{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } afterDelay:3.f * NSEC_PER_SEC];
    
    
}



#pragma mark - marvellDelegate

- (void)marvellConfigTimeOut{
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if( weakSelf.marvell_config != nil){
            
            [_marvell_config stopTransmitting];
            [_marvell_config closeServer];
            _marvell_config = nil;
            
        }
        
    });
    
}

- (NSData *)onServerSendMessage{
    
    
    if (_type == ToySetType) {
        
        int bindCode =  [self.bindCode intValue];
        
        Byte *bytebuffer  = alloca(24);
        
        BytePtr ptr = bytebuffer;
        short *cmd = (short *)ptr;
        *cmd = ntohs(0x00e1);
        ptr += 2;
        short *whole_len = (short *)ptr;
        *whole_len = ntohs(20);
        ptr += 2;
        short *uid_header = (short *)ptr;
        *uid_header = ntohs(0xe100);
        ptr += 2;
        short *uid_len = (short *)ptr;
        *uid_len = ntohs(8);
        ptr += 2;
        long long *uid = (long long *)ptr;
        *uid = ntohll([[ShareValue sharedShareValue].user_id longLongValue]);
        ptr += 8;
        cmd = (short *)ptr;
        *cmd = ntohs(0xe101);
        ptr += 2;
        short *bingcode_len = (short *)ptr;
        *bingcode_len = ntohs(4);
        ptr += 2;
        *((int *)ptr) = ntohl(bindCode);
        
        NSData *data = [[NSData alloc] initWithBytes:bytebuffer length:24];
        
        return data;
        
    }else{
        
        return nil;
        
    }
    
}


#pragma mark - easylinkDelegate

- (void)onFoundByFTC:(NSNumber *)client currentConfig: (NSData *)config{
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [ShowHUD showTextOnly:NSLocalizedString(@"配置成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        if (weakSelf.easyLinkTimeOut.isValid) {
            [weakSelf.easyLinkTimeOut invalidate];
            weakSelf.easyLinkTimeOut = nil;
        }
        
        
        if( weakSelf.easylink_config != nil){
            
            [weakSelf.easylink_config stopTransmitting];
            [weakSelf.easylink_config closeFTCServer];
            weakSelf.easylink_config = nil;
            
        }
        
    });
}

- (void)onDisconnectFromFTC:(NSNumber *)client{
    
}

- (void)easyLinkConfigTimeOut {
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if( weakSelf.easylink_config != nil){
            
            [weakSelf.easylink_config stopTransmitting];
            [weakSelf.easylink_config closeFTCServer];
            weakSelf.easylink_config = nil;
            
        }
        
    });
    
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    if (_easyLinkTimeOut.isValid) {
        
        [_easyLinkTimeOut invalidate];
        _easyLinkTimeOut = nil;
        
    }
    
    if( _marvell_config != nil){
        
        [_marvell_config stopTransmitting];
        [_marvell_config closeServer];
        _marvell_config = nil;
        
    }
    
    if( _easylink_config != nil){
        
        [_easylink_config stopTransmitting];
        [_easylink_config closeFTCServer];
        _easylink_config = nil;
        
    }
    
    
    if (_changeLink.isValid) {
        
        [_changeLink invalidate];
        _changeLink = nil;
        
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
