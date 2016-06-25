//
//  WebSocketHelper.m
//  Talker
//
//  Created by ilikeido on 15/5/8.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "WebSocketHelper.h"
#import "SRWebSocket.h"
#import "NDBaseAPI.h"
#import "LK_NSDictionary2Object.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "ShareValue.h"
#import "ReceiveUtils.h"
#import "NDSystemAPI.h"

#define WEBSOCKETURL @"http://test.smart.99.com:8083/ws"
#define  NOLOGIN_ERROR 777



@interface WebSocketHelper()<SRWebSocketDelegate>

@property(nonatomic,strong) SRWebSocket *webSocket;
@property(nonatomic,assign) BOOL isLogined;
@property(nonatomic,strong) NSTimer *ackTImer;

@end

@implementation WebSocketHelper

SYNTHESIZE_SINGLETON_FOR_CLASS(WebSocketHelper)

-(id)init{
    self = [super init];
    if (self) {
        self.serverUrl = WEBSOCKETURL;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startServer) name:NOTIFCATION_LOGINED object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeServer) name:NOTIFCATION_LOGOUT object:nil];
    }
    return self;
}

-(void)ackAction{
    NSLog(@"{}");
    [_webSocket send:[NSString stringWithFormat:@"{}"]];
}

-(void)startServer{
    [self _reconnect];

}

-(void)closeServer{
    [self clearConnect];
    
}

- (void)_reconnect
{
    
   [self clearConnect];
    if ([ShareValue sharedShareValue].user_id) {
        [NDSystemAPI getWebSocketUrlCompletionBlockWithSuccess:^(NSString *url) {
            
            [self clearConnect];
            _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
            _webSocket.delegate = self;
            [_webSocket open];
            
        } Fail:^(int code, NSString *failDescript) {
            [self clearConnect];
            _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:WEBSOCKETURL]]];
            _webSocket.delegate = self;
            [_webSocket open];
        }];
    }else{
        
    }
}

-(void)clearConnect{
    if (self.ackTImer) {
        [self.ackTImer invalidate];
        self.ackTImer = nil;
    }
    if (_webSocket) {
        [_webSocket closeWithCode:100 reason:@"closeByUser"];
        _isLogined = NO;
    }
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket opend!");
    if (!_isLogined) {
        [self loginAction:webSocket];
        if (self.ackTImer) {
            [self.ackTImer invalidate];
            self.ackTImer = nil;
        }
        self.ackTImer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(ackAction) userInfo:nil repeats:YES];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_WEBSOKETRECONNECT object:nil];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@"didFailWithError!");

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startServer];
    });
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSString *string = message;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSString *type = [dict objectForKey:@"type"];
    NSNumber *idstring = [dict objectForKey:@"id"];
    
    if (idstring) {
        [self ackAction:webSocket withId:[idstring stringValue]];
    }
    if (type) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ReceiveUtils handleRemoteNotification:dict];
        });
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    
    if (code == NOLOGIN_ERROR) {
        _webSocket.delegate = nil;
        _webSocket = nil;
        return;
    }else if (code == 100) {
        _webSocket.delegate = nil;
        _webSocket = nil;
        return;
    }else{
//        [self startServer];
    }
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;
{
    NSLog(@"Websocket received pong");
}

#pragma mark - Login

+(void)filterParams:(NSMutableDictionary *)dict{
    unsigned int propertyCount = 0;
    static NSMutableArray *objectDefaultKeys ;
    if (objectDefaultKeys == nil) {
        objc_property_t *properties = class_copyPropertyList([NSObject class], &propertyCount);
        objectDefaultKeys = [[NSMutableArray alloc]init];
        for ( NSUInteger i = 0; i < propertyCount; i++ )
        {
            const char *	name = property_getName(properties[i]);
            NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            [objectDefaultKeys addObject:propertyName];
        }
        [objectDefaultKeys addObject:@"hash"];
        [objectDefaultKeys addObject:@"debugDescription"];
        [objectDefaultKeys addObject:@"description"];
        free(properties);
    }
    
    for (NSString *key in objectDefaultKeys) {
        [dict removeObjectForKey:key];
    }
}


-(void)loginAction:(SRWebSocket *)webSocket{
    
    NDBaseAPIRequest *apiRequest = [[NDBaseAPIRequest alloc]init];
    if (!apiRequest.request.user_id || apiRequest.request.user_id.length == 0) {
        [webSocket closeWithCode:NOLOGIN_ERROR reason:nil];
        return;
    }
    NSString *jpushid = [ShareValue sharedShareValue].miPushId;
    if (jpushid.length == 0) {
        jpushid = @"";
    }
    NSMutableDictionary *t_dic = [NSMutableDictionary new];
    [t_dic setObject:jpushid forKey:@"jpushid"];
    apiRequest.params = t_dic;
    [apiRequest setMethod:@"connect"];
    NSMutableDictionary *dict = (NSMutableDictionary *)[apiRequest lkDictionary];
    [[self class] filterParams:dict];
    NSString *jsonrpc = [self DataTOjsonString:dict];
    

    [webSocket send:jsonrpc];
    _isLogined = YES;
}


#pragma mark - ackAction

-(void)ackAction:(SRWebSocket *)webSocket withId:(NSString *)id{
    
    NDBaseAPIRequest *apiRequest = [[NDBaseAPIRequest alloc]init];
//    NDAPIRequest *apiRequest_t = [[NDAPIRequest alloc] init];
//    [apiRequest_t setApiPath:@"v1/account"];
//    [apiRequest setAPIRequest:apiRequest_t];
    apiRequest.params = @{@"id":id};
    [apiRequest setMethod:@"ackMsg"];
    NSMutableDictionary *dict = (NSMutableDictionary *)[apiRequest lkDictionary];

    [[self class] filterParams:dict];
    NSString *jsonrpc = [self DataTOjsonString:dict];
    
    [webSocket send:jsonrpc];
}

-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
