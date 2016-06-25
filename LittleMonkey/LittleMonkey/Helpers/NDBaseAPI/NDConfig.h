//
//  NDConfig.h
//  Pods
//
//  Created by ilikeido on 14-12-5.
//
//

#import <Foundation/Foundation.h>

#define NDAPI_VERSION @"1.0"
#define NDAPI_JSONRPC @"2.0"
#define NDAPI_METHOD @"POST"

#define V1_API_TALK @"v1/talk"
#define V1_API_ACCOUNT @"v1/account"
#define V1_API_TALK_USER @"v1/talk/user"


#define NOTIFCATION_ERROR @"NOTIFCATION_ERROR"
#define ERROR_DESCRIPTION @"ERROR_DESCRIPTION"
#define ERROR_CODE @"ERROR_CODE"

@interface NDConfig : NSObject

extern NSString * ND_FILE_SERVERURL;
//图片文件服务器
extern NSString * ND_IMAGE_FILE_SERVERURL;
//业务服务器
extern NSString * URL_SERVER_BASE;
//账号服务器
extern NSString * URL_SERVER_LOGIN_BASE;
//后台服务器
extern NSString * URL_SERVER_BACKGROUND;
extern NSString * BACKGROUND_PATH_FS ;
extern NSString * BACKGROUND_PATH_APPSTORE_FS;
extern NSString * BACKGROUND_PATH_GHOST;
extern NSString * BACKGROUND_PATH_APPSTORE_GHOST;
//DOWNLOAD协议
extern NSString * NDDOWNLOAD_SERVERURL;
//玩具连接端口
extern NSString * ND_SERVERURL_IP;
extern int ND_SERVERURL_TYPE;
extern NSString * ND_SERVERURL_PORT;
//第三方登录Key
extern NSString * APP_KEY;
extern NSString * SECRET_KEY;
extern NSString * UMKEY;
extern NSString * BAIDUMAP_APP_ID;
extern NSString * WEIXIN_APP_ID;
extern NSString * WEIXIN_APP_SECRET;

@end
