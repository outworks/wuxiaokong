//
//  NDMediaAPI.h
//  HelloToy
//
//  Created by nd on 15/4/29.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "NDBaseAPI.h"
#import "MediaInfo.h"
#import "AlbumMedia.h"
#import "Download.h"

#pragma mark - 请求参数

/**
 *  增加媒体
 */

@interface NDMediaAddParams : NSObject

@end

/**
 *  删除媒体
 */

@interface NDMediaDeleteParams : NSObject

@property(nonatomic,strong) NSNumber *media_id;

@end

/**
 *  查询媒体
 */

@interface NDMediaQueryParams : NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSNumber *page;

@end

/**
 *  根据id查询媒体详情
 */

@interface NDMediaQueryByIdParams : NSObject

@property(nonatomic,strong) NSNumber *media_id;

@end

@interface NDMediaUndownloadParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id;

@end

@interface NDMediaQueryDownloadParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id;
@property(nonatomic,assign) int download; //0：已下载和下载中 1:已下载  2:下载中
@property(nonatomic,assign) int page;//当前页码
@property(nonatomic,assign) int rows;//每页每数

@end

@interface NDMediaLostParams : NSObject

@property(nonatomic,assign) int page;//当前页码

@end


#pragma mark - 返回结果


#pragma mark - 请求接口

@interface NDMediaAPI : NDBaseAPI

/**
 *  增加媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)mediaAddWithParams:(NDMediaAddParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  删除媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)mediaDeleteWithParams:(NDMediaDeleteParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)mediaQueryWithParams:(NDMediaQueryParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  根据id查询媒体详情
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)mediaQueryByIdWithParams:(NDMediaQueryByIdParams *)params completionBlockWithSuccess:(void(^)(AlbumMedia *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  未下载媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)mediaUndownloadWithParams:(NDMediaUndownloadParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询下载媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)queryDownloadWithParams:(NDMediaQueryDownloadParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  添加专辑查询
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)mediaLostWithParams:(NDMediaLostParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;



@end
