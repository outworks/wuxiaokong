//
//  ShareValue.m
//  HelloToy
//
//  Created by nd on 15/4/21.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "ShareValue.h"
#import "UserDefaultsObject.h"


@implementation ShareValue

SYNTHESIZE_SINGLETON_FOR_CLASS(ShareValue)




-(void)setUser_id:(NSNumber *)user_id{
    
    [[UserDefaultsObject sharedUserDefaultsObject] setUser_id:user_id];
   
}

-(NSNumber *)user_id{
    
    return [UserDefaultsObject sharedUserDefaultsObject].user_id;
    
}

-(void)setGroup_id:(NSNumber *)group_id{
    
    [[UserDefaultsObject sharedUserDefaultsObject] setGroup_id:group_id];
    
}

-(NSNumber *)group_id{
    
    return [UserDefaultsObject sharedUserDefaultsObject].group_id;
    
}

-(void)setGroup_owner_id:(NSNumber *)group_owner_id{
    
    [[UserDefaultsObject sharedUserDefaultsObject] setGroup_owner_id:group_owner_id];
    
}

-(NSNumber *)group_owner_id{
    
    return [UserDefaultsObject sharedUserDefaultsObject].group_owner_id;
    
}


-(NSNumber *)collection_id{
    
    return [UserDefaultsObject sharedUserDefaultsObject].collection_id;
    
}

-(void)setCollection_id:(NSNumber *)collection_id{
    
    [[UserDefaultsObject sharedUserDefaultsObject] setCollection_id:collection_id];
    
}

-(void)setNetWork:(NSNumber *)netWork{
    
    [[UserDefaultsObject sharedUserDefaultsObject] setNetWork:netWork];
    
    UMKEY = @"53e9d973fd98c546ca00145e" ;
    BAIDUMAP_APP_ID = @"VZDTYqNYQBiIdtOSmttgdivy";
    WEIXIN_APP_ID = @"wxf21da2b328515533";
    WEIXIN_APP_SECRET = @"85b7c49bf57e55ba5775d1ee4e737d7c";
    
    ND_FILE_SERVERURL = @"http://longong.99.com";
    //图片文件服务器
    ND_IMAGE_FILE_SERVERURL = @"http://s.hello.99.com";
    
    //业务服务器
    URL_SERVER_BASE = @"http://s.hello.99.com:8031/";
    //账号服务器
    URL_SERVER_LOGIN_BASE = @"http://s.hello.99.com/";
    //后台服务器
    URL_SERVER_BACKGROUND = @"http://s.hello.99.com/";
    
    BACKGROUND_PATH_FS = @"/v1/fs/appVersion/16/ios/";
    BACKGROUND_PATH_APPSTORE_FS = @"/v1/fs/appVersion/16/ios_appstore/";
    BACKGROUND_PATH_GHOST = @"/v1/ghost/appVersion/16/ios/";
    BACKGROUND_PATH_APPSTORE_GHOST = @"/v1/ghost/appVersion/16/ios_appstore/";
    
    //DOWNLOAD协议
    NDDOWNLOAD_SERVERURL = @"http://s.hello.99.com/v2/homer/html/";
    //玩具连接端口
    ND_SERVERURL_IP = @"s.hello.99.com";
    ND_SERVERURL_TYPE = 1;
    ND_SERVERURL_PORT = @"8086";
    //第三方登录Key
    APP_KEY  = @"810505a9d69ad095c82fdfaed6989880";
    SECRET_KEY = @"dae6326cce36ccb728b0ee5053684e00";
    
}

-(NSNumber *)netWork{
    
    NSNumber *number = [UserDefaultsObject sharedUserDefaultsObject].netWork;
    
    UMKEY = @"53e9d973fd98c546ca00145e" ;
    BAIDUMAP_APP_ID = @"VZDTYqNYQBiIdtOSmttgdivy";
    WEIXIN_APP_ID = @"wxf21da2b328515533";
    WEIXIN_APP_SECRET = @"85b7c49bf57e55ba5775d1ee4e737d7c";
    
    ND_FILE_SERVERURL = @"http://longong.99.com";
    
    //图片文件服务器
    ND_IMAGE_FILE_SERVERURL = @"http://s.hello.99.com";
    
    //业务服务器
    URL_SERVER_BASE = @"http://s.hello.99.com:8031/";
    
    //账号服务器
    URL_SERVER_LOGIN_BASE = @"http://s.hello.99.com/";
    
    //后台服务器
    URL_SERVER_BACKGROUND = @"http://s.hello.99.com/";
    
    BACKGROUND_PATH_FS = @"/v1/fs/appVersion/16/ios/";
    BACKGROUND_PATH_APPSTORE_FS = @"/v1/fs/appVersion/16/ios_appstore/";
    BACKGROUND_PATH_GHOST = @"/v1/ghost/appVersion/16/ios/";
    BACKGROUND_PATH_APPSTORE_GHOST = @"/v1/ghost/appVersion/16/ios_appstore/";
    
    //DOWNLOAD协议
    NDDOWNLOAD_SERVERURL = @"http://s.hello.99.com/v2/homer/html/";
    
    //玩具连接端口
    ND_SERVERURL_IP = @"s.hello.99.com";
    ND_SERVERURL_TYPE = 1;
    ND_SERVERURL_PORT = @"8086";
    
    APP_KEY  = @"810505a9d69ad095c82fdfaed6989880";
    SECRET_KEY = @"dae6326cce36ccb728b0ee5053684e00";
    
    return number;
}

- (NSString *)miPushId{

    return [UserDefaultsObject sharedUserDefaultsObject].miPushId;
    
}

- (void)setMiPushId:(NSString *)miPushId{

    [[UserDefaultsObject sharedUserDefaultsObject] setMiPushId:miPushId];

}

@end
