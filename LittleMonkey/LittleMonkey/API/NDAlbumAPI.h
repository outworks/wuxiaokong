//
//  NDAlbumAPI.h
//  HelloToy
//
//  Created by nd on 15/4/29.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "NDBaseAPI.h"
#import "AlbumInfo.h"
#import "AlbumMedia.h"

#pragma mark - 请求参数
/**
 *  增加专辑
 */

@interface NDAlbumAddParams : NSObject

@property(nonatomic,strong) NSString *name; //专辑名称
@property(nonatomic,strong) NSString *icon; //专辑头像
@property(nonatomic,strong) NSString *media_list; //媒体ID列表
@property(nonatomic,strong) NSNumber *source; //权限类型
@property(nonatomic,strong) NSNumber *album_type; //专辑类型

@end

/**
 *  删除专辑
 */

@interface NDAlbumDeleteParams : NSObject

@property(nonatomic,strong) NSNumber *album_id; //专辑ID

@end

/**
 *  修改专辑
 */

@interface NDAlbumUpdateParams : NSObject

@property(nonatomic,strong) NSNumber *album_id; //专辑ID
@property(nonatomic,strong) NSString *name; //专辑名称
@property(nonatomic,strong) NSString *icon; //专辑头像
@property(nonatomic,strong) NSString *media_list; //媒体ID列表
@property(nonatomic,strong) NSNumber *source; //权限类型
@property(nonatomic,strong) NSNumber *album_type; //专辑类型
@property(nonatomic,strong) NSString *info;

@end

/**
 *  查询专辑列表
 */

@interface NDAlbumQueryParams : NSObject

@property(nonatomic,strong) NSString *source; //权限类型 0:internal, 1:network, 2:private
@property(nonatomic,strong) NSNumber *album_type; //专辑类型
@property(nonatomic,strong) NSNumber *page; //分布索引
@property(nonatomic,strong) NSString *name; //专辑名称

@end

/**
 *  查询专辑中详情媒体
 */
@interface NDAlbumDetailParams : NSObject

@property(nonatomic,strong) NSNumber *album_id; //专辑ID
@property(nonatomic,strong) NSNumber *toy_id; //玩具ID
@property(nonatomic,strong) NSNumber *page; //分布索引
@property(nonatomic,strong) NSNumber *rows; //分布索引

@end


/**
 *  给专辑添加媒体
 */
@interface NDAlbumAddMediaParams : NSObject

@property(nonatomic,strong) NSNumber *album_id; //专辑ID
@property(nonatomic,strong) NSNumber *media_id; //媒体ID

@end

/**
 *  删除专辑中的媒体
 */
@interface NDAlbumDelMediaParams : NSObject

@property(nonatomic,strong) NSNumber *album_id; //专辑ID
@property(nonatomic,strong) NSNumber *media_id; //媒体ID

@end

/**
 *  根据id查询专辑信息
 */
@interface NDAlbumInfoByIdParams : NSObject

@property(nonatomic,strong) NSNumber *album_id; //专辑ID

@end

/**
 *  查询媒体是否已经下载到玩具
 */
@interface NDQueryMediaStatusParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id;       //玩具ID
@property(nonatomic,strong) NSString *medialist;    //媒体ID列表
@property(nonatomic,strong) NSNumber *album_id;     //专辑ID

@end

/**
 *  下载媒体到玩具
 */
@interface NDMediaDownloadParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id;       //玩具ID
@property(nonatomic,strong) NSNumber *media_id;     //媒体ID
@property(nonatomic,strong) NSNumber *album_id;     //媒体所属的专辑

@end


#pragma mark - 返回结果


#pragma mark - 请求接口

@interface NDAlbumAPI : NDBaseAPI

/**
 *  增加专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)albumAddWithParams:(NDAlbumAddParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  删除专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)albumDeleteWithParams:(NDAlbumDeleteParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  修改专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)albumUpdateWithParams:(NDAlbumUpdateParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  查询专辑列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)albumQueryWithParams:(NDAlbumQueryParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  查询专辑中详情媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)albumDetailWithParams:(NDAlbumDetailParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  给专辑添加媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)albumAddMediaWithParams:(NDAlbumAddMediaParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  删除专辑中的媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)albumDelMediaWithParams:(NDAlbumDelMediaParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  根据id查询专辑信息
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)albumInfoByIdWithParams:(NDAlbumInfoByIdParams *)params completionBlockWithSuccess:(void(^)(AlbumInfo *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询媒体是否已经下载到玩具
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)mediaStatusQueryWithParams:(NDQueryMediaStatusParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  下载媒体到玩具
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)mediaDownloadWithParams:(NDMediaDownloadParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

@end
