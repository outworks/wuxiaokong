//
//  NDAlarmAPI.h
//  HelloToy
//
//  Created by nd on 15/6/11.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDBaseAPI.h"
#import "Alarm.h"

#pragma mark - 请求参数

/**
 *  查询闹钟列表
 *
 */

@interface NDAlarmQueryParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id;//玩具ID

@end


/**
 *  查询闹钟事件列表
 *
 */

@interface NDAlarmEventListParams : NSObject

@property(nonatomic,strong) NSNumber *alarm_id;//闹钟ID

@end

/**
 *  添加闹钟
 *
 */
@interface NDAlarmAddParams : NSObject

@property(nonatomic,strong) NSNumber *time; //当天的秒数
@property(nonatomic,strong) NSString *weekday; //weekDay
@property(nonatomic,strong) NSString *tag; // 0:成功 1:失败
@property(nonatomic,strong) NSNumber *event; //事件ID
@property(nonatomic,strong) NSNumber *toy_id; //玩具ID
@property(nonatomic,strong) NSNumber *enable; // 0:开 1:关

@end

/**
 *  修改闹钟
 *
 */

@interface NDAlarmModifyParams : NSObject

@property(nonatomic,strong) NSString *alarm_id; //闹钟ID
@property(nonatomic,strong) NSNumber *toy_id; //玩具ID
@property(nonatomic,strong) NSNumber *time; //当天的秒数
@property(nonatomic,strong) NSString *weekday; //weekDay
@property(nonatomic,strong) NSString *tag; // 0:成功 1:失败
@property(nonatomic,strong) NSNumber *event; //事件ID
@property(nonatomic,strong) NSNumber *enable; // 1:开 0:关

@end

/**
 *  删除闹钟
 *
 */

@interface NDAlarmDeleteParams : NSObject

@property(nonatomic,strong) NSString *alarm_id; //闹钟ID

@end

@interface NDAlarmQueryEventParams : NSObject

@end

@interface NDAlarmAddEventParams : NSObject

@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *desc;

@end

@interface NDAlarmModifyEventParams : NSObject

@property(nonatomic,strong) NSNumber *event_id;
@property(nonatomic,strong) NSString *desc;

@end

@interface NDAlarmDelEventParams : NSObject

@property (nonatomic,strong) NSNumber *event_id;

@end

#pragma mark - 返回结果


#pragma mark - 请求接口

@interface NDAlarmAPI : NDBaseAPI

/**
 *  查询闹钟Event列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)alarmQueryEventWithParams:(NDAlarmQueryEventParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  增加闹钟Event列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)alarmAddEventWithParams:(NDAlarmAddEventParams *)params completionBlockWithSuccess:(void(^)(NSDictionary *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  删除闹钟Event列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)alarmDelEventWithParams:(NDAlarmDelEventParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  修改闹钟Event列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)alarmModifyEventWithParams:(NDAlarmModifyEventParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询闹钟列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)alarmQueryWithParams:(NDAlarmQueryParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询闹钟事件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)alarmEventListWithParams:(NDAlarmEventListParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  添加闹钟
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)alarmAddWithParams:(NDAlarmAddParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;
/**
 *   修改闹钟
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)alarmModifyWithParams:(NDAlarmModifyParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  删除闹钟
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)alarmDeleteWithParams:(NDAlarmDeleteParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

@end
