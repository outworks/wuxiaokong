//
//  NDToyAPI.m
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "NDToyAPI.h"
#import <objc/runtime.h>
#import "ToyPlay.h"
#import "ToyDownloadInfo.h"

#pragma mark - 请求
@interface NDToyDetailRequest : NDAPIRequest

@property(nonatomic,strong) NDToyDetailParams *params;

@end

@implementation NDToyDetailRequest

-(NSString *)method{
    return URL_TOY_DETAIL;
}

@end

@interface NDToyFindRequest : NDAPIRequest

@property(nonatomic,strong) NDToyFindParams *params;

@end

@implementation NDToyFindRequest

-(NSString *)method{
    return URL_TOY_FIND;
}

@end

@interface NDToyUpdateRequest : NDAPIRequest

@property(nonatomic,strong) NDToyUpdateParams *params;

@end

@implementation NDToyUpdateRequest

-(NSString *)method{
    return URL_TOY_UPDATE;
}

@end


@interface NDToyDeleteRequest : NDAPIRequest

@property(nonatomic,strong) NDToyDeleteParams *params;

@end

@implementation NDToyDeleteRequest

-(NSString *)method{
    return URL_TOY_DELETE;
}

@end

@interface NDToyVersionRequest : NDAPIRequest

@property(nonatomic,strong) NDToyVersionParams *params;

@end

@implementation NDToyVersionRequest

-(NSString *)method{
    return URL_TOY_VERSION;
}

@end


@interface NDToyUpgradeRequest : NDAPIRequest

@property(nonatomic,strong) NDToyUpgradeParams *params;

@end

@implementation NDToyUpgradeRequest

-(NSString *)method{
    return URL_TOY_UPGRADE;
}

@end




@interface NDToyChangeModeRequest : NDAPIRequest

@property(nonatomic,strong) NDToyChangeModeParams *params;

@end

@implementation NDToyChangeModeRequest

-(NSString *)method{
    return URL_TOY_CHANGEMODE;
}

@end


#pragma mark - 玩具操作

@interface NDToyNotifyDownloadRequest : NDAPIRequest

@property(nonatomic,strong) NDToyNotifyDownloadParams *params;

@end

@implementation NDToyNotifyDownloadRequest

-(NSString *)method{
    return URL_TOY_NOTIFYDOWNLOAD;
}

@end


@interface NDToyQueryDownloadRequest : NDAPIRequest

@property(nonatomic,strong) NDToyQueryDownloadParams *params;

@end

@implementation NDToyQueryDownloadRequest

-(NSString *)method{
    return URL_TOY_QUERYDOWNLOAD;
}

@end

@interface NDToyPlayMediaRequest : NDAPIRequest

@property(nonatomic,strong) NDToyPlayMediaParams *params;

@end

@implementation NDToyPlayMediaRequest

-(NSString *)method{
    return URL_TOY_PLAYMEDIA;
}

@end

@interface NDToyChangeAlbumRequest : NDAPIRequest

@property(nonatomic,strong) NDToyChangeAlbumParams *params;

@end

@implementation NDToyChangeAlbumRequest

-(NSString *)method{
    return URL_TOY_CHANGEALBUM;
}

@end


@interface NDToyChangeThemeRequest : NDAPIRequest

@property(nonatomic,strong) NDToyChangeThemeParams *params;

@end

@implementation NDToyChangeThemeRequest

-(NSString *)method{
    return URL_TOY_CHANGETHEME;
}

@end


@interface NDToyThemeRequest : NDAPIRequest

@property(nonatomic,strong) NDToyThemeParams *params;

@end

@implementation NDToyThemeRequest

-(NSString *)method{
    return URL_TOY_THEME;
}

@end

@interface NDToyThemeListRequest : NDAPIRequest

@property(nonatomic,strong) NDToyThemeListParams *params;

@end

@implementation NDToyThemeListRequest

-(NSString *)method{
    return URL_TOY_THEMELIST;
}

@end


@interface NDToySettingRequest : NDAPIRequest

@property(nonatomic,strong) NDToySettingParams *params;

@end

@implementation NDToySettingRequest

-(NSString *)method{
    return URL_TOY_SETTING;
}

@end

@interface NDToyChangeSettingRequest : NDAPIRequest

@property(nonatomic,strong) NDToyChangeSettingParams *params;

@end

@implementation NDToyChangeSettingRequest

-(NSString *)method{
    return URL_TOY_CHANGESETTING;
}

@end

@interface NDToyControlPlayRequest : NDAPIRequest

@property(nonatomic,strong) NDToyControlPlayParams *params;

@end

@implementation NDToyControlPlayRequest

-(NSString *)method{
    return URL_TOY_CONTROLPLAY;
}

@end

@interface NDToyDataKeyValueRequest : NDAPIRequest

@property(nonatomic,strong) NDToyDataKeyValueParams *params;

@end

@implementation NDToyDataKeyValueRequest

-(NSString *)method{
    return URL_TOY_QUERYDATA;
}

@end

@interface NDToyElectricityRequest : NDAPIRequest

@property(nonatomic,strong) NDToyElectricityParams *params;

@end

@implementation NDToyElectricityRequest

-(NSString *)method{
    return URL_TOY_ELECTRICITY;
}

@end

@interface NDToyStatRequest : NDAPIRequest

@property(nonatomic,strong) NDToyStatParams *params;

@end

@implementation NDToyStatRequest

-(NSString *)method{

    return URL_TOY_STAT;
    
}

@end

@interface NDToyPlayRecentlyRequest : NDAPIRequest

@property(nonatomic,strong) NDToyPlayRecentlyParams *params;

@end

@implementation NDToyPlayRecentlyRequest

-(NSString *)method{
    
    return URL_TOY_PLAYRECENTLY;

}

@end


@interface NDToyContactListRequest : NDAPIRequest

@property(nonatomic,strong) NDToyContactListParams *params;

@end

@implementation NDToyContactListRequest

-(NSString *)method{
    
    return URL_TOY_CONTACTLIST;
    
}

@end

@interface NDToyGmailListRequest : NDAPIRequest

@property(nonatomic,strong) NDToyGmailListParams *params;

@end

@implementation NDToyGmailListRequest

-(NSString *)method{
    
    return URL_TOY_GMAILLIST;
    
}

@end

@interface NDToyQueryDownloadAlbumRequest : NDAPIRequest

@property(nonatomic,strong) NDToyQueryDownloadAlbumParams *params;

@end


@implementation NDToyQueryDownloadAlbumRequest

-(NSString *)method{

    return URL_TOY_QUERY_DOWMLAOD_ALBUM;
    
}

@end

@interface NDToyDownloadInfoRequest : NDAPIRequest

@property(nonatomic,strong) NDToyDownloadInfoParams *params;

@end

@implementation NDToyDownloadInfoRequest

-(NSString *)method{
    return URL_TOY_DOWNLOADINFO;
}

@end


@interface NDToyMediaDeleteRequest : NDAPIRequest

@property(nonatomic,strong)NDToyMediaDeleteParams *params;

@end

@implementation NDToyMediaDeleteRequest

-(NSString *)method{
    return URL_TOY_MEDIADELETE;
}

@end


@interface NDToyAlbumDetailRequest : NDAPIRequest

@property(nonatomic,strong) NDToyAlbumDetailParams *params;

@end


@implementation NDToyAlbumDetailRequest

-(NSString *)method{
    
    return URL_TOY_ALBUM_DETAIL;
    
}

@end


@interface NDToyAlbumDownloadRequest : NDAPIRequest

@property(nonatomic,strong) NDToyAlbumDownloadParams *params;

@end

@implementation NDToyAlbumDownloadRequest

-(NSString *)method{
    
    return URL_TOY_ALBUMDOWNLOAD;
    
}

@end


#pragma mark - 请求参数

@implementation NDToyDetailParams
@end

@implementation NDToyFindParams
@end

@implementation NDToyUpdateParams
@end

@implementation NDToyDeleteParams
@end

@implementation NDToyNotifyDownloadParams
@end

@implementation NDToyQueryDownloadParams
@end

@implementation NDToyDownloadInfoParams

@end

@implementation NDToyPlayMediaParams
@end

@implementation NDToyChangeAlbumParams
@end

@implementation NDToyVersionParams

@end

@implementation NDToyUpgradeParams

@end

@implementation NDToyChangeModeParams
@end

@implementation NDToyChangeThemeParams
@end

@implementation NDToyThemeParams
@end

@implementation NDToyThemeListParams
@end

@implementation NDToySettingParams
@end

@implementation NDToyChangeSettingParams
@end

@implementation NDToyElectricityParams
@end

@implementation NDToyControlPlayParams
@end

@implementation NDToyDataKeyValueParams
@end

@implementation NDToyStatParams
@end

@implementation NDToyPlayRecentlyParams
@end

@implementation NDToyContactListParams
@end

@implementation NDToyGmailListParams
@end

@implementation NDToyAlbumDownloadParams

@end

@implementation NDToyQueryDownloadAlbumParams

-(id)init{
    self = [super init];
    if (self) {
        _rows = 20;
        _page = 1;
    }
    return self;
}

@end

@implementation NDToyAlbumDetailParams

-(id)init{
    self = [super init];
    if (self) {
        _rows = 20;
        _page = 1;
    }
    return self;
}

@end


@implementation NDToyMediaDeleteParams

@end


#pragma mark - 请求返回结果
@implementation NDToyElectricityResult

@end

@implementation NDToyChangeModeResult

@end

@implementation NDToyContactListResult

+(Class)__contactListClass{
    return [ContactGmail class];
}

@end

@implementation NDToyGmailListResult

+(Class)__gmailListClass{
    return [Gmail class];
}

@end

@implementation NDToyQueryDownloadAlbumResult

@end

#pragma mark - 请求接口


@implementation NDToyAPI


/**
 *  查询玩具详情
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)toyDetailWithParams:(NDToyDetailParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDToyDetailRequest *request = [[NDToyDetailRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[Toy class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}


/**
 *  查询玩具绑定结果
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)toyFindWithParams:(NDToyFindParams *)params completionBlockWithSuccess:(void(^)(Toy *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDToyFindRequest *request = [[NDToyFindRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[Toy class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        Toy *data = (Toy *)result;
        [data save];
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  修改玩具信息
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)toyUpdateWithParams:(NDToyUpdateParams *)params completionBlockWithSuccess:(void(^)(Toy *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDToyUpdateRequest *request = [[NDToyUpdateRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[Toy class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        Toy *data = (Toy *)result;
        [data save];
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}


/**
 *  删除玩具
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)toyDeleteWithParams:(NDToyDeleteParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDToyDeleteRequest *request = [[NDToyDeleteRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

/**
 *  通知下载
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)toyNotifyDownloadWithParams:(NDToyNotifyDownloadParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDToyNotifyDownloadRequest *request = [[NDToyNotifyDownloadRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];


}

/**
 *  查询下载
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)toyQueryDownloadWithParams:(NDToyQueryDownloadParams *)params completionBlockWithSuccess:(void(^)(AlbumMedia *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDToyQueryDownloadRequest *request = [[NDToyQueryDownloadRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[AlbumMedia class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        AlbumMedia *data = (AlbumMedia *)result;
//        [data save];
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];


}

/**
 *  点播
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)toyPlayMediaWithParams:(NDToyPlayMediaParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDToyPlayMediaRequest *request = [[NDToyPlayMediaRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  切换专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)toyChangeAlbumWithParams:(NDToyChangeAlbumParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDToyChangeAlbumRequest *request = [[NDToyChangeAlbumRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

/**
 *  查询版本
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyVersionWithParams:(NDToyVersionParams *)params completionBlockWithSuccess:(void(^)(ToyUpdate *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDToyVersionRequest *request = [[NDToyVersionRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[ToyUpdate class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        ToyUpdate *data = (ToyUpdate *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];


}

/**
 *  升级硬件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyUpgradeWithParams:(NDToyUpgradeParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDToyUpgradeRequest *request = [[NDToyUpgradeRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];


}


/**
 *  切换模式
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyChangeModeWithParams:(NDToyChangeModeParams *)params completionBlockWithSuccess:(void(^)(NDToyChangeModeResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDToyChangeModeRequest *request = [[NDToyChangeModeRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NDToyChangeModeResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess((NDToyChangeModeResult *)result);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  切换主题
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyChangeThemeWithParams:(NDToyChangeThemeParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDToyChangeThemeRequest *request = [[NDToyChangeThemeRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  查询主题
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyThemeWithParams:(NDToyThemeParams *)params completionBlockWithSuccess:(void(^)(Theme *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDToyThemeRequest *request = [[NDToyThemeRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[Theme class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        Theme *data = (Theme *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}


/**
 *  查询主题列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyThemeListWithParams:(NDToyThemeListParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDToyThemeListRequest *request = [[NDToyThemeListRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[Theme class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}


/**
 *  查询设置
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toySettinWithParams:(NDToySettingParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDToySettingRequest *request = [[NDToySettingRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[Setting class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}


/**
 *  修改设置
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyChangeSettinWithParams:(NDToyChangeSettingParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDToyChangeSettingRequest *request = [[NDToyChangeSettingRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  播放上一首下一首
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyControlPlayWithParams:(NDToyControlPlayParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDToyControlPlayRequest *request = [[NDToyControlPlayRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

/**
 *  查询玩具数据
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyDataKeyValueParams:(NDToyDataKeyValueParams *)params completionBlockWithSuccess:(void(^)(ToyStatus *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDToyDataKeyValueRequest *request = [[NDToyDataKeyValueRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[ToyKeyValueData class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        ToyKeyValueData *tempData = (ToyKeyValueData *)result;
        sucess(tempData.toyStatus);
        
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  查询玩具电量
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyElectricityWithParams:(NDToyElectricityParams *)params completionBlockWithSuccess:(void(^)(NDToyElectricityResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDToyElectricityRequest *request = [[NDToyElectricityRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NDToyElectricityResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        
        NDToyElectricityResult *data = (NDToyElectricityResult *)result;
        sucess(data);
        
    } Fail:^(int code, NSString *failDescript) {
        
        fail(code,failDescript);
        
    }];
    
}

/**
 *  查询玩具统计数据
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyStatParams:(NDToyStatParams *)params completionBlockWithSuccess:(void(^)(ToyStat *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{


    NDToyStatRequest *request = [[NDToyStatRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[ToyStat class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        
        ToyStat *data = (ToyStat *)result;
        sucess(data);
        
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];



}

/**
 *  查询玩具播放记录
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */


+(void)toyPlayRecentlyWithParams:(NDToyPlayRecentlyParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDToyPlayRecentlyRequest *request = [[NDToyPlayRecentlyRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[ToyPlay class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

/**
 *  查询联系人列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyContactListWithParams:(NDToyContactListParams *)params completionBlockWithSuccess:(void(^)(NDToyContactListResult *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDToyContactListRequest *request = [[NDToyContactListRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NDToyContactListResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NDToyContactListResult *data = (NDToyContactListResult *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  查询聊天记录
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyGmailListWithParams:(NDToyGmailListParams *)params completionBlockWithSuccess:(void(^)(NDToyGmailListResult *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDToyGmailListRequest *request = [[NDToyGmailListRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NDToyGmailListResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NDToyGmailListResult *data = (NDToyGmailListResult *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  查询下载的专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyQueryDownloadAlbumWithParams:(NDToyQueryDownloadAlbumParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDToyQueryDownloadAlbumRequest *request = [[NDToyQueryDownloadAlbumRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[DownloadAlbumInfo class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  查询专辑已下载的媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyAlbumDetailWithParams:(NDToyAlbumDetailParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDToyAlbumDetailRequest *request = [[NDToyAlbumDetailRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[DownloadMediaInfo class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}




/**
 *  下载专辑到玩具
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyAlbumDownloadWithParams:(NDToyAlbumDownloadParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDToyAlbumDownloadRequest *request = [[NDToyAlbumDownloadRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

/**
 *  玩具下载情况
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)toyQueryDownloadInfoWithParams:(NDToyDownloadInfoParams *)params completionBlockWithSuccess:(void(^)(ToyDownloadInfo *info))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDToyDownloadInfoRequest *request = [[NDToyDownloadInfoRequest alloc]init];
    request.params = params;
    [self request:request resultClass:[ToyDownloadInfo class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess((ToyDownloadInfo *)result);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  玩具删除已下载媒体情况
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)toyMediaDeleteWithParams:(NDToyMediaDeleteParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDToyMediaDeleteRequest *request = [[NDToyMediaDeleteRequest alloc]init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];


}

@end
