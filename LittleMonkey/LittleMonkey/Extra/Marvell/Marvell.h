//
//  Marvell.h
//  HelloToy
//
//  Created by huanglurong on 16/2/23.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#include <netdb.h>
#include <AssertMacros.h>
#import <CFNetwork/CFNetwork.h>
#include <netinet/in.h>
#include <errno.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#if TARGET_IPHONE_SIMULATOR
#import <net/route.h>
#else
#import "route.h"
#endif

#define SS_PORT 9091

@protocol MarvellDelegate
@optional

- (NSData *)onServerSendMessage;

@end



@interface Marvell : NSObject

@property(strong,nonatomic) NSString *wifiSSID;
@property(strong,nonatomic) NSString *wifiPassWord;
@property(nonatomic,strong) NSString *wifiBSSID;
@property(strong,nonatomic) AsyncSocket *serverSocket; //运用手机wifiSSID构建起来的服务器
@property(nonatomic,weak) id<MarvellDelegate> delegate;

#pragma mark - public

- (void)startTransmitting:(BOOL)isWifi;
- (void)stopTransmitting;

- (void)startServerWithDelegate:(id)delegate;
- (void)closeServer;

-(NSString *)currentWifiSSID;


#pragma mark - tool

+ (NSString *)ssidForConnectedNetwork;
+ (int)getIPAddress;
+ (NSString *)getNetMask;

@end
