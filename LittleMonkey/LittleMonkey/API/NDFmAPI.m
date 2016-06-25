//
//  NDFmAPI.m
//  HelloToy
//
//  Created by nd on 15/10/15.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "NDFmAPI.h"
#import "AlbumInfo.h"


@implementation NDFmQueryParams
@end

@implementation NDFmSubscribeParams
@end

@implementation NDFmQuerySubParams
@end

@implementation NDFmCancelParams
@end

@implementation NDFmDetailParams
@end

@implementation NDFmCommentListParams
@end

@implementation NDFmCommentParams
@end

@implementation NDFmFavParams
@end

@implementation NDFmHotAlbumParams
@end

@implementation NDFmRecommendAlbumParams
@end

@implementation NDFmTagAlbumParams
@end

@implementation NDFmRecommendParams
@end


@interface NDFmQueryRequest : NDAPIRequest

@property (nonatomic,strong) NDFmQueryParams *params;

@end


@implementation NDFmQueryRequest

-(NSString *)method{
    return URL_FM_QUERY;
}

@end


@interface NDFmSubscribeRequest : NDAPIRequest

@property (nonatomic,strong) NDFmSubscribeParams *params;

@end


@implementation NDFmSubscribeRequest

-(NSString *)method{
    return URL_FM_SUBSCRIBE;
}

@end


@interface NDFmCancelRequest : NDAPIRequest

@property (nonatomic,strong) NDFmCancelParams *params;

@end


@implementation NDFmCancelRequest

-(NSString *)method{
    return URL_FM_CANCEL;
}

@end

@interface NDFmQuerySubRequest : NDAPIRequest

@property (nonatomic,strong) NDFmQuerySubParams *params;

@end


@implementation NDFmQuerySubRequest

-(NSString *)method{
    return URL_FM_QUERYSUB;
}

@end

@interface NDFmDetailRequest : NDAPIRequest

@property (nonatomic,strong) NDFmDetailParams *params;

@end


@implementation NDFmDetailRequest

-(NSString *)method{
    return URL_FM_DETAIL;
}

@end

@interface NDFmCommentListRequest : NDAPIRequest

@property (nonatomic,strong) NDFmCommentListParams *params;

@end


@implementation NDFmCommentListRequest

-(NSString *)method{
    return URL_FM_PAGEREPLY;
}

@end

@interface NDFmCommentRequest : NDAPIRequest

@property (nonatomic,strong) NDFmCommentParams *params;

@end


@implementation NDFmCommentRequest

-(NSString *)method{
    return URL_FM_REPLY;
}

@end

@interface NDFmFavRequest : NDAPIRequest

@property (nonatomic,strong) NDFmFavParams *params;

@end


@implementation NDFmFavRequest

-(NSString *)method{
    return URL_FM_FAV;
}

@end

@interface NDFmHotAlbumRequest : NDAPIRequest

@property (nonatomic,strong) NDFmHotAlbumParams *params;

@end


@implementation NDFmHotAlbumRequest

-(NSString *)method{
    return URL_FM_HOTALBUM;
}

@end

@interface NDFmRecommendAlbumRequest : NDAPIRequest

@property (nonatomic,strong) NDFmRecommendAlbumParams *params;

@end


@implementation NDFmRecommendAlbumRequest

-(NSString *)method{
    return URL_FM_RECOMMENDALBUM;
}

@end

@interface NDFmTagAlbumRequest : NDAPIRequest

@property (nonatomic,strong) NDFmTagAlbumParams *params;

@end


@implementation NDFmTagAlbumRequest

-(NSString *)method{
    return URL_FM_TAGALBUM;
}

@end

@interface NDFmRecommendRequest : NDAPIRequest

@property (nonatomic,strong) NDFmRecommendParams *params;

@end


@implementation NDFmRecommendRequest

-(NSString *)method{
    return URL_FM_RECOMMEND;
}

@end




@implementation NDFmHotAlbumResult

+(Class)__albumsClass{
    return [AlbumInfo class];
}

@end

@implementation NDFmRecommendAlbumResult

+(Class)__albumsClass{
    return [AlbumInfo class];
}

@end

@implementation NDFmTagAlbumResult

+(Class)__albumsClass{
    return [AlbumInfo class];
}

@end

@implementation NDFmRecommendResult

+(Class)__fmsClass{
    return [FM class];
}

@end

@implementation NDFmAPI

/**
 *  电台查询
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmQueryWithParams:(NDFmQueryParams *)params CompletionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDFmQueryRequest *request = [[NDFmQueryRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[FM class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

/**
 *  电台订阅
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)fmSubscribeWithParams:(NDFmSubscribeParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDFmSubscribeRequest *request = [[NDFmSubscribeRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];


}


/**
 *  取消订阅
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmCancelWithParams:(NDFmCancelParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDFmCancelRequest *request = [[NDFmCancelRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];


}

/**
 *  查询订阅
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmQuerySubWithParams:(NDFmQuerySubParams *)params CompletionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDFmQuerySubRequest *request = [[NDFmQuerySubRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[FM class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  电台详情
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmDetailWithParams:(NDFmDetailParams *)params CompletionBlockWithSuccess:(void(^)(id data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail {
    
    NDFmDetailRequest *request = [[NDFmDetailRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess(result);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  评论列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmCommentListWithParams:(NDFmCommentListParams *)params CompletionBlockWithSuccess:(void(^)(id data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail {
    
    NDFmCommentListRequest *request = [[NDFmCommentListRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess(result);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  评论
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmCommentWithParams:(NDFmCommentParams *)params CompletionBlockWithSuccess:(void(^)(id data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail {
    
    NDFmCommentRequest *request = [[NDFmCommentRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess(result);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  收藏
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmFavWithParams:(NDFmFavParams *)params CompletionBlockWithSuccess:(void(^)(id data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail {
    
    NDFmFavRequest *request = [[NDFmFavRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess(result);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  热门专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmHotAlbumWithParams:(NDFmHotAlbumParams *)params CompletionBlockWithSuccess:(void(^)(NDFmHotAlbumResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail {
    
    NDFmHotAlbumRequest *request = [[NDFmHotAlbumRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NDFmHotAlbumResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NDFmHotAlbumResult *hotAlbumResult = (NDFmHotAlbumResult *)result;
        sucess(hotAlbumResult);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  推荐专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmRecommendAlbumWithParams:(NDFmRecommendAlbumParams *)params CompletionBlockWithSuccess:(void(^)(NDFmRecommendAlbumResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail {
    
    NDFmRecommendAlbumRequest *request = [[NDFmRecommendAlbumRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NDFmRecommendAlbumResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NDFmRecommendAlbumResult *data = (NDFmRecommendAlbumResult *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  按标签查询专辑分页列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmTagAlbumWithParams:(NDFmTagAlbumParams *)params CompletionBlockWithSuccess:(void(^)(NDFmTagAlbumResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail {
    
    NDFmTagAlbumRequest *request = [[NDFmTagAlbumRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NDFmTagAlbumResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NDFmTagAlbumResult *data = (NDFmTagAlbumResult *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  推荐电台
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmRecommendWithParams:(NDFmRecommendParams *)params CompletionBlockWithSuccess:(void(^)(NDFmRecommendResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail {
    
    NDFmRecommendRequest *request = [[NDFmRecommendRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NDFmRecommendResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NDFmRecommendResult *data = (NDFmRecommendResult *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}


@end
