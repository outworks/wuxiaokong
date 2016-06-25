//
//  NDUserAPI.m
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "NDUserAPI.h"
#import "NDAPIShareValue.h"

#pragma mark - 请求

@interface ND3rdLoginRequest:NDAPIRequest

@property(nonatomic,strong) ND3rdLoginParams *params;

@end

@implementation ND3rdLoginRequest

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(NSString *)_serverUrl{
    return URL_SERVER_LOGIN_BASE;

}


-(NSString *)_apiPath{
    return V1_API_ACCOUNT;
}

-(NSString *)method{
    return URL_USER_THIRDLOGIN;
}

-(BOOL)_ignoreToken{
    return YES;
}

-(BOOL)_ignoreUserid{
    return YES;
}

@end


@interface NDUserLoginRequest:NDAPIRequest

@property(nonatomic,strong) NDUserLoginParams *params;

@end

@implementation NDUserLoginRequest

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(NSString *)_serverUrl{
    return URL_SERVER_LOGIN_BASE;
    
}


-(NSString *)_apiPath{
    return V1_API_ACCOUNT;
}

-(NSString *)method{
    return URL_USER_LOGIN;
}

-(BOOL)_ignoreToken{
    return YES;
}

-(BOOL)_ignoreUserid{
    return YES;
}

@end

@interface NDUserPhoneRegisterRequest: NDAPIRequest

@property(nonatomic,strong) NDUserPhoneRegisterParams *params;

@end

@implementation NDUserPhoneRegisterRequest

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(NSString *)_serverUrl{
    return URL_SERVER_LOGIN_BASE;
    
}


-(NSString *)_apiPath{
    return V1_API_ACCOUNT;
}

-(NSString *)method{
    return URL_USER_PHONEREGISTER;
}

-(BOOL)_ignoreToken{
    return YES;
}

-(BOOL)_ignoreUserid{
    return YES;
}

@end


@interface NDUserUpdatePassword2Request : NDAPIRequest

@property(nonatomic,strong) NDUserUpdatePassword2Params *params;

@end

@implementation NDUserUpdatePassword2Request


-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(NSString *)_serverUrl{
    return URL_SERVER_LOGIN_BASE;
    
}


-(NSString *)_apiPath{
    return V1_API_ACCOUNT;
}

-(NSString *)method{
    return URL_USER_UPDATEPASSWORD2;
}

-(BOOL)_ignoreToken{
    return YES;
}

-(BOOL)_ignoreUserid{
    return YES;
}


@end


@interface NDUserUpdatePasswordRequest : NDAPIRequest

@property(nonatomic,strong) NDUserUpdatePasswordParams *params;

@end

@implementation NDUserUpdatePasswordRequest


-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(NSString *)_serverUrl{
    return URL_SERVER_LOGIN_BASE;
    
}

-(NSString *)_apiPath{
    return V1_API_ACCOUNT;
}

-(NSString *)method{
    return URL_USER_UPDATEPASSWORD;
}

-(BOOL)_ignoreToken{
    return YES;
}

-(BOOL)_ignoreUserid{
    return YES;
}


@end

@interface NDUserAutoCodeRequest:NDAPIRequest

@property(nonatomic,strong) NDUserAuthCodeParams *params;

@end

@implementation NDUserAutoCodeRequest

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(NSString *)_serverUrl{
    return URL_SERVER_LOGIN_BASE;
    
}


-(NSString *)_apiPath{
    return V1_API_ACCOUNT;
}

-(NSString *)method{
    return URL_USER_AUTHCODE;
}

-(BOOL)_ignoreToken{
    return YES;
}

-(BOOL)_ignoreUserid{
    return YES;
}

@end


@interface NDUserDetailRequest : NDAPIRequest

@property(nonatomic,strong) NDUserDetailParams *params;

@end

@implementation NDUserDetailRequest

-(NSString *)method{
    return URL_USER_DETAIL;
}

@end

@interface NDUserUpdateRequest : NDAPIRequest

@property(nonatomic,strong) NDUserUpdateParams *params;

@end

@implementation NDUserUpdateRequest

-(NSString *)method{
    return URL_USER_UPDATE;
}

@end

@interface NDUserSetJPushIdRequest : NDAPIRequest

@property(nonatomic,strong) NDUserSetJPushIdParams *params;

@end

@implementation NDUserSetJPushIdRequest

-(NSString *)method{
    return URL_USER_SETJPUSHID;
}

@end

@interface NDUserClearJPushIdRequest : NDAPIRequest

@property(nonatomic,strong) NDUserClearJPushIdParams *params;

@end

@implementation NDUserClearJPushIdRequest

-(NSString *)method{
    return URL_USER_CLEARJPUSHID;
}

@end

/**
 *  通过业务服务器绑定手机，注意和账号服务器那个绑定区分
 */

@implementation BindPhone2Request
-(id)init{
    self = [super init];
    if (self) {
        self.params = [[BindPhone2Params alloc]init];
    }
    return self;
}

-(NSString *)_serverUrl{
    return URL_SERVER_LOGIN_BASE;
    
}


-(NSString *)_apiPath{
    return V1_API_ACCOUNT;
}

-(NSString *)method{
    return URL_USER_BINDPHONE;
}

@end


/**
 *  微信登陆成功后获取用户信息,用于判断绑定手机
 */

@interface NDUserInfoRequest : NDAPIRequest
@property(nonatomic,strong) NDUserInfoParams *params;
@end

@implementation NDUserInfoRequest
-(id)init{
    self = [super init];
    if (self) {
        self.params = [[NDUserInfoParams alloc]init];
    }
    return self;
}

-(NSString *)_serverUrl{
    return URL_SERVER_LOGIN_BASE;
    
}


-(NSString *)_apiPath{
    return V1_API_ACCOUNT;
}

-(NSString *)method{
    return URL_USER_INFO;
}


@end

/**
 *  查询推送日志分类个数列表
 */

@interface NDUserGetPushLogRequest : NDAPIRequest
@property(nonatomic,strong) NDUserGetPushLogParams *params;
@end

@implementation NDUserGetPushLogRequest

-(NSString *)method{
    return URL_USER_GETPUSHLOG;
}

@end

/**
 *  设置某分类推送日志已读
 */

@interface NDUserReadPushLogRequest : NDAPIRequest
@property(nonatomic,strong) NDUserReadPushLogParams *params;
@end

@implementation NDUserReadPushLogRequest

-(NSString *)method{
    return URL_USER_READPUSHLOG;
}

@end

/**
 *  获取某分类下推送日志的分页列表
 */

@interface NDUserPageSubPushLogRequest : NDAPIRequest
@property(nonatomic,strong) NDUserPageSubPushLogParams *params;
@end

@implementation NDUserPageSubPushLogRequest

-(NSString *)method{
    return URL_USER_PAGESUBPUSHLOG;
}

@end

@interface NDUserCollectRequest : NDAPIRequest
@property(nonatomic,strong) NDUSerCollectParams *params;
@end

@implementation NDUserCollectRequest

-(NSString *)method{
    return URL_USER_COLLECT;
}

@end

@interface NDUserDelPUshLogRequest : NDAPIRequest

@property(nonatomic,strong) NDUserDelPUshLogParams *params;

@end


@implementation NDUserDelPUshLogRequest

-(NSString *)method{
    return URL_USER_DELPUSHLOG;
}

@end

#pragma mark - 请求参数

@implementation ND3rdLoginParams
@end

@implementation NDUserLoginParams
@end

@implementation NDUserPhoneRegisterParams
@end

@implementation NDUserDetailParams
@end

@implementation NDUserUpdateParams
@end

@implementation NDUserSetJPushIdParams

-(id)init{
    self = [super init];
    if (self) {
        self.type = @"mi";
        self.platform = @"ios";
        self.channel = 0;
    }
    return self;
}

@end

@implementation NDUserAuthCodeParams
@end

@implementation NDUserClearJPushIdParams
@end

@implementation NDUserUpdatePasswordParams
@end

@implementation NDUserUpdatePassword2Params
@end

@implementation BindPhone2Params
@end

@implementation NDUserInfoParams
@end

@implementation NDUserGetPushLogParams
@end

@implementation NDUserReadPushLogParams
@end

@implementation NDUserPageSubPushLogParams
@end

@implementation NDUSerCollectParams
@end

@implementation NDUserDelPUshLogParams

@end

#pragma mark - 返回结果
@implementation ND3rdLoginResult
@end

@implementation NDUserLoginResult
@end

@implementation NDUserPhoneRegisterResult
@end

@implementation NDUserGetPushLogResult
@end

@implementation NDUserReadPushLogResult
@end

@implementation NDUserPageSubPushLogResult
@end

#pragma mark - 请求接口

@implementation NDUserAPI

/**
 *  第三方登入
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)userThirdLoginWithParams:(ND3rdLoginParams *)params completionBlockWithSuccess:(void(^)(ND3rdLoginResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    ND3rdLoginRequest *request = [[ND3rdLoginRequest alloc]init];
    request.params = params;
    [self request:request resultClass:[ND3rdLoginResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        ND3rdLoginResult *loginResult = (ND3rdLoginResult *)result;
        [NDAPIShareValue standardShareValue].user_id = loginResult.user_id;
        [NDAPIShareValue standardShareValue].token = loginResult.token;
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_LOGINED object:nil];
        sucess(loginResult);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}


/**
 *  账号登录
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userLoginWithParams:(NDUserLoginParams *)params completionBlockWithSuccess:(void(^)(NDUserLoginResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDUserLoginRequest *request = [[NDUserLoginRequest alloc] init];
    request.params = params;
    
    [self request:request resultClass:[NDUserLoginResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NDUserLoginResult *loginResult = (NDUserLoginResult *)result;
        [NDAPIShareValue standardShareValue].user_id = loginResult.user_id;
        [NDAPIShareValue standardShareValue].token = loginResult.token;
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_LOGINED object:nil];
        sucess(loginResult);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  手机注册账号
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userPhoneRegisterWithParams:(NDUserPhoneRegisterParams *)params completionBlockWithSuccess:(void(^)(NDUserPhoneRegisterResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDUserPhoneRegisterRequest *request = [[NDUserPhoneRegisterRequest alloc] init];
    request.params = params;
    
    [self request:request resultClass:[NDUserPhoneRegisterResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NDUserPhoneRegisterResult *loginResult = (NDUserPhoneRegisterResult *)result;
        [NDAPIShareValue standardShareValue].user_id = loginResult.user_id;
        [NDAPIShareValue standardShareValue].token = loginResult.token;
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_LOGINED object:nil];
        sucess(loginResult);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  更新用户密码接口
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userUpdatePassword2WithParams:(NDUserUpdatePassword2Params *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDUserUpdatePassword2Request *request = [[NDUserUpdatePassword2Request alloc] init];
    request.params = params;
    
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}


/**
 *  短信验证码
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userAuthCodeWithParams:(NDUserAuthCodeParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDUserAutoCodeRequest *request = [[NDUserAutoCodeRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
         sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}



/**
 *  用户详情
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userDetailWithParams:(NDUserDetailParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDUserDetailRequest *request = [[NDUserDetailRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[User class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        
        for (User *user in data) {
            [user save];
        }
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}


/**
 *  修改用户信息
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userUpdateWithParams:(NDUserUpdateParams *)params completionBlockWithSuccess:(void(^)(User *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDUserUpdateRequest *request = [[NDUserUpdateRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[User class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        User *data = (User *)result;
        [data save];
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  修改用户密码
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userUpdatePasswordWithParams:(NDUserUpdatePasswordParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDUserUpdatePasswordRequest *request = [[NDUserUpdatePasswordRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];





}


/**
 *  上传jpushID
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userSetJPushIdWithParams:(NDUserSetJPushIdParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDUserSetJPushIdRequest *request = [[NDUserSetJPushIdRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  注销jpushID
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userClearJPushIdWithParams:(NDUserClearJPushIdParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDUserClearJPushIdRequest *request = [[NDUserClearJPushIdRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  通过业务服务器绑定手机，注意和账号服务器那个绑定区分
 */
+(void)userBindPhone2:(BindPhone2Request *)request success:(void(^)(void))success fail:(void(^)(int code,NSString *desciption))fail{
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result,  NSString *message) {
        success();
    } Fail:^(int code,NSString *failDescript) {
        fail(code,failDescript);
    }];
}


/**
 *  获取用户信息
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)getUserInfoWithParams:(NDUserInfoParams *)params completionBlockWithSuccess:(void(^)(NSObject *result))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDUserInfoRequest *request = [[NDUserInfoRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess(result);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

/**
 *  查询推送日志分类个数列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userGetPushLogWithParams:(NDUserGetPushLogParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDUserGetPushLogRequest *request = [[NDUserGetPushLogRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[PushLog class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *array = (NSArray *)result;
        sucess(array);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

/**
 *  设置某分类推送日志已读
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userReadPushLogWithParams:(NDUserReadPushLogParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDUserReadPushLogRequest *request = [[NDUserReadPushLogRequest alloc] init];
    request.params = params;
    
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

/**
 *  获取某分类下推送日志的分页列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userPageSubPushLogWithParams:(NDUserPageSubPushLogParams *)params completionBlockWithSuccess:(void(^)(PushLogPageSubData *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDUserPageSubPushLogRequest *request = [[NDUserPageSubPushLogRequest alloc] init];
    request.params = params;
    
    [self request:request resultClass:[PushLogPageSubData class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        PushLogPageSubData *readPushLogResult = (PushLogPageSubData *)result;
        sucess(readPushLogResult);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

+(void)userCollectWithParams:(NDUSerCollectParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NDUserCollectRequest *request = [[NDUserCollectRequest alloc] init];
    request.params = params;
    
    [self request:request resultClass:[NDUserPageSubPushLogResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

/**
 *  删除某条消息
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)delPushLogWithParams:(NDUserDelPUshLogParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDUserDelPUshLogRequest *request = [[NDUserDelPUshLogRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

@end
