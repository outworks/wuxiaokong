//
//  NDMailAPI.m
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "NDMailAPI.h"
#import "FavMail.h"


#pragma mark - 请求

@interface NDMailQueryRequest : NDAPIRequest

@property(nonatomic,strong) NDMailQueryParams *params;

@end

@implementation NDMailQueryRequest

-(NSString *)method{
    return URL_MAIL_QUERY;
}

@end


@interface NDMailMarkRequest : NDAPIRequest

@property(nonatomic,strong) NDMailMarkParams *params;

@end

@implementation NDMailMarkRequest

-(NSString *)method{
    return URL_MAIL_MARK;
}

@end

@interface NDMailSendRequest : NDAPIRequest

@property(nonatomic,strong) NDMailSendParams *params;

@end

@implementation NDMailSendRequest

-(NSString *)method{
    return URL_MAIL_SEND;
}

@end

/**
 *  查询未读邮件条数
 */

@interface NDMailQueryUnreadCountRequest : NDAPIRequest

@property(nonatomic,strong) NDMailQueryUnreadCountParams *params;


@end

@implementation NDMailQueryUnreadCountRequest

-(NSString *)method{
    return URL_MAIL_UNREADCNT;
}

@end


@interface NDMailFavAddRequest : NDAPIRequest


@property(nonatomic,strong) NDMailFavAddParams *params;


@end


@implementation NDMailFavAddRequest

-(NSString *)method{
    return URL_MAIL_FAVADD;
}

@end

@interface NDMailFavUpdRequest : NDAPIRequest

@property(nonatomic,strong) NDMailFavUpdParams *params;

@end

@implementation NDMailFavUpdRequest

-(NSString *)method{
    return URL_MAIL_FAVUPD;
}

@end

@interface NDMailFavDelRequest : NDAPIRequest

@property(nonatomic,strong) NDMailFavDelParams *params;

@end

@implementation NDMailFavDelRequest

-(NSString *)method{
    return URL_MAIL_FAVDEL;
}

@end

@interface NDMailFavPageRequest : NDAPIRequest

@property(nonatomic,strong) NDMailFavPageParams *params;

@end

@implementation NDMailFavPageRequest

-(NSString *)method{
    return URL_MAIL_FAVPAGE;
}

@end

@interface NDMailFavGetRequest : NDAPIRequest

@property(nonatomic,strong) NDMailFavGetParams *params;

@end

@implementation NDMailFavGetRequest

-(NSString *)method{
    return URL_MAIL_FAVGET;
}

@end


@interface NDMailSendGreetingRequest : NDAPIRequest

@property(nonatomic,strong) NDMailSendGreetingParams *params;

@end

@implementation NDMailSendGreetingRequest

-(NSString *)method{
    return URL_MAIL_SENDGREETING;
}

@end


@interface NDMailGreetingRequest : NDAPIRequest

@property(nonatomic,strong) NDMailGreetingParams *params;

@end

@implementation NDMailGreetingRequest

-(NSString *)method{
    return URL_MAIL_GREETING;
}

@end

@interface NDMailGreetingPraiseTotalRequest : NDAPIRequest

@property(nonatomic,strong) NDMailGreetingPraiseTotalParams *params;

@end

@implementation NDMailGreetingPraiseTotalRequest

-(NSString *)method{
    return URL_MAIL_GREETINGPRAISETOTAL;
}

@end


@interface NDMailGreetingPraiseRequest : NDAPIRequest

@property(nonatomic,strong) NDMailGreetingPraiseParams *params;

@end

@implementation NDMailGreetingPraiseRequest

-(NSString *)method{
    return URL_MAIL_GREETINGPRAISE;
}

@end




#pragma mark - 请求参数

@implementation NDMailQueryParams
@end

@implementation NDMailMarkParams
@end

@implementation NDMailSendParams
@end

@implementation NDMailQueryUnreadCountParams
@end

@implementation NDMailFavAddParams
@end

@implementation NDMailFavUpdParams
@end

@implementation NDMailFavDelParams
@end

@implementation NDMailFavPageParams
@end

@implementation NDMailFavGetParams
@end

@implementation NDMailSendGreetingParams
@end

@implementation NDMailGreetingParams
@end

@implementation NDMailGreetingPraiseTotalParams
@end

@implementation NDMailGreetingPraiseParams
@end


#pragma mark - 返回结果

@implementation NDMailSendResult
@end

@implementation NDMailFavAddResult
@end

@implementation NDMailFavPageResult

+(Class)__favsClass{
    return [FavMail class];
}

@end


@implementation NDMailFavGetResult

+(Class)__favClass{
    return [FavMailDetail class];
}

@end


@implementation NDMailQueryUnreadCountResult

@end

@implementation NDMailSendGreetingResult

@end

@implementation NDMailGreetingResult

+(Class)__listClass{
    return [GreetingMail class];
}

@end

@implementation NDMailGreetingPraiseTotalResult

@end


#pragma mark - 请求接口
@implementation NDMailAPI


/**
 *  查询邮件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailqueryWithParams:(NDMailQueryParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDMailQueryRequest *request = [[NDMailQueryRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[Mail class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  标记邮件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailMarkWithParams:(NDMailMarkParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDMailMarkRequest *request = [[NDMailMarkRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}


/**
 *  发送邮件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailSendWithParams:(NDMailSendParams *)params completionBlockWithSuccess:(void(^)(NDMailSendResult *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDMailSendRequest *request = [[NDMailSendRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NDMailSendResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NDMailSendResult *data = (NDMailSendResult *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  添加收藏邮件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailFavAddWithParams:(NDMailFavAddParams *)params completionBlockWithSuccess:(void(^)(NDMailFavAddResult *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDMailFavAddRequest *request = [[NDMailFavAddRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NDMailFavAddResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NDMailFavAddResult *data = (NDMailFavAddResult *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  修改收藏邮件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailFavUpdWithParams:(NDMailFavUpdParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDMailFavUpdRequest *request = [[NDMailFavUpdRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

/**
 *  删除收藏邮件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailFavDelWithParams:(NDMailFavDelParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDMailFavDelRequest *request = [[NDMailFavDelRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}


/**
 *  查询收藏邮件分页列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailFavPageWithParams:(NDMailFavPageParams *)params completionBlockWithSuccess:(void(^)(NDMailFavPageResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDMailFavPageRequest *request = [[NDMailFavPageRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NDMailFavPageResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        
        NDMailFavPageResult *data = (NDMailFavPageResult *)result;
        sucess(data);
        
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}


/**
 *  获取收藏邮件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailFavGetWithParams:(NDMailFavGetParams *)params completionBlockWithSuccess:(void(^)(NDMailFavGetResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDMailFavGetRequest *request = [[NDMailFavGetRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NDMailFavGetResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        
        NDMailFavGetResult *data = (NDMailFavGetResult *)result;
        sucess(data);
        
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}


/**
 *  查询未读邮件条件
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailQueryUnreadCountWithParams:(NDMailQueryUnreadCountParams *)params completionBlockWithSuccess:(void(^)(NDMailQueryUnreadCountResult *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDMailQueryUnreadCountRequest *request = [[NDMailQueryUnreadCountRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NDMailQueryUnreadCountResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NDMailQueryUnreadCountResult *data = (NDMailQueryUnreadCountResult *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  发送新年祝福语
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailSendGreetingWithParams:(NDMailSendGreetingParams *)params completionBlockWithSuccess:(void(^)(NDMailSendGreetingResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDMailSendGreetingRequest *request = [NDMailSendGreetingRequest alloc];
    request.params = params;
    [self request:request resultClass:[NDMailSendGreetingResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NDMailSendGreetingResult *data = (NDMailSendGreetingResult *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

/**
 *  获取新年祝福语
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)mailGreetingWithParams:(NDMailGreetingParams *)params completionBlockWithSuccess:(void(^)(NDMailGreetingResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDMailGreetingRequest *request = [[NDMailGreetingRequest alloc] init];
    request.params = params;
    
    [self request:request resultClass:[NDMailGreetingResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NDMailGreetingResult *data = (NDMailGreetingResult *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}


/**
 *  获取新年祝福语数量信息
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */


+(void)mailGreetingPraiseTotalWithParams:(NDMailGreetingPraiseTotalParams *)params completionBlockWithSuccess:(void(^)(NDMailGreetingPraiseTotalResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDMailGreetingPraiseTotalRequest *request = [[NDMailGreetingPraiseTotalRequest alloc] init];
    request.params = params;
    
    [self request:request resultClass:[NDMailGreetingPraiseTotalResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NDMailGreetingPraiseTotalResult *data = (NDMailGreetingPraiseTotalResult *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
    
    


}

/**
 *  祝福语点赞
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */


+(void)mailGreetingPraiseWithParams:(NDMailGreetingPraiseParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDMailGreetingPraiseRequest *request = [[NDMailGreetingPraiseRequest alloc] init];
    request.params = params;
    
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
       
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}


@end
