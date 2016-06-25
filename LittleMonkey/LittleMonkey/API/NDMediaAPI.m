//
//  NDMediaAPI.m
//  HelloToy
//
//  Created by nd on 15/4/29.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "NDMediaAPI.h"

#pragma mark - 请求

@interface NDMediaAddRequest : NDAPIRequest

@property(nonatomic,strong) NDMediaAddParams *params;

@end

@implementation NDMediaAddRequest

-(NSString *)method{
    return URL_MEDIA_ADD;
}

@end

@interface NDMediaDeleteRequest : NDAPIRequest

@property(nonatomic,strong) NDMediaDeleteParams *params;

@end

@implementation NDMediaDeleteRequest

-(NSString *)method{
    return URL_MEDIA_DELETE;
}

@end

@interface NDMediaQueryRequest : NDAPIRequest

@property(nonatomic,strong) NDMediaQueryParams *params;

@end

@implementation NDMediaQueryRequest

-(NSString *)method{
    return URL_MEDIA_QUERY;
}

@end

@interface NDMediaQueryByIdRequest : NDAPIRequest

@property(nonatomic,strong) NDMediaQueryByIdParams *params;

@end

@implementation NDMediaQueryByIdRequest

-(NSString *)method{
    return URL_MEDIA_INFO;
}

@end

@interface NDMediaUndownloadRequest : NDAPIRequest

@property(nonatomic,strong) NDMediaUndownloadParams *params;

@end

@implementation NDMediaUndownloadRequest

-(NSString *)method{
    return URL_MEDIA_UNDOWNLOAD;
}

@end

@interface NDMediaQueryDownloadRequest :NDAPIRequest

@property(nonatomic,strong) NDMediaQueryDownloadParams *params;

@end

@implementation NDMediaQueryDownloadRequest

-(NSString *)method{
    return URL_TOY_QUARYDOWNLOADMEDIA;
}

@end


@interface NDMediaLostRequest :NDAPIRequest

@property(nonatomic,strong) NDMediaLostParams *params;

@end

@implementation NDMediaLostRequest

-(NSString *)method{
    return URL_MEDIA_LOST;
}

@end

#pragma mark - 请求参数

@implementation NDMediaAddParams
@end

@implementation NDMediaDeleteParams
@end

@implementation NDMediaQueryParams
@end

@implementation NDMediaQueryByIdParams
@end

@implementation NDMediaUndownloadParams

@end

@implementation NDMediaQueryDownloadParams

-(id)init{
    self = [super init];
    if (self) {
        _page = 1;
        _rows = 20;
    }
    return self;
}

@end

@implementation NDMediaLostParams

@end

#pragma mark - 返回结果


#pragma mark - 请求接口

@implementation NDMediaAPI

/**
 *  增加媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)mediaAddWithParams:(NDMediaAddParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDMediaAddRequest *request = [[NDMediaAddRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];




}

/**
 *  删除媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)mediaDeleteWithParams:(NDMediaDeleteParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDMediaDeleteRequest *request = [[NDMediaDeleteRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  查询媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)mediaQueryWithParams:(NDMediaQueryParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDMediaQueryRequest *request = [[NDMediaQueryRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[AlbumMedia class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  根据id查询媒体详情
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)mediaQueryByIdWithParams:(NDMediaQueryByIdParams *)params completionBlockWithSuccess:(void(^)(AlbumMedia *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDMediaQueryByIdRequest *request = [[NDMediaQueryByIdRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[AlbumMedia class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        AlbumMedia *data = (AlbumMedia *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  未下载媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)mediaUndownloadWithParams:(NDMediaUndownloadParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDMediaUndownloadRequest *request = [[NDMediaUndownloadRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[Download class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  查询下载媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)queryDownloadWithParams:(NDMediaQueryDownloadParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDMediaQueryDownloadRequest *request = [[NDMediaQueryDownloadRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[AlbumMedia class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

/**
 *
 *  添加专辑查询
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 *
 */

+(void)mediaLostWithParams:(NDMediaLostParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDMediaLostRequest *request = [[NDMediaLostRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[AlbumMedia class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}


@end
