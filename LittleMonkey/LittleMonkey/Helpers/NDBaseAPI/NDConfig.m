//
//  NDConfig.m
//  HelloToy
//
//  Created by nd on 15/12/16.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDConfig.h"

@implementation NDConfig

NSString * ND_FILE_SERVERURL;
//图片文件服务器
NSString * ND_IMAGE_FILE_SERVERURL;
//业务服务器
 NSString * URL_SERVER_BASE;
//账号服务器
NSString * URL_SERVER_LOGIN_BASE;
//后台服务器
NSString * URL_SERVER_BACKGROUND;
NSString * BACKGROUND_PATH_FS ;
NSString * BACKGROUND_PATH_APPSTORE_FS;
NSString * BACKGROUND_PATH_GHOST;
NSString * BACKGROUND_PATH_APPSTORE_GHOST;
//DOWNLOAD协议
NSString * NDDOWNLOAD_SERVERURL;
//玩具连接端口
NSString * ND_SERVERURL_IP;
int ND_SERVERURL_TYPE;
NSString * ND_SERVERURL_PORT;
//第三方登录Key
NSString * APP_KEY;
NSString * SECRET_KEY;
NSString * UMKEY;
NSString * BAIDUMAP_APP_ID;
NSString * WEIXIN_APP_ID;
NSString * WEIXIN_APP_SECRET;

@end