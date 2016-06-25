//
//  NDUserAPI.h
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDBaseAPI.h"
#import "User.h"
#import "PushLog.h"
#import "PushLogPageSubData.h"


#pragma mark - 请求参数

/**
 *  第三方验证
 */
@interface ND3rdLoginParams : NSObject

@property(nonatomic,strong) NSString *channel; //第三方渠道 阿里：ali   微信:wx   QQ:qq
@property(nonatomic,strong) NSString *account; //第三方ID
@property(nonatomic,strong) NSString *token; //第三方token
@property(nonatomic,strong) NSString *info; //第三方附加信息（可不填）

@end

/**
 * 账号登录
 */

@interface NDUserLoginParams : NSObject

@property(nonatomic,strong) NSString * user_name; //用户名
@property(nonatomic,strong) NSString * password; //密码

@end


/**
 * 手机注册账号
 */

@interface NDUserPhoneRegisterParams : NSObject

@property(nonatomic,strong) NSString * phone; //用户名
@property(nonatomic,strong) NSString * code; //短信验证码
@property(nonatomic,strong) NSString * password; //密码（MD5加密）
@property(nonatomic,strong) NSString * info; //额外信息

@end


/**
 * 更新用户密码接口
 */

@interface NDUserUpdatePassword2Params : NSObject

@property(nonatomic,strong) NSString * phone; //用户名
@property(nonatomic,strong) NSString * code; //短信验证码
@property(nonatomic,strong) NSString * newpasswd; //密码（MD5加密）


@end



/**
 * 获取短信验证码
 */

@interface NDUserAuthCodeParams : NSObject

@property(nonatomic,strong) NSString * phone; //用户名
@property(nonatomic,strong) NSString * action; //短信头部
@property(nonatomic,strong) NSString * topic; //项目名称


@end


/**
 *  用户详情
 */

@interface NDUserDetailParams : NSObject

@property(nonatomic,strong) NSString *id_list; //用户id列表,

@end


/**
 *  修改用户信息
 */

@interface NDUserUpdateParams : NSObject

@property(nonatomic,strong) NSString * nickname; //用户昵称
@property(nonatomic,strong) NSString * icon; //用户头像

@end

/**
 *  修改用户密码
 */

@interface NDUserUpdatePasswordParams : NSObject

@property(nonatomic,strong) NSString * oldpasswd; //用户昵称
@property(nonatomic,strong) NSString * newpasswd; //用户头像

@end


/**
 *  上传JPushID
 */

@interface NDUserSetJPushIdParams : NSObject

@property(nonatomic,strong) NSString * jpush_id; //jpushID
@property(nonatomic,assign) NSInteger channel; //用于appStore
@property(nonatomic,strong) NSString *type;//jg-极光  mi:小米  hw:华为
@property(nonatomic,strong) NSString *platform;//平台  android\ios

@end

@interface NDUserClearJPushIdParams : NSObject

@end


/**
 *  通过业务服务器绑定手机，注意和账号服务器那个绑定区分
 */
@interface BindPhone2Params : NSObject
@property(nonatomic,strong) NSString *phone;        //手机
@property(nonatomic,strong) NSString *code;         //手机验证码
@property(nonatomic,strong) NSString *password;     //用户密码
@end

@interface BindPhone2Request : NDAPIRequest
@property(nonatomic,strong) BindPhone2Params *params;
@end

/**
 *  微信登陆成功后获取用户信息,用于判断绑定手机
 */

@interface NDUserInfoParams : NSObject

@property(nonatomic,strong) NSString *user_id; //用户id
@property(nonatomic,strong) NSString *user_name; //用户名

@end


/**
 *  查询推送日志分类个数列表
 */

@interface NDUserGetPushLogParams : NSObject

@end

/**
 *  设置某分类推送日志已读
 */

@interface NDUserReadPushLogParams : NSObject

@property(nonatomic,assign) NSInteger msg_from; // 发送者id （0-系统通知 1-系统请求 其他-公众号或其他类型）

@end

/**
 *  获取某分类下推送日志的分页列表
 */

@interface NDUserPageSubPushLogParams : NSObject

@property(nonatomic,assign) NSInteger msg_from; // 发送者id （0-系统通知 1-系统请求 其他-公众号或其他类型）
@property(nonatomic,assign) NSInteger page; // 页码，从1开始，默认1
@property(nonatomic,assign) NSInteger rows; // 每页记录数，默认10

@end

@interface NDUSerCollectParams : NSObject

@property(nonatomic,strong) NSString *platform;
@property(nonatomic,strong) NSString *devmodel;
@property(nonatomic,strong) NSString *devversion;
@property(nonatomic,strong) NSString *appversion;

@end

@interface NDUserDelPUshLogParams : NSObject

@property(nonatomic,strong) NSNumber *msg_id;//消息ID

@end

#pragma mark - 返回结果

/**
 *  第三方登录结果
 */
@interface ND3rdLoginResult : NSObject

@property(nonatomic,strong) NSString *user_id; //用户id
@property(nonatomic,strong) NSString *token; //返回token

@end


/**
 *  账号登录结果
 */
@interface NDUserLoginResult : NSObject

@property(nonatomic,strong) NSString *user_id; //用户id
@property(nonatomic,strong) NSString *token; //返回token

@end

/**
 * 手机注册账号
 */

@interface NDUserPhoneRegisterResult : NSObject

@property(nonatomic,strong) NSString *user_id; // 用户id
@property(nonatomic,strong) NSString *token; //返回token
@property(nonatomic,strong) NSString *userName; //返回token


@end


/**
 *  查询推送日志分类个数列表
 */
@interface NDUserGetPushLogResult : NSObject

@property(nonatomic,strong) NSArray *data; // 日志分类个数列表

@end


/**
 *  设置某分类推送日志已读
 */
@interface NDUserReadPushLogResult : NSObject

@property(nonatomic,strong) NSString *data;

@end

/**
 *  设置某分类推送日志已读
 */
@interface NDUserPageSubPushLogResult : NSObject

@property(nonatomic,strong) PushLogPageSubData *data;//分页列表

@end



#pragma mark - 请求接口

@interface NDUserAPI : NDBaseAPI

/**
 *  第三方登入
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userThirdLoginWithParams:(ND3rdLoginParams *)params completionBlockWithSuccess:(void(^)(ND3rdLoginResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  账号登录
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userLoginWithParams:(NDUserLoginParams *)params completionBlockWithSuccess:(void(^)(NDUserLoginResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  手机注册账号
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userPhoneRegisterWithParams:(NDUserPhoneRegisterParams *)params completionBlockWithSuccess:(void(^)(NDUserPhoneRegisterResult *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;



/**
 * 更新用户密码接口
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */


+(void)userUpdatePassword2WithParams:(NDUserUpdatePassword2Params *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  短信验证码
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userAuthCodeWithParams:(NDUserAuthCodeParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  用户详情
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userDetailWithParams:(NDUserDetailParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;



/**
 *  修改用户信息
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userUpdateWithParams:(NDUserUpdateParams *)params completionBlockWithSuccess:(void(^)(User *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  修改用户密码
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userUpdatePasswordWithParams:(NDUserUpdatePasswordParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  上传jpushID
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)userSetJPushIdWithParams:(NDUserSetJPushIdParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;



/**
 *  注销jpushID
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userClearJPushIdWithParams:(NDUserClearJPushIdParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;



/**
 *  通过业务服务器绑定手机，注意和账号服务器那个绑定区分
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userBindPhone2:(BindPhone2Request *)request success:(void(^)(void))success fail:(void(^)(int code,NSString *desciption))fail;



/**
 *  获取用户信息
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)getUserInfoWithParams:(NDUserInfoParams *)params completionBlockWithSuccess:(void(^)(NSObject *result))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;



/**
 *  查询推送日志分类个数列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userGetPushLogWithParams:(NDUserGetPushLogParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;



/**
 *  设置某分类推送日志已读
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userReadPushLogWithParams:(NDUserReadPushLogParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;



/**
 *  获取某分类下推送日志的分页列表
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userPageSubPushLogWithParams:(NDUserPageSubPushLogParams *)params completionBlockWithSuccess:(void(^)(PushLogPageSubData *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  用户数据收集
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)userCollectWithParams:(NDUSerCollectParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  删除某条消息
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)delPushLogWithParams:(NDUserDelPUshLogParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

@end


