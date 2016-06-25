//
//  NDAlbumAPI.m
//  HelloToy
//
//  Created by nd on 15/4/29.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "NDAlbumAPI.h"
#import "MediaDownloadStatus.h"

#pragma mark - 请求

@interface NDAlbumAddRequest : NDAPIRequest

@property(nonatomic,strong) NDAlbumAddParams *params;

@end

@implementation NDAlbumAddRequest

-(NSString *)method{
    return URL_ALBUM_ADD;
}

/**
 *  相应API路径
 *
 */
-(NSString *)_apiPath{
    return V1_API_TALK_USER;
}

//-(NSString *)_serverUrl{
//    return URL_SERVER_LOGIN_BASE;
//    
//}

@end


@interface NDAlbumDeleteRequest : NDAPIRequest

@property(nonatomic,strong) NDAlbumDeleteParams *params;

@end

@implementation NDAlbumDeleteRequest

-(NSString *)method{
    return URL_ALBUM_DELETE;
}
@end

@interface NDAlbumUpdateRequest : NDAPIRequest

@property(nonatomic,strong) NDAlbumUpdateParams *params;

@end

@implementation NDAlbumUpdateRequest

-(NSString *)method{
    return URL_ALBUM_UPDATE;
}
@end

@interface NDAlbumQueryRequest : NDAPIRequest

@property(nonatomic,strong) NDAlbumQueryParams *params;

@end

@implementation NDAlbumQueryRequest

-(NSString *)method{
    return URL_ALBUM_QUERY;
}

@end

@interface NDAlbumDetailRequest : NDAPIRequest

@property(nonatomic,strong) NDAlbumDetailParams *params;

@end

@implementation NDAlbumDetailRequest

-(NSString *)method{
    return URL_ALBUM_DETAIL;
}

@end

@interface NDAlbumAddMediaRequest : NDAPIRequest

@property(nonatomic,strong) NDAlbumAddMediaParams *params;

@end

@implementation NDAlbumAddMediaRequest

-(NSString *)method{
    return URL_ALBUM_ADDMEDIA;
}

@end

@interface NDAlbumDelMediaRequest : NDAPIRequest

@property(nonatomic,strong) NDAlbumDelMediaParams *params;

@end

@implementation NDAlbumDelMediaRequest

-(NSString *)method{
    return URL_ALBUM_DELMEDIA;
}

@end

@interface NDAlbumInfoByIdRequest : NDAPIRequest

@property(nonatomic,strong) NDAlbumInfoByIdParams *params;

@end

@implementation NDAlbumInfoByIdRequest

-(NSString *)method{
    return URL_ALBUM_INFO;
}

@end

@interface NDQueryMediaStatusRequest : NDAPIRequest

@property(nonatomic,strong) NDQueryMediaStatusParams *params;

@end

@implementation NDQueryMediaStatusRequest

-(NSString *)method{
    return URL_TOY_QUERY_MEDIA_STATUS;
}
@end

@interface NDMediaDownloadRequest : NDAPIRequest

@property(nonatomic,strong) NDMediaDownloadParams *params;

@end

@implementation NDMediaDownloadRequest

-(NSString *)method{
    return URL_TOY_MEDIA_DOWNLOAD;
}
@end


#pragma mark - 请求参数
@implementation NDAlbumAddParams
@end

@implementation NDAlbumDeleteParams
@end

@implementation NDAlbumUpdateParams
@end

@implementation NDAlbumQueryParams
@end

@implementation NDAlbumDetailParams
@end

@implementation NDAlbumAddMediaParams
@end

@implementation NDAlbumDelMediaParams
@end

@implementation NDAlbumInfoByIdParams
@end

@implementation NDQueryMediaStatusParams
@end

@implementation NDMediaDownloadParams
@end

#pragma mark - 返回结果


#pragma mark - 请求接口

@implementation NDAlbumAPI

/**
 *  增加专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)albumAddWithParams:(NDAlbumAddParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDAlbumAddRequest *request = [[NDAlbumAddRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];



}

/**
 *  删除专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)albumDeleteWithParams:(NDAlbumDeleteParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDAlbumDeleteRequest *request = [[NDAlbumDeleteRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  修改专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)albumUpdateWithParams:(NDAlbumUpdateParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDAlbumUpdateRequest *request = [[NDAlbumUpdateRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}


/**
 *  查询专辑列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)albumQueryWithParams:(NDAlbumQueryParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDAlbumQueryRequest *request = [[NDAlbumQueryRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[AlbumInfo class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        for (AlbumInfo *albumInfo in data) {
            [albumInfo save];
        }
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}


/**
 *  查询专辑中详情媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)albumDetailWithParams:(NDAlbumDetailParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDAlbumDetailRequest *request = [[NDAlbumDetailRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[AlbumMedia class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
//        for (AlbumMedia *mediaInfo in data) {
//            [mediaInfo save];
//        }
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  给专辑添加媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)albumAddMediaWithParams:(NDAlbumAddMediaParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDAlbumAddMediaRequest *request = [[NDAlbumAddMediaRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  删除专辑中的媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)albumDelMediaWithParams:(NDAlbumDelMediaParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDAlbumDelMediaRequest *request = [[NDAlbumDelMediaRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  根据id查询专辑信息
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)albumInfoByIdWithParams:(NDAlbumInfoByIdParams *)params completionBlockWithSuccess:(void(^)(AlbumInfo *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDAlbumInfoByIdRequest *request = [[NDAlbumInfoByIdRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[AlbumInfo class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        AlbumInfo *data = (AlbumInfo *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  查询媒体是否已经下载到玩具
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)mediaStatusQueryWithParams:(NDQueryMediaStatusParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDQueryMediaStatusRequest *request = [[NDQueryMediaStatusRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[MediaDownloadStatus class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  下载媒体到玩具
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)mediaDownloadWithParams:(NDMediaDownloadParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDMediaDownloadRequest *request = [[NDMediaDownloadRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

@end
