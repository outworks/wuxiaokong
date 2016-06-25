//
//  NDToyAPI.h
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDBaseAPI.h"
#import "Toy.h"
#import "AlbumMedia.h"
#import "AlbumInfo.h"
#import "ToyUpdate.h"
#import "Theme.h"
#import "Setting.h"
#import "ToyStatus.h"
#import "ToyStat.h"
#import "ToyPlay.h"
#import "ToyKeyValueData.h"
#import "ContactGmail.h"
#import "Gmail.h"
#import "DownloadMediaInfo.h"
#import "DownloadAlbumInfo.h"
#import "ToyDownloadInfo.h"

#define Def_ToySetKey_Volume @"volume"


#pragma mark - 请求参数

/**
 *  查询玩具详情
 */
@interface NDToyDetailParams : NSObject

@property(nonatomic,strong) NSString *id_list; //用户id列表,

@end


/**
 *  查询玩具绑定结果
 */

@interface NDToyFindParams : NSObject

@property(nonatomic,strong) NSNumber *bind_code; //绑定码

@end

/**
 *  修改玩具信息
 */

@interface NDToyUpdateParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //玩具ID
@property(nonatomic,strong) NSString *nickname; //玩具昵称
@property(nonatomic,strong) NSString *icon; //用户头像
@property(nonatomic,strong) NSNumber *gender; //性别
@property(nonatomic,strong) NSString *birthday; //生日
@property(nonatomic,strong) NSString *city; //城市
@property(nonatomic,strong) NSString *street; //街道地址
@property(nonatomic,assign) double lat; //纬度
@property(nonatomic,assign) double lng; //经度

@end

/**
 *  删除玩具
 */

@interface NDToyDeleteParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //玩具ID

@end

#pragma mark - （玩具操作部分）

/**
 *  通知下载
 */

@interface NDToyNotifyDownloadParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //玩具ID
@property(nonatomic,strong) NSNumber *media_type; //媒体类型
@property(nonatomic,strong) NSNumber *media_id; //媒体ID

@end

/**
 *  查询下载
 */

@interface NDToyQueryDownloadParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //玩具ID
@property(nonatomic,strong) NSNumber *media_type; //媒体类型
@property(nonatomic,strong) NSNumber *status; //下载状态

@end

/**
 *  查询下载状态
 */
@interface NDToyDownloadInfoParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id;

@end

/**
 *  点播
 */

@interface NDToyPlayMediaParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //玩具ID
@property(nonatomic,strong) NSNumber *media_type; //媒体类型
@property(nonatomic,strong) NSNumber *media_id; //媒体id

@end

/**
 *  切换专辑
 */

@interface NDToyChangeAlbumParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //玩具ID
@property(nonatomic,strong) NSNumber *album_type; //媒体类型
@property(nonatomic,strong) NSNumber *album_id; //媒体id
@property(nonatomic,strong) NSString *medialist; //媒体列表，都好分隔，如果有的话，只播放列表中得媒体

@end

/**
 *  查询版本
 */

@interface NDToyVersionParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //玩具ID

@end


/**
 *  升级硬件
 */

@interface NDToyUpgradeParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //玩具ID
@property(nonatomic,strong) NSString *version; //版本号

@end


/**
 *  切换模式
 */

@interface NDToyChangeModeParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //玩具ID
@property(nonatomic,strong) NSNumber *mode; //模式


@end


/**
 *  切换主题
 */

@interface NDToyChangeThemeParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //设备ID
@property(nonatomic,strong) NSNumber *theme_id; //主题ID

@end

/**
 *  查询主题
 */

@interface NDToyThemeParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //设备ID

@end

/**
 *  查询主题列表
 */

@interface NDToyThemeListParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id;

@end

/**
 *  查询设置
 */

@interface NDToySettingParams : NSObject

@property (nonatomic,strong)NSNumber *toy_id;
@property (nonatomic,strong)NSString *keys;

@end

/**
 *  查询设置
 */

@interface NDToyChangeSettingParams: NSObject

@property (nonatomic,strong)NSNumber *toy_id;
@property (nonatomic,strong)NSString *key;
@property (nonatomic,strong)NSString *value;

@end

/**
 *  查询玩具电量
 */

@interface NDToyElectricityParams : NSObject

@property (nonatomic,strong) NSNumber *toy_id;

@end

/**
 *  播放上下n首
 */

@interface NDToyControlPlayParams: NSObject

@property (nonatomic,strong)NSNumber *toy_id;
@property (nonatomic,strong)NSNumber *offset;   // 偏移量(上一首为－1，下一首为1)

@end

/**
 *  查询玩数据key-value
 */

@interface NDToyDataKeyValueParams: NSObject

@property (nonatomic,strong)NSNumber *toy_id;
@property (nonatomic,strong)NSArray *keys;

@end

/**
 *  查询玩具统计数据
 */

@interface NDToyStatParams : NSObject

@property (nonatomic,strong) NSNumber *toy_id;

@end


/**
 *  查询玩具播放记录
 */

@interface NDToyPlayRecentlyParams : NSObject

@property (nonatomic,strong) NSNumber *toy_id;

@end

@interface NDToyContactListParams : NSObject

@property (nonatomic,strong) NSNumber *toy_id;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger rows;

@end

@interface NDToyGmailListParams : NSObject

@property (nonatomic,strong) NSNumber *toy_id;
@property (nonatomic,strong) NSNumber *target_id;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger rows;


@end


@interface NDToyQueryDownloadAlbumParams : NSObject

@property (nonatomic,strong) NSNumber *toy_id;
@property(nonatomic,strong) NSNumber *album_id;//专辑id //可选
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int rows;

@end

@interface NDToyAlbumDetailParams : NSObject

@property (nonatomic,strong) NSNumber *album_id;
@property (nonatomic,strong) NSNumber *toy_id;
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int rows;

@end

//下载专辑到玩具

@interface NDToyAlbumDownloadParams : NSObject

@property (nonatomic,strong) NSNumber *toy_id;
@property (nonatomic,strong) NSNumber *album_id;
@property (nonatomic,strong) NSString *medialist;

@end

@interface NDToyMediaDeleteParams : NSObject

@property (nonatomic,strong) NSNumber *toy_id;
@property (nonatomic,strong) NSArray *media_ids;

@end


#pragma mark - 请求返回结果

@interface NDToyElectricityResult : NSObject

@property(nonatomic,strong) NSNumber *electricity;  //电量
@property(nonatomic,strong) NSNumber *isonline;     //在线情况

@end

@interface NDToyChangeModeResult : NSObject

@property(nonatomic,strong) NSNumber *isonline;

@end

@interface NDToyContactListResult : NSObject

@property(nonatomic,strong) NSNumber *total;
@property(nonatomic,strong) NSArray  *contactList;

@end

@interface NDToyGmailListResult : NSObject

@property(nonatomic,strong) NSNumber *total;
@property(nonatomic,strong) NSArray *gmailList;

@end

@interface NDToyQueryDownloadAlbumResult : NSObject

@property(nonatomic,strong) NSNumber *total;
@property(nonatomic,strong) NSArray *gmailList;

@end



#pragma mark - 请求返回结果



#pragma mark - 请求接口

@interface NDToyAPI : NDBaseAPI

/**
 *  查询玩具详情
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)toyDetailWithParams:(NDToyDetailParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  查询玩具绑定结果
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)toyFindWithParams:(NDToyFindParams *)params completionBlockWithSuccess:(void(^)(Toy *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  修改玩具信息
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)toyUpdateWithParams:(NDToyUpdateParams *)params completionBlockWithSuccess:(void(^)(Toy *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  删除玩具
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)toyDeleteWithParams:(NDToyDeleteParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

#pragma mark - 玩具操作

/**
 *  通知下载
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)toyNotifyDownloadWithParams:(NDToyNotifyDownloadParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询下载
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)toyQueryDownloadWithParams:(NDToyQueryDownloadParams *)params completionBlockWithSuccess:(void(^)(AlbumMedia *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  点播
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)toyPlayMediaWithParams:(NDToyPlayMediaParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  切换专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)toyChangeAlbumWithParams:(NDToyChangeAlbumParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  查询版本
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyVersionWithParams:(NDToyVersionParams *)params completionBlockWithSuccess:(void(^)(ToyUpdate *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  升级硬件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyUpgradeWithParams:(NDToyUpgradeParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  切换模式
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyChangeModeWithParams:(NDToyChangeModeParams *)params completionBlockWithSuccess:(void(^)(NDToyChangeModeResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  切换主题
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyChangeThemeWithParams:(NDToyChangeThemeParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询主题
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyThemeWithParams:(NDToyThemeParams *)params completionBlockWithSuccess:(void(^)(Theme *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  查询主题列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyThemeListWithParams:(NDToyThemeListParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询设置
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toySettinWithParams:(NDToySettingParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  修改设置
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyChangeSettinWithParams:(NDToyChangeSettingParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  播放上一首下一首
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyControlPlayWithParams:(NDToyControlPlayParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询玩具数据
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyDataKeyValueParams:(NDToyDataKeyValueParams *)params completionBlockWithSuccess:(void(^)(ToyStatus *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  查询玩具电量
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyElectricityWithParams:(NDToyElectricityParams *)params completionBlockWithSuccess:(void(^)(NDToyElectricityResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  查询玩具统计数据
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyStatParams:(NDToyStatParams *)params completionBlockWithSuccess:(void(^)(ToyStat *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询玩具播放记录
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyPlayRecentlyWithParams:(NDToyPlayRecentlyParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询联系人列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyContactListWithParams:(NDToyContactListParams *)params completionBlockWithSuccess:(void(^)(NDToyContactListResult *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询聊天记录
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyGmailListWithParams:(NDToyGmailListParams *)params completionBlockWithSuccess:(void(^)(NDToyGmailListResult *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询下载的专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyQueryDownloadAlbumWithParams:(NDToyQueryDownloadAlbumParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询专辑已下载的媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyAlbumDetailWithParams:(NDToyAlbumDetailParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  批量媒体下载到玩具
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 
 */

+(void)toyAlbumDownloadWithParams:(NDToyAlbumDownloadParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  玩具下载情况
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)toyQueryDownloadInfoWithParams:(NDToyDownloadInfoParams *)params completionBlockWithSuccess:(void(^)(ToyDownloadInfo *info))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  玩具删除已下载媒体情况
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)toyMediaDeleteWithParams:(NDToyMediaDeleteParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;



@end
