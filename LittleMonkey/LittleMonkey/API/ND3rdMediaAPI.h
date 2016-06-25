//
//  ND3rdMediaAPI.h
//  HelloToy
//
//  Created by huanglurong on 16/4/20.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDBaseAPI.h"
#import "ND3RDAlbumMedia.h"
#import "MediaDownloadStatus.h"
#import "ND3RDMedia.h"
#import "ND3rdAlbumInfo.h"

/*
 * 下载媒体
 */

@interface ND3rdMediaDownloadMediaParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id;
@property(nonatomic,strong) NSNumber *third_aid;
@property(nonatomic,strong) NSNumber *source;
@property(nonatomic,strong) NSString *album_icon; //专辑图标
@property(nonatomic,strong) NSString *album_title; //专辑标题
@property(nonatomic,strong) NSNumber *third_mid; //第三方媒体id
@property(nonatomic,strong) NSString *media_title; //媒体标题
@property(nonatomic,strong) NSString *media_icon; //媒体图标
@property(nonatomic,strong) NSString *media_url; //媒体地址

@end

/*
 * 下载专辑
 */

@interface ND3rdMediaDownloadAlbumParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //玩具id
@property(nonatomic,strong) NSNumber *third_aid;
@property(nonatomic,strong) NSNumber *source;
@property(nonatomic,strong) NSString *album_icon; //专辑图标
@property(nonatomic,strong) NSString *album_title; //专辑标题
@property(nonatomic,strong) NSArray  *media_list;

@end

/*
 * 查询媒体的下载状态
 */

@interface ND3rdMediaQeueryMediaParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //玩具id
@property(nonatomic,strong) NSNumber *source; //媒体来源， 100：喜马拉雅
@property(nonatomic,strong) NSString *third_mid_list; //第三方专辑ID

@end

/*
 * 切换专辑
 */

@interface ND3rdMediaChangeAlbumParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //玩具id
@property(nonatomic,strong) NSNumber *source; //媒体来源， 100：喜马拉雅
@property(nonatomic,strong) NSNumber *third_aid; //第三方专辑ID

@end

/*
 * 点播
 */

@interface ND3rdMediaPlayMediaParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //玩具id
@property(nonatomic,strong) NSNumber *source; //媒体来源， 100：喜马拉雅
@property(nonatomic,strong) NSNumber *third_mid; //第三方媒体id

@end

/*
 * 查询专辑媒体
 */

@interface ND3rdMediaAlbumMediaParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //玩具id
@property(nonatomic,strong) NSNumber *source; //媒体来源， 100：喜马拉雅
@property(nonatomic,strong) NSNumber *album_id; //第三方媒体id


@end

/*
 * 查询专辑媒体
 */

@interface ND3rdMediaAlbumDetialParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //玩具id
@property(nonatomic,strong) NSNumber *source; //媒体来源， 100：喜马拉雅
@property(nonatomic,strong) NSNumber *third_aid; //第三方媒体id


@end





/**
 *  查询媒体的下载状态
 */
@interface ND3rdQeueryMediaResult : NSObject

@property(nonatomic,strong) NSArray *data; //用户id

@end

/**
 *  查询专辑媒体
 */
@interface ND3rdAlbumMediaResult : NSObject

@property(nonatomic,strong) NSArray *data; //用户id

@end



@interface ND3rdMediaAPI : NDBaseAPI

/**
 *  下载媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)thirdMediaDownloadMediaWithParams:(ND3rdMediaDownloadMediaParams *)params completionBlockWithSuccess:(void(^)(MediaDownloadStatus *mediaDownloadStatus))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  下载专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)thirdMediaDownloadAlbumWithParams:(ND3rdMediaDownloadAlbumParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询媒体的下载状态
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)thirdMediaQeueryMediaWithParams:(ND3rdMediaQeueryMediaParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  切换专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)thirdMediaChangeAlbumWithParams:(ND3rdMediaChangeAlbumParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询专辑媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)thirdMediaAlbumMediaWithParams:(ND3rdMediaAlbumMediaParams *)params completionBlockWithSuccess:(void(^)(NSArray*data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询专辑详情
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)thirdMediaAlbumDetialWithParams:(ND3rdMediaAlbumDetialParams *)params completionBlockWithSuccess:(void(^)(ND3rdAlbumInfo *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;



@end
