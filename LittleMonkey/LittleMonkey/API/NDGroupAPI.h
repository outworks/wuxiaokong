//
//  NDGroupAPI.h
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDBaseAPI.h"
#import "Group.h"
#import "GroupDetail.h"
#import "ApplyInfo.h"

#pragma mark - 请求参数

/**
 *  创建群
 */

@interface NDGroupAddParams : NSObject

@property(nonatomic,strong) NSString *name; // 群名称
@property(nonatomic,strong) NSString *icon; // 群图片

@end


/**
 *  查询群详情
 */

@interface NDGroupDetailParams : NSObject

@property(nonatomic,strong) NSString *id_list; //用户id列表,

@end


/**
 *  更新群信息
 */

@interface NDGroupUpdateParams : NSObject

@property(nonatomic,strong) NSNumber *group_id; //群ID
@property(nonatomic,strong) NSString *name; // 群名称
@property(nonatomic,strong) NSString *icon; // 群图片

@end


/**
 *  解散群
 */
@interface NDGroupDismissParams : NSObject

@property(nonatomic,strong) NSNumber *group_id; //群ID
@end


/**
 *  添加玩具
 */

@interface NDGroupAddToyParams : NSObject

@property(nonatomic,strong) NSNumber *toy_id; //玩具ID

@end


/**
 *  移除群用户
 */

@interface NDGroupKickOutParams : NSObject

@property(nonatomic,strong) NSNumber *user_id; //玩具ID

@end

/**
 *  申请加群
 */

@interface NDGroupApplyJoinParams : NSObject

@property(nonatomic,strong) NSNumber *group_id; //群ID
@property(nonatomic,strong) NSString *content; //描述

@end


/**
 *  处理加入群请求
 */
@interface NDGroupProcessApplyParams : NSObject

@property(nonatomic,strong) NSString *apply_id; //请求ID
@property(nonatomic,strong) NSNumber *agree; //同意或者反对
@property(nonatomic,strong) NSNumber *msg_id;//信息id

@end


/**
 *  退出群
 */
@interface NDGroupQuitParams : NSObject

@property(nonatomic,strong) NSNumber *group_id; //群ID

@end


/**
 *  邀请码
 */

@interface  NDGroupInviteCodeParams: NSObject

@property(nonatomic,strong) NSNumber *group_id;

@end

#pragma mark - 请求结果

@interface NDGroupInviteCodeResult : NSObject

@property(nonatomic,strong)NSString *inviteCode;

@end



#pragma mark - 请求接口

@interface NDGroupAPI : NDBaseAPI

/**
 *  创建群
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)groupAddWithParams:(NDGroupAddParams *)params completionBlockWithSuccess:(void(^)(Group *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询群详情
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupDetailWithParams:(NDGroupDetailParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  更新群信息
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupUpdateWithParams:(NDGroupUpdateParams *)params completionBlockWithSuccess:(void(^)(GroupDetail *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  解散群
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupDismissWithParams:(NDGroupDismissParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  增加玩具
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupAddToyWithParams:(NDGroupAddToyParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  移除群用户
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupKickOutWithParams:(NDGroupKickOutParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  申请加群
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupApplyJoinWithParams:(NDGroupApplyJoinParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  查询加群请求
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupQueryApplyCompletionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  处理加入群请求
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupProcessApplyWithParams:(NDGroupProcessApplyParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  退出群
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupQuitWithParams:(NDGroupQuitParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  邀请码
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupInviteCodeWithParams:(NDGroupInviteCodeParams *)params completionBlockWithSuccess:(void(^)(NDGroupInviteCodeResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  搜索群
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupSearchWithParams:(NDGroupDetailParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

@end
