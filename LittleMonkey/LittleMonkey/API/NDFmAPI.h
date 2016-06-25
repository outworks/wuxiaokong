//
//  NDFmAPI.h
//  HelloToy
//
//  Created by nd on 15/10/15.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "NDBaseAPI.h"
#import "Fm.h"
#import "FMDetail.h"

@interface NDFmQueryParams : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSNumber *fm_id;

@end


@interface NDFmSubscribeParams : NSObject

@property (nonatomic,strong) NSNumber *fm_id;
@property (nonatomic,strong) NSNumber *toy_id;
@property (nonatomic,strong) NSNumber *flag;//0：不强制订阅   1:强制订阅
@property (nonatomic,strong) NSNumber *play_time;//播放时间

@end

@interface NDFmCancelParams : NSObject

@property (nonatomic,strong) NSNumber *fm_id;
@property (nonatomic,strong) NSNumber *toy_id;

@end

@interface NDFmQuerySubParams : NSObject

@property (nonatomic,strong) NSNumber *toy_id;

@end

@interface NDFmDetailParams : NSObject

@property (nonatomic,strong) NSNumber *fm_id;
@property (nonatomic,strong) NSNumber *page;
@property (nonatomic,strong) NSNumber *rows;

@end

@interface NDFmCommentListParams : NSObject

@property (nonatomic,strong) NSNumber *media_id;
@property (nonatomic,strong) NSNumber *page;
@property (nonatomic,strong) NSNumber *rows;

@end

@interface NDFmCommentParams : NSObject

@property (nonatomic,strong) NSNumber *media_id;
@property (nonatomic,strong) NSString *content;

@end

@interface NDFmFavParams : NSObject

@property (nonatomic,strong) NSNumber *media_id;

@end

@interface NDFmHotAlbumParams : NSObject

@property (nonatomic,strong) NSNumber *page;
@property (nonatomic,strong) NSNumber *rows;

@end

@interface NDFmHotAlbumResult : NSObject

@property(nonatomic,strong) NSNumber *count;   //总记录数
@property(nonatomic,strong) NSNumber *page;    //页码
@property(nonatomic,strong) NSArray  *albums;    //专辑列表

@end

@interface NDFmRecommendAlbumParams : NSObject

@property (nonatomic,strong) NSNumber *page;
@property (nonatomic,strong) NSNumber *rows;

@end

@interface NDFmRecommendAlbumResult : NSObject

@property(nonatomic,strong) NSNumber *count;   //总记录数
@property(nonatomic,strong) NSNumber *page;    //页码
@property(nonatomic,strong) NSArray  *albums;    //专辑列表

@end

@interface NDFmTagAlbumParams : NSObject

@property (nonatomic,strong) NSString *tag;
@property (nonatomic,strong) NSNumber *page;
@property (nonatomic,strong) NSNumber *rows;

@end

@interface NDFmTagAlbumResult : NSObject

@property(nonatomic,strong) NSNumber *count;   //总记录数
@property(nonatomic,strong) NSNumber *page;    //页码
@property(nonatomic,strong) NSArray  *albums;    //专辑列表

@end

@interface NDFmRecommendParams : NSObject

@property (nonatomic,strong) NSNumber *page;
@property (nonatomic,strong) NSNumber *rows;

@end

@interface NDFmRecommendResult : NSObject

@property(nonatomic,strong) NSNumber *count;   //总记录数
@property(nonatomic,strong) NSNumber *page;    //页码
@property(nonatomic,strong) NSArray  *fms;    //专辑列表

@end

#pragma mark - NDFmAPI

@interface NDFmAPI : NDBaseAPI

/**
 *  电台查询
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmQueryWithParams:(NDFmQueryParams *)params CompletionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  电台订阅
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmSubscribeWithParams:(NDFmSubscribeParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  取消订阅
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmCancelWithParams:(NDFmCancelParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询订阅
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmQuerySubWithParams:(NDFmQuerySubParams *)params CompletionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  电台详情
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmDetailWithParams:(NDFmDetailParams *)params CompletionBlockWithSuccess:(void(^)(id data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  评论列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmCommentListWithParams:(NDFmCommentListParams *)params CompletionBlockWithSuccess:(void(^)(id data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  评论
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmCommentWithParams:(NDFmCommentParams *)params CompletionBlockWithSuccess:(void(^)(id data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  收藏
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmFavWithParams:(NDFmFavParams *)params CompletionBlockWithSuccess:(void(^)(id data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  热门专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmHotAlbumWithParams:(NDFmHotAlbumParams *)params CompletionBlockWithSuccess:(void(^)(NDFmHotAlbumResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  推荐专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmRecommendAlbumWithParams:(NDFmRecommendAlbumParams *)params CompletionBlockWithSuccess:(void(^)(NDFmRecommendAlbumResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  按标签查询专辑分页列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmTagAlbumWithParams:(NDFmTagAlbumParams *)params CompletionBlockWithSuccess:(void(^)(NDFmTagAlbumResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  推荐电台
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)fmRecommendWithParams:(NDFmRecommendParams *)params CompletionBlockWithSuccess:(void(^)(NDFmRecommendResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

@end
