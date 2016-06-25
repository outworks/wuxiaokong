//
//  NDSystemAPI.m
//  HelloToy
//
//  Created by nd on 15/5/20.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "NDSystemAPI.h"

#import "Suggest.h"

#pragma mark - 请求

@interface NDSystemAddSuggestRequest : NDAPIRequest

@property(nonatomic,strong) NDSystemAddSuggestParams *params;

@end

@implementation NDSystemAddSuggestRequest

-(NSString *)method{
    return URL_SYSTEM_ADDSUGGEST;
}

@end


@interface NDSystemQuerySuggestRequest : NDAPIRequest

@property(nonatomic,strong) NDSystemQuerySuggestParams *params;

@end

@implementation NDSystemQuerySuggestRequest

-(NSString *)method{
    return URL_SYSTEM_QUERYSUGGEST;
}

@end


@interface NDSystemCheckReplyRequest : NDAPIRequest

@property(nonatomic,strong) NDSystemCheckReplyParams *params;

@end

@implementation NDSystemCheckReplyRequest

-(NSString *)method{
    return URL_SYSTEM_HASREPLY;
}

@end


@interface NDSystemMarkAllReplyRequest : NDAPIRequest

@property(nonatomic,strong) NDSystemMarkAllReplyParams *params;

@end

@implementation NDSystemMarkAllReplyRequest

-(NSString *)method{
    return URL_SYSTEM_CLEARREPLY;
}

@end

@interface WSLoginRequest : NDAPIRequest

@property(nonatomic,strong) NSObject *params;

@end

@implementation WSLoginRequest

-(id)init{
    self = [super init];
    if (self) {
        self.params = @{};
    }
    return self;
}

-(NSString *)method{
    return URL_WEBSOCKET_URL;
}

-(NSString *)_serverUrl{
    return URL_SERVER_LOGIN_BASE;
}

-(NSString *)_apiPath{
    return V1_API_ACCOUNT;
}

@end

@interface WSLoginResponse : NSObject

@property(nonatomic,strong) NSString *user_id;
@property(nonatomic,strong) NSString *token;
@property(nonatomic,strong) NSString *url;

@end

@implementation WSLoginResponse

@end



#pragma mark - 请求参数

@implementation NDSystemAddSuggestParams

@end

@implementation NDSystemQuerySuggestParams

@end

@implementation NDSystemCheckReplyParams

@end

@implementation NDSystemMarkAllReplyParams

@end

#pragma mark - 返回结果


#pragma mark - 请求接口


@implementation NDSystemAPI

/**
 *  提交意见
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)systemAddSuggestWithParams:(NDSystemAddSuggestParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDSystemAddSuggestRequest *request = [[NDSystemAddSuggestRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}


/**
 *  查询意见
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)systemQuerySuggestWithParams:(NDSystemQuerySuggestParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDSystemQuerySuggestRequest *request = [[NDSystemQuerySuggestRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[Suggest class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        
        NSArray *data = (NSArray *)result;
        
        sucess(data);
        
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}


/**
 *  查询是否有新的回复
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)systemCheckReplayWithParams:(NDSystemCheckReplyParams *)params completionBlockWithSuccess:(void(^)(BOOL result))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDSystemCheckReplyRequest *request = [[NDSystemCheckReplyRequest alloc]init];
    request.params = params;
    [self request:request resultClass:([NSObject class]) completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        if (result) {
            NSDictionary *dict = (NSDictionary *)result;
            NSNumber *number = [dict objectForKey:@"result"];
            sucess([number boolValue]);
        }else{
            fail(0,@"");
        }
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}


/**
 *  清空新回复标志
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)systemMarkAllReplyWithParams:(NDSystemMarkAllReplyParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDSystemMarkAllReplyRequest *request = [[NDSystemMarkAllReplyRequest alloc]init];
    request.params = params;
    [self request:request resultClass:([NSObject class]) completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

+(void)getWebSocketUrlCompletionBlockWithSuccess:(void(^)(NSString *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    WSLoginRequest *request = [[WSLoginRequest alloc]init];
        
    [self request:request resultClass:[WSLoginResponse class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        if (result) {
            WSLoginResponse *response = (WSLoginResponse *)result;
            sucess(response.url);
        }
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}


@end
