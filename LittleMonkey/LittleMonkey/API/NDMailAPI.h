//
//  NDMailAPI.h
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDBaseAPI.h"
#import "NSObject+LKExt.h"
#import "Mail.h"
#import "FavMailDetail.h"
#import "GreetingMail.h"

#pragma mark - 请求参数


/**
 *  查询邮件
 */
@interface NDMailQueryParams : NSObject

@property(nonatomic,strong) NSNumber *min_time; //最小时间点
@property(nonatomic,strong) NSNumber *max_time; //最大时间点

@end

/**
 *  标记邮件
 */

@interface NDMailMarkParams : NSObject

@property(nonatomic,strong) NSString *id_list; //邮件ID列表,逗号分隔

@end

/**
 *  发送邮件
 */

@interface NDMailSendParams : NSObject

@property(nonatomic,strong) NSString *url; //邮件地址或图片地址
@property(nonatomic,strong) NSNumber *group_id; //群ID
@property(nonatomic,strong) NSNumber *duration; // 语音时长
@property(nonatomic,strong) NSNumber *mail_type; // 类型 0：语音 1：文字 2：图片
@property(nonatomic,strong) NSString *content;//文字内容

@end

/**
 *  添加收藏邮件
 */

@interface NDMailFavAddParams : NSObject

@property(nonatomic,strong) NSArray     *mails;     //待收藏语音邮件列表
@property(nonatomic,strong) NSString    *desc;      //备注名

@end


/**
 *  修改收藏邮件
 */

@interface NDMailFavUpdParams : NSObject

@property(nonatomic,strong) NSNumber    *fav_id;    //收藏编号ID
@property(nonatomic,strong) NSString    *desc;      //备注名

@end

/**
 *  删除收藏邮件
 */

@interface NDMailFavDelParams : NSObject

@property(nonatomic,strong) NSNumber    *fav_id;    //收藏编号ID

@end


/**
 *  查询收藏邮件分页列表
 */

@interface NDMailFavPageParams : NSObject

@property(nonatomic,strong) NSNumber    *page;    //当前页码（从1开始),默认1
@property(nonatomic,strong) NSNumber    *rows;    //每页记录数，默认10

@end


/**
 *  获取收藏邮件
 */

@interface NDMailFavGetParams : NSObject

@property(nonatomic,strong) NSNumber    *fav_id;    //收藏编号ID

@end


/**
 *  发送新年祝福语
 */

@interface NDMailSendGreetingParams : NSObject

@property(nonatomic,strong) NSString *url; //邮件地址
@property(nonatomic,strong) NSNumber *duration; //时长

@end

/**
 *  获取新年祝福语
 */

@interface NDMailGreetingParams : NSObject

@property(nonatomic,strong) NSNumber *type; // 查询类型( 1：发送祝福语 2：收到祝福语)
@property(nonatomic,strong) NSNumber *page; //当前页数
@property(nonatomic,strong) NSNumber *rows; //每页显示数量

@end

/**
 *  获取新年祝福语数量信息
 */

@interface NDMailGreetingPraiseTotalParams : NSObject


@end


/**
 *  祝福语点赞
 */

@interface NDMailGreetingPraiseParams : NSObject

@property(nonatomic,strong) NSNumber *greeting_id; //祝福语ID
@property(nonatomic,strong) NSNumber *praise; //0:取消点赞 1：点赞

@end





#pragma mark - 返回结果

@interface NDMailSendResult : NSObject

@property(nonatomic,strong) NSNumber *send_time; //返回的发送时间

@end

@interface NDMailFavAddResult : NSObject

@property(nonatomic,strong) NSNumber *fav_id;   //返回fav_id

@end

@interface NDMailFavPageResult : NSObject

@property(nonatomic,strong) NSNumber *count;    //总记录数
@property(nonatomic,strong) NSArray  *favs;     //本页收藏列表

@end

@interface NDMailFavGetResult : NSObject

@property(nonatomic,strong) FavMailDetail  *fav;     //单个收藏记录

@end

/**
 *  查询未读邮件条数
 */

@interface NDMailQueryUnreadCountParams : NSObject

@property(nonatomic,strong) NSNumber *min_time; //最小时间点
@property(nonatomic,strong) NSNumber *max_time; //最大时间点

@end

@interface NDMailQueryUnreadCountResult : NSObject

@property(nonatomic,strong) NSNumber *count; //未读条数

@end


/**
 *  发送新年祝福语
 */

@interface NDMailSendGreetingResult : NSObject

@property(nonatomic,strong) NSNumber *send_time; //从1970开始的秒数

@end


/**
 *  获取新年祝福语
 */

@interface NDMailGreetingResult : NSObject


@property(nonatomic,strong) NSNumber *count; //祝福语总数
@property(nonatomic,strong) NSNumber *page;  //当前页码
@property(nonatomic,strong) NSArray *list; // 祝福语列表

@end


/**
 *  获取新年祝福语数量信息
 */

@interface NDMailGreetingPraiseTotalResult : NSObject


@property(nonatomic,strong) NSNumber *count; //被赞过的祝福数
@property(nonatomic,strong) NSNumber *total;  //总被赞次数
@property(nonatomic,strong) NSNumber *send_praise; //总发送赞数
@property(nonatomic,strong) NSNumber *send_greeting; //给别人的祝福


@end



#pragma mark - 请求接口


@interface NDMailAPI : NDBaseAPI

/**
 *  查询邮件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailqueryWithParams:(NDMailQueryParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  标记邮件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailMarkWithParams:(NDMailMarkParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  发送邮件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailSendWithParams:(NDMailSendParams *)params completionBlockWithSuccess:(void(^)(NDMailSendResult *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  查询未读邮件条件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailQueryUnreadCountWithParams:(NDMailQueryUnreadCountParams *)params completionBlockWithSuccess:(void(^)(NDMailQueryUnreadCountResult *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;



/**
 *  添加收藏邮件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */



+(void)mailFavAddWithParams:(NDMailFavAddParams *)params completionBlockWithSuccess:(void(^)(NDMailFavAddResult *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  修改收藏邮件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailFavUpdWithParams:(NDMailFavUpdParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  删除收藏邮件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailFavDelWithParams:(NDMailFavDelParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  查询收藏邮件分页列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailFavPageWithParams:(NDMailFavPageParams *)params completionBlockWithSuccess:(void(^)(NDMailFavPageResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  获取收藏邮件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailFavGetWithParams:(NDMailFavGetParams *)params completionBlockWithSuccess:(void(^)(NDMailFavGetResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  发送新年祝福语
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailSendGreetingWithParams:(NDMailSendGreetingParams *)params completionBlockWithSuccess:(void(^)(NDMailSendGreetingResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  获取新年祝福语
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailGreetingWithParams:(NDMailGreetingParams *)params completionBlockWithSuccess:(void(^)(NDMailGreetingResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  获取新年祝福语数量信息
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */


+(void)mailGreetingPraiseTotalWithParams:(NDMailGreetingPraiseTotalParams *)params completionBlockWithSuccess:(void(^)(NDMailGreetingPraiseTotalResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  祝福语点赞
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */


+(void)mailGreetingPraiseWithParams:(NDMailGreetingPraiseParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


@end
