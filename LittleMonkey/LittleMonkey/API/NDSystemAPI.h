//
//  NDSystemAPI.h
//  HelloToy
//
//  Created by nd on 15/5/20.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDBaseAPI.h"


#pragma mark - 请求参数

/**
 *  提交意见
 */

@interface NDSystemAddSuggestParams : NSObject

@property(nonatomic,strong) NSNumber *type; //建议类型
@property(nonatomic,strong) NSString *content; //建议内容
@property(nonatomic,strong) NSString *picture; //图片


@end


/**
 *  查询意见
 */

@interface NDSystemQuerySuggestParams : NSObject

@property(nonatomic,strong) NSNumber *type; //建议类型

@end

/**
 *  查询是否有新的回复
 */
@interface NDSystemCheckReplyParams : NSObject

@end

/**
 *  清空新回复标志
 */
@interface NDSystemMarkAllReplyParams : NSObject

@end

#pragma mark - 返回结果


#pragma mark - 请求接口

@interface NDSystemAPI : NDBaseAPI

/**
 *  提交意见
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)systemAddSuggestWithParams:(NDSystemAddSuggestParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询意见
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)systemQuerySuggestWithParams:(NDSystemQuerySuggestParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询是否有新的回复
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)systemCheckReplayWithParams:(NDSystemCheckReplyParams *)params completionBlockWithSuccess:(void(^)(BOOL))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  清空新回复标志
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)systemMarkAllReplyWithParams:(NDSystemMarkAllReplyParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


+(void)getWebSocketUrlCompletionBlockWithSuccess:(void(^)(NSString *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

@end
