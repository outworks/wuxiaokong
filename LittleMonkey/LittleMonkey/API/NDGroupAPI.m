//
//  NDGroupAPI.m
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "NDGroupAPI.h"
#import "LKDBHelper.h"

#pragma mark - 请求

@interface NDGroupAddRequest : NDAPIRequest

@property(nonatomic,strong) NDGroupAddParams *params;

@end

@implementation NDGroupAddRequest

-(NSString *)method{
    return URL_GROUP_ADD;
}

@end


@interface NDGroupDetailRequest : NDAPIRequest

@property(nonatomic,strong) NDGroupDetailParams *params;

@end

@implementation NDGroupDetailRequest

-(NSString *)method{
    return URL_GROUP_DETAIL;
}

@end


@interface NDGroupUpdateRequest : NDAPIRequest

@property(nonatomic,strong) NDGroupUpdateParams *params;

@end

@implementation NDGroupUpdateRequest

-(NSString *)method{
    return URL_GROUP_UPDATE;
}

@end


@interface NDGroupDismissRequest : NDAPIRequest

@property(nonatomic,strong) NDGroupDismissParams *params;

@end

@implementation NDGroupDismissRequest

-(NSString *)method{
    return URL_GROUP_DISMISS;
}

@end


@interface NDGroupAddToyRequest : NDAPIRequest

@property(nonatomic,strong) NDGroupAddToyParams *params;

@end

@implementation NDGroupAddToyRequest

-(NSString *)method{
    return URL_GROUP_ADDTOY;
}

@end


@interface NDGroupKickOutRequest : NDAPIRequest

@property(nonatomic,strong) NDGroupKickOutParams *params;

@end

@implementation NDGroupKickOutRequest

-(NSString *)method{
    return URL_GROUP_KICKOUT;
}

@end


@interface NDGroupApplyJoinRequest : NDAPIRequest

@property(nonatomic,strong) NDGroupApplyJoinParams *params;

@end

@implementation NDGroupApplyJoinRequest

-(NSString *)method{
    return URL_GROUP_APPLYJOIN;
}

@end

@interface NDGroupQueryApplyRequest : NDAPIRequest

@property(nonatomic,strong) NSObject *params;

@end

@implementation NDGroupQueryApplyRequest

-(NSString *)method{
    return URL_GROUP_QUERYAPPLY;
}

@end

@interface NDGroupProcessApplyRequest : NDAPIRequest

@property(nonatomic,strong)NDGroupProcessApplyParams *params;

@end

@implementation NDGroupProcessApplyRequest

-(NSString *)method{
    return URL_GROUP_PROCESSAPPLY;
}

@end

@interface NDGroupQuitRequest : NDAPIRequest

@property(nonatomic,strong)NDGroupQuitParams *params;

@end

@implementation NDGroupQuitRequest

-(NSString *)method{
    return URL_GROUP_QUIT;
}

@end

@interface NDGroupInviteCodeRequest : NDAPIRequest

@property(nonatomic,strong)NDGroupInviteCodeParams *params;

@end

@implementation NDGroupInviteCodeRequest

-(NSString *)method{
    return URL_GROUP_INVITECODE;
}

@end

@interface NDGroupSearchRequest : NDAPIRequest

@property(nonatomic,strong) NDGroupDetailParams *params;

@end

@implementation NDGroupSearchRequest

-(NSString *)method{
    return URL_GROUP_SEARCH;
}

@end

#pragma mark - 请求参数

@implementation  NDGroupAddParams
@end

@implementation  NDGroupDetailParams
@end

@implementation  NDGroupUpdateParams
@end

@implementation  NDGroupDismissParams
@end

@implementation NDGroupAddToyParams

@end

@implementation NDGroupKickOutParams

@end

@implementation NDGroupApplyJoinParams

@end

@implementation NDGroupProcessApplyParams

@end

@implementation NDGroupQuitParams

@end

@interface NDQueryApplyParams : NSObject

@end
@implementation NDQueryApplyParams

@end

@implementation NDGroupInviteCodeParams

@end


#pragma mark - 请求结果

@implementation NDGroupInviteCodeResult


@end


#pragma mark - 请求接口

@implementation NDGroupAPI

/**
 *  创建群
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)groupAddWithParams:(NDGroupAddParams *)params completionBlockWithSuccess:(void(^)(Group *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDGroupAddRequest *request = [[NDGroupAddRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[Group class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        Group *data = (Group *)result;
        [data save];
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  查询群详情
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupDetailWithParams:(NDGroupDetailParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDGroupDetailRequest *request = [[NDGroupDetailRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[GroupDetail class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}


/**
 *  更新群信息
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupUpdateWithParams:(NDGroupUpdateParams *)params completionBlockWithSuccess:(void(^)(GroupDetail *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDGroupUpdateRequest *request = [[NDGroupUpdateRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[GroupDetail class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        GroupDetail *data = (GroupDetail *)result;
        [data save];
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}


/**
 *  解散群
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupDismissWithParams:(NDGroupDismissParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDGroupDismissRequest *request = [[NDGroupDismissRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  增加玩具
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupAddToyWithParams:(NDGroupAddToyParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDGroupAddToyRequest *request = [[NDGroupAddToyRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}


/**
 *  移除群用户
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupKickOutWithParams:(NDGroupKickOutParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDGroupKickOutRequest *request = [[NDGroupKickOutRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  申请加群
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupApplyJoinWithParams:(NDGroupApplyJoinParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDGroupApplyJoinRequest *request = [[NDGroupApplyJoinRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  查询加群请求
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupQueryApplyCompletionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDGroupQueryApplyRequest *request = [[NDGroupQueryApplyRequest alloc] init];
    request.params = [[NDQueryApplyParams alloc]init];
    [self request:request resultClass:[ApplyInfo class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}


/**
 *  处理加入群请求
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupProcessApplyWithParams:(NDGroupProcessApplyParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDGroupProcessApplyRequest *request = [[NDGroupProcessApplyRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}


/**
 *  退出群
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupQuitWithParams:(NDGroupQuitParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDGroupQuitRequest *request = [[NDGroupQuitRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

/**
 *  邀请码
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupInviteCodeWithParams:(NDGroupInviteCodeParams *)params completionBlockWithSuccess:(void(^)(NDGroupInviteCodeResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDGroupInviteCodeRequest *request = [[NDGroupInviteCodeRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NDGroupInviteCodeResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NDGroupInviteCodeResult *data = (NDGroupInviteCodeResult *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  搜索群
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)groupSearchWithParams:(NDGroupDetailParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDGroupSearchRequest *request = [[NDGroupSearchRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[GroupDetail class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}



@end
