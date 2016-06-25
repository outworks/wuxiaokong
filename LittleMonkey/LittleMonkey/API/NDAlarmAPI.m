//
//  NDAlarmAPI.m
//  HelloToy
//
//  Created by nd on 15/6/11.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "NDAlarmAPI.h"

#pragma mark - 请求

@interface NDAlarmQueryRequest : NDAPIRequest

@property(nonatomic,strong) NDAlarmQueryParams *params;

@end

@implementation NDAlarmQueryRequest

-(NSString *)method{
    return URL_ALARM_QUERY;
}

@end

@interface NDAlarmEventListRequest : NDAPIRequest

@property(nonatomic,strong) NDAlarmEventListParams *params;

@end

@implementation NDAlarmEventListRequest

-(NSString *)method{
    return URL_ALARM_EVENTLIST;
}

@end

@interface NDAlarmAddRequest : NDAPIRequest

@property(nonatomic,strong) NDAlarmAddParams *params;

@end

@implementation NDAlarmAddRequest

-(NSString *)method{
    return URL_ALARM_ADD;
}

@end

@interface NDAlarmModifyRequest : NDAPIRequest

@property(nonatomic,strong) NDAlarmModifyParams *params;

@end

@implementation NDAlarmModifyRequest

-(NSString *)method{
    return URL_ALARM_MODIFY;
}

@end

@interface NDAlarmDeleteRequest : NDAPIRequest

@property(nonatomic,strong) NDAlarmDeleteParams *params;

@end

@implementation NDAlarmDeleteRequest

-(NSString *)method{
    return URL_ALARM_DELETE;
}

@end

@interface NDAlarmQueryEventRequest : NDAPIRequest

@property(nonatomic,strong) NDAlarmQueryEventParams *params;

@end

@implementation NDAlarmQueryEventRequest

-(NSString *)method{
    return URL_ALARM_QUERYEVENT;
}

@end

@interface NDAlarmAddEventRequest : NDAPIRequest

@property(nonatomic,strong) NDAlarmAddEventParams *params;

@end

@implementation NDAlarmAddEventRequest

-(NSString *)method{
    return URL_ALARM_ADDEVENT;
}

@end

@interface NDAlarmDelEventRequest : NDAPIRequest

@property(nonatomic,strong) NDAlarmDelEventParams *params;

@end

@implementation NDAlarmDelEventRequest

-(NSString *)method{
    return URL_ALARM_DELEVENT;
}

@end

@interface NDAlarmModifyEventRequest : NDAPIRequest

@property(nonatomic,strong) NDAlarmModifyEventParams *params;

@end

@implementation NDAlarmModifyEventRequest

-(NSString *)method{
    return URL_ALARM_MODIFYEVENT;
}

@end


#pragma mark - 请求参数

@implementation NDAlarmQueryParams
@end

@implementation NDAlarmEventListParams
@end

@implementation NDAlarmAddParams
@end

@implementation NDAlarmModifyParams
@end

@implementation NDAlarmDeleteParams
@end

@implementation NDAlarmQueryEventParams

@end

@implementation NDAlarmAddEventParams

@end

@implementation NDAlarmDelEventParams

@end

@implementation NDAlarmModifyEventParams

@end


#pragma mark - 返回结果

#pragma mark - 请求接口

@implementation NDAlarmAPI

/**
 *  查询闹钟Event列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)alarmQueryEventWithParams:(NDAlarmQueryEventParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDAlarmQueryEventRequest *request = [[NDAlarmQueryEventRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[AlarmEvent class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
    
    
}

/**
 *  增加闹钟Event列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)alarmAddEventWithParams:(NDAlarmAddEventParams *)params completionBlockWithSuccess:(void(^)(NSDictionary *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDAlarmAddEventRequest *request = [[NDAlarmAddEventRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSDictionary *data = (NSDictionary *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
    
}

/**
 *  删除闹钟Event列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)alarmDelEventWithParams:(NDAlarmDelEventParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDAlarmDelEventRequest *request = [[NDAlarmDelEventRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

/**
 *  修改闹钟Event列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)alarmModifyEventWithParams:(NDAlarmModifyEventParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDAlarmModifyEventRequest *request = [[NDAlarmModifyEventRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
    
}

+(void)alarmQueryWithParams:(NDAlarmQueryParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDAlarmQueryRequest *request = [[NDAlarmQueryRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[Alarm class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

+(void)alarmEventListWithParams:(NDAlarmEventListParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDAlarmEventListRequest *request = [[NDAlarmEventListRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[AlarmEvent class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

+(void)alarmAddWithParams:(NDAlarmAddParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDAlarmAddRequest *request = [[NDAlarmAddRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

+(void)alarmModifyWithParams:(NDAlarmModifyParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDAlarmModifyRequest *request = [[NDAlarmModifyRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

+(void)alarmDeleteWithParams:(NDAlarmDeleteParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDAlarmDeleteRequest *request = [[NDAlarmDeleteRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}


@end
