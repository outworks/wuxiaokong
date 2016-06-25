//
//  NDBaseAPI.m
//  Pods
//
//  Created by ilikeido on 14-12-5.
//
//

#import "NDBaseAPI.h"
#import "NDAPIShareValue.h"

#import "ShareValue.h"
#import <CommonCrypto/CommonDigest.h>
#import "LK_NSDictionary2Object.h"
//#import "NSObject+LKExt.h"
#import <AFNetworking/AFNetworking.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "ImageFileInfo.h"

#define TIMEOUT_DEFAULT 30

#define SUCCESS_CODE 0

@interface NSString (md5)
-(NSString *) md5HexDigest;
@end

@implementation NSString (md5)

-(NSString *) md5HexDigest

{
    
    const char *original_str = [self UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < 16; i++)
        
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
    
}

@end


@implementation NDRequestSystem


-(id)init{
    self = [super init];
    if (self) {
        self.version = NDAPI_VERSION;
        self.jsonrpc = NDAPI_JSONRPC;
        self.key = [NDAPIShareValue standardShareValue].app_key;
        long timeInterval = (long)[[NSDate date]timeIntervalSince1970];
        self.time= [NSString stringWithFormat:@"%ld",timeInterval];
        self.sign = [[NSString stringWithFormat:@"%@%@%@%@%@",_key,_time,[NDAPIShareValue standardShareValue].user_id?[NDAPIShareValue standardShareValue].user_id:nil,[NDAPIShareValue standardShareValue].token?[NDAPIShareValue standardShareValue].token:nil,[NDAPIShareValue standardShareValue].secret_key]md5HexDigest];
    }
    return self;
}

-(void)ignoreToken:(BOOL)flag{
    if (flag) {
        self.sign = [[NSString stringWithFormat:@"%@%@%@",_key,_time,[NDAPIShareValue standardShareValue].secret_key]md5HexDigest];
    }else{
        self.sign = [[NSString stringWithFormat:@"%@%@%@%@%@",_key,_time,[NDAPIShareValue standardShareValue].user_id?[NDAPIShareValue standardShareValue].user_id:nil,[NDAPIShareValue standardShareValue].token?[NDAPIShareValue standardShareValue].token:nil,[NDAPIShareValue standardShareValue].secret_key]md5HexDigest];
    }
    
}


@end

@implementation NDRequestData

-(id)init{
    self = [super init];
    if (self) {
        self.user_id = [NDAPIShareValue standardShareValue].user_id?[NDAPIShareValue standardShareValue].user_id:nil;
        self.token = [NDAPIShareValue standardShareValue].token?[NDAPIShareValue standardShareValue].token:nil;
    }
    return self;
}


@end

@implementation NDAPIRequest{
    NSString *_apiPath;

}

-(NSObject *)params{
    return nil;
}
/**
 *  服务端地址
 *
 */
-(NSString *)_serverUrl{
    return URL_SERVER_BASE;
}

/**
 *  相应API路径
 *
 */
-(NSString *)_apiPath{
    return V1_API_TALK;
}

/**
 *  请求方法
 *
 */
-(NSString *)_method{
    return NDAPI_METHOD;
}

-(BOOL)_ignoreToken{
    return NO;
}

-(BOOL)_ignoreUserid{
    return NO;
}

@end

@interface NDBaseAPIRequest (){
    NDAPIRequest *_apiRequest;
}

@end

@implementation NDBaseAPIRequest

-(id)init{
    self = [super init];
    if (self) {
        self.id = (double)[[NSDate date]timeIntervalSince1970]*1000000;
        self.system = [[NDRequestSystem alloc]init];
        self.request = [[NDRequestData alloc]init];
    }
    return self;
}

-(void)setAPIRequest:(NDAPIRequest *)apiRequest{
    _apiRequest = apiRequest;
    self.method = apiRequest.method;
    self.params = apiRequest.params;
    if (apiRequest._ignoreToken) {
        self.request.token = nil;
        [self.system ignoreToken:YES];
    }
    if (apiRequest._ignoreUserid) {
        self.request.user_id = nil;
        [self.system ignoreToken:YES];
    }
}

/**
 *  服务端地址
 *
 */
-(NSString *)_serverUrl{
    return _apiRequest._serverUrl;
}

/**
 *  相应API路径
 *
 */
-(NSString *)_apiPath{
    return _apiRequest._apiPath;
}


/**
 *  请求方法
 *
 */
-(NSString *)_method{
    return _apiRequest._method;
}

@end

@implementation NDBaseResult

@end

@implementation NDBaseAPIResponse

@end

@interface NDBaseAPI(p)
+(AFHTTPRequestOperationManager *)client;
@end


@implementation NDBaseAPI


+(AFHTTPRequestOperationManager *)client{
    return [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:URL_SERVER_BASE]];
    static dispatch_once_t onceToken;
    static AFHTTPRequestOperationManager *_client;
    dispatch_once(&onceToken, ^{
        _client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:URL_SERVER_BASE]];
    });
    return _client;
}

+(AFHTTPRequestOperationManager *)clientByRequest:(NDAPIRequest *)request{
    if ([request._serverUrl isEqual:URL_SERVER_BASE]) {
        return [NDBaseAPI client];
    }
    return [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:request._serverUrl]];
}

+(NSString *)getFailDescriptByErrorCode:(int)errorCode{
    NSString *failDescription = @"";
    switch (errorCode) {
        case 1000:
            failDescription = NSLocalizedString(@"服务找不到", nil);
            break;
        case 1001:
            failDescription = NSLocalizedString(@"参数有误", nil);
            break;
        case 1002:
            failDescription = NSLocalizedString(@"参数不足", nil);
            break;
        case 1003:
            failDescription = NSLocalizedString(@"ip不允许登录", nil);
            break;
        case 1012:
            failDescription = NSLocalizedString(@"验证码未发送", nil);
            break;
        case 1011:
            failDescription = NSLocalizedString(@"新旧密码不能一致", nil);
            break;
        case 1021:
            failDescription = NSLocalizedString(@"旧密码错误", nil);
            break;
        case 2021:
            failDescription = NSLocalizedString(@"数据库错误", nil);
            break;
        case 2101:
            failDescription = NSLocalizedString(@"群不存在", nil);
            break;
        case 2102:
            failDescription = NSLocalizedString(@"邀请不存在", nil);
            break;
        case 2103:
            failDescription = NSLocalizedString(@"不是群所有者", nil);
            break;
        case 2104:
            failDescription = NSLocalizedString(@"用户不存在", nil);
            break;
        case 2105:
            failDescription = NSLocalizedString(@"设备不存在", nil);
            break;
        case 2106:
            failDescription = NSLocalizedString(@"数据库错误", nil);
            break;
        case 2107:
            failDescription = NSLocalizedString(@"申请已存在", nil);
            break;
        case 2108:
            failDescription = NSLocalizedString(@"申请不存在", nil);
            break;
        case 2109:
            failDescription = NSLocalizedString(@"对方已加入其它家庭圈", nil);
            break;
        case 2110:
            failDescription = NSLocalizedString(@"找不到邮件", nil);
            break;
        case 2111:
        {
            if ([ShareValue sharedShareValue].cur_toyState == ToyStateDormancyState) {
               failDescription = NSLocalizedString(@"设备离线,请手动唤醒", nil);
            }else{
                failDescription = NSLocalizedString(@"设备休眠,请手动唤醒", nil);
            }
        }
            break;
        case 2112:
            failDescription = NSLocalizedString(@"没有更新", nil);
            break;
        case 2113:
            failDescription = NSLocalizedString(@"联系人失效", nil);
            break;
        case 2115:
            failDescription = NSLocalizedString(@"设备正忙", nil);
            break;
        case 2116:
            failDescription = NSLocalizedString(@"主题不存在，请下载", nil);
            break;
        case 2117:
            failDescription = NSLocalizedString(@"当前专辑ID不正确", nil);
            break;
        case 2118:
            failDescription = NSLocalizedString(@"ExistingPownloadsPleaseWait", nil);
            break;
        case 2119:
            failDescription = NSLocalizedString(@"找不到群", nil);
            break;
        case 2120:
            failDescription = NSLocalizedString(@"媒体被使用，不能删除", nil);
            break;
        case 2121:
            failDescription = NSLocalizedString(@"小伙伴达最大值，无法增加小伙伴", nil);
            break;
        case 2122:
            failDescription = NSLocalizedString(@"和其他订阅的电台时间冲突", nil);
            break;
        case 2123:
            failDescription = NSLocalizedString(@"电台不存在", nil);
            break;
        case 2124:
            failDescription = NSLocalizedString(@"玩具在该时段订阅了其它电台", nil);
            break;
        case 2125:
            failDescription = NSLocalizedString(@"电台内容日期有误", nil);
            break;
        case 2126:
            failDescription = NSLocalizedString(@"媒体正在下载，请稍候", nil);
            break;
        case 2127:
            failDescription = NSLocalizedString(@"磁盘已满，无法下载媒体", nil);
            break;
        case 2128:
            failDescription = NSLocalizedString(@"专辑还未下载完成，请稍候", nil);
            break;
        case 3000:
            failDescription = NSLocalizedString(@"mysql方问错误", nil);
            break;
        case 3001:
            failDescription = NSLocalizedString(@"参数错误", nil);
            break;
        case 3002:
            failDescription = NSLocalizedString(@"用户权限错误", nil);
            break;
        case 3003:
            failDescription = NSLocalizedString(@"脚本数量太多", nil);
            break;
        case 3004:
            failDescription = NSLocalizedString(@"定时器数量太多", nil);
            break;
        case 3005:
            failDescription = NSLocalizedString(@"媒体被使用，无法删除", nil);
            break;
        case 3006:
            failDescription = NSLocalizedString(@"设备数量太多", nil);
            break;
        case 3007:
            failDescription = NSLocalizedString(@"用户数量太多", nil);
            break;
        case 3008:
            failDescription = NSLocalizedString(@"房间不存在", nil);
            break;
        case 3009:
            failDescription = NSLocalizedString(@"定时器参数有误", nil);
            break;
        case 3010:
            failDescription = NSLocalizedString(@"定时器不存在", nil);
            break;
        case 3011:
            failDescription = NSLocalizedString(@"脚本不存在", nil);
            break;
        case 3012:
            failDescription = NSLocalizedString(@"家的个数太多", nil);
            break;
        case 3013:
            failDescription = NSLocalizedString(@"不是家的拥有者", nil);
            break;
        case 3014:
            failDescription = NSLocalizedString(@"家不存在", nil);
            break;
        case 3015:
            failDescription = NSLocalizedString(@"授权角色不对", nil);
            break;
        case 3016:
            failDescription = NSLocalizedString(@"权限不足", nil);
            break;
        case 5000:
            failDescription = NSLocalizedString(@"短信发送失败", nil);
            break;
        case 5001:
            failDescription = NSLocalizedString(@"短信已发送，请勿重复请求", nil);
            break;
        case 5002:
            failDescription = NSLocalizedString(@"手机号码不正确", nil);
            break;
        case 5003:
            failDescription = NSLocalizedString(@"授权失败", nil);
            break;
        case 5004:
            failDescription = NSLocalizedString(@"用户名格式错误", nil);
            break;
        case 5005:
            failDescription = NSLocalizedString(@"密码错误", nil);
            break;
        case 5006:
            failDescription = NSLocalizedString(@"用户名不存在", nil);
            break;
        case 5007:
            failDescription = NSLocalizedString(@"用户未登录", nil);
            break;
        case 5008:
            failDescription = NSLocalizedString(@"请求错误", nil);
            break;
        case 5009:
        case 5019:
            failDescription = NSLocalizedString(@"服务器异常", nil);
            break;
        case 5010:
            failDescription = NSLocalizedString(@"未绑定手机", nil);
            break;
        case 5011:
            failDescription = NSLocalizedString(@"密码格式错误", nil);
            break;
        case 5012:
            failDescription = NSLocalizedString(@"账号错误", nil);
            break;
        case 5013:
            failDescription = NSLocalizedString(@"重置的密码相同", nil);
            break;
        case 5014:
            failDescription = NSLocalizedString(@"手机号码已被绑定", nil);
            break;
        case 5015:
            failDescription = NSLocalizedString(@"验证码已失效", nil);
            break;
        case 5016:
            failDescription = NSLocalizedString(@"验证码错误,请重新输入", nil);
            break;
        case 5017:
            failDescription = NSLocalizedString(@"用户已经登录", nil);
            break;
        case 5018:
            failDescription = NSLocalizedString(@"用户名格式错误", nil);
            break;
        case 5020:
            failDescription = NSLocalizedString(@"用户名已经存在", nil);
            break;
        case 5021:
            failDescription = NSLocalizedString(@"设备不存在", nil);
            break;
        case 5022:
            failDescription = NSLocalizedString(@"第三方接口未开放", nil);
            break;
        case 5023:
            failDescription = NSLocalizedString(@"第三方登录失败", nil);
            break;
        case 5024:
            failDescription = NSLocalizedString(@"用户Id不存在", nil);
            break;
        case 5025:
            failDescription = NSLocalizedString(@"后端服务有误", nil);
            break;
        case 5026:
            failDescription = NSLocalizedString(@"设备不在线", nil);
            break;
        case 5200:
            failDescription = NSLocalizedString(@"更新用户信息失败", nil);
            break;
        case 5201:
            failDescription = NSLocalizedString(@"获取用户信息失败", nil);
            break;
        case 5202:
            failDescription = NSLocalizedString(@"商户不存在", nil);
            break;
        case 5203:
            failDescription = NSLocalizedString(@"登录超时", nil);
            break;
        case 5204:
            failDescription = NSLocalizedString(@"商户未登录", nil);
            break;
        case 5205:
            failDescription = NSLocalizedString(@"注册失败", nil);
            break;
        case 5206:
            failDescription = NSLocalizedString(@"商户名字不规范", nil);
            break;
        case 5207:
            failDescription = NSLocalizedString(@"商户密码错误", nil);
            break;
        case 5208:
            failDescription = NSLocalizedString(@"文件上传有误", nil);
            break;
        case 5209:
            failDescription = NSLocalizedString(@"商户信息有误", nil);
            break;
        case 5210:
            failDescription = NSLocalizedString(@"商户名有误", nil);
            break;
        case 5211:
            failDescription = NSLocalizedString(@"商户品牌有误", nil);
            break;
        case 5212:
            failDescription = NSLocalizedString(@"商户已经存在", nil);
            break;
        case 5213:
            failDescription = NSLocalizedString(@"用户不属于商户", nil);
            break;
        case 6000:
            failDescription = NSLocalizedString(@"控制超时", nil);
            break;
        case 6001:
            failDescription = NSLocalizedString(@"设备不在线", nil);
            break;
        case 6002:
            failDescription = NSLocalizedString(@"token过期", nil);
            break;
        case 6003:
            failDescription = NSLocalizedString(@"服务器处理错误", nil);
            break;
        case 6004:
            failDescription = NSLocalizedString(@"auth校验不通过", nil);
            break;
        case 6005:
            failDescription = NSLocalizedString(@"数据签名不对", nil);
            break;
        case 6006:
            failDescription = NSLocalizedString(@"时间不对，请同步服务器时间", nil);
            break;
        case 6007:
            failDescription = NSLocalizedString(@"管家密码不对", nil);
            break;
        case 6008:
            failDescription = NSLocalizedString(@"管家不属于你的", nil);
            break;
        case 7001:
            failDescription = NSLocalizedString(@"用户积分不足", nil);
            break;
        default:
            break;
    }
    return failDescription;
}

+(void)filterParams:(NSMutableDictionary *)dict{

}

/**
 *  向服务器发起请求
 *
 *  @param request 请求对象
 *  @param sucess 成功返回的Block
 *  @param fail 失败返回的Block
 *
 */
+(void)request:(NDAPIRequest *)request resultClass:(Class)resultClass completionBlockWithSuccess:(void(^)(NSObject *result,NSString *message))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    AFHTTPRequestOperationManager *client = [NDBaseAPI clientByRequest:request];
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    client.requestSerializer = [AFJSONRequestSerializer serializer];
//    [client.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [client.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NDBaseAPIRequest *apiRequest = [[NDBaseAPIRequest alloc]init];
    [apiRequest setAPIRequest:request];
    NSMutableDictionary *dict = (NSMutableDictionary *)apiRequest.lkDictionary;
    NSLog(@"request:%@",dict);
    NSURLRequest *urlRequest = [client.requestSerializer requestWithMethod:request._method URLString:[NSString stringWithFormat:@"%@%@",client.baseURL,request._apiPath] parameters:dict error:nil];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:urlRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSLog(@"url:%@|response:%@",urlRequest.URL,responseObject);
            
            NDBaseAPIResponse *response = [responseObject objectByClass:[NDBaseAPIResponse class]];
            if (!response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    fail(-1,NSLocalizedString(@"ServerException", nil));
                });
                return ;
            }
            
            if (response.result.code != SUCCESS_CODE) {
                NSString *errorMessage = [self getFailDescriptByErrorCode:response.result.code ];
                NSString *message = response.result.message;
                if (errorMessage.length==0 && message.length > 0) {
                    errorMessage = message;
                }
                if (response.result.code == 2122) {
                    if (message.length > 0) {
                        errorMessage = message;
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (response.result.code == 2101) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_QUIT object:nil userInfo:nil];
                    }
                    if (response.result.code == 5003) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFCATION_LOGOUT object:nil userInfo:nil];
                        
                    }
                    if (response.result.code == 6002) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_DISCONNECT object:nil userInfo:nil];
                        return;
                        
                    }
                    
                    fail(response.result.code,errorMessage);
                });
                
                return;
            }
            
            if([response.result.data isKindOfClass:[NSArray class]]){
                NSMutableArray *results = [NSMutableArray array];
                for (NSDictionary *dic in (NSArray *)response.result.data) {
                    NSObject *obj = [dic objectByClass:resultClass];
                    [results addObject:obj];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    sucess(results,response.result.message);
                });
                
            }else if([response.result.data isKindOfClass:[NSDictionary class]]){
                NSDictionary *dic = (NSDictionary *)response.result.data;
                NSObject *obj = [dic objectByClass:resultClass];
                dispatch_async(dispatch_get_main_queue(), ^{
                    sucess(obj,response.result.message);
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                fail(-1,NSLocalizedString(@"ServerException", nil));
            });
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"url:%@,fail:%@",urlRequest.URL,[error localizedDescription]);
        dispatch_async(dispatch_get_main_queue(), ^{
            fail(-1,NSLocalizedString(@"NetworkNotForcePleaseConnectInternet", nil));
        });
    }];
    
    [operation start];
}

/**
 *  上传图片文件到文件服务器中..
 *
 *  @param request 请求对象
 *  @param sucess 成功返回的Block
 *  @param fail 失败返回的Block
 *
 */

+(void)uploadImageFile:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType ProgressBlock:(void(^)(NSInteger bytesWritten, long long totalBytesWritten,long long totalBytesExpectedToWrite))progressblock successBlock:(void(^)(NSString *filepath))success errorBlock:(void(^)(BOOL NotReachable))errorBlock{
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:ND_IMAGE_FILE_SERVERURL]];
    [client.requestSerializer setValue:@"333" forHTTPHeaderField:@"openid"];
    [client.requestSerializer setValue:@"33" forHTTPHeaderField:@"key"];
    [client.requestSerializer setValue:@"3" forHTTPHeaderField:@"secret"];
    NSString *path = [NSString stringWithFormat:@"%@%@",ND_IMAGE_FILE_SERVERURL,@"/v1/fs/file"];
    NSMutableURLRequest *request = [client.requestSerializer multipartFormRequestWithMethod:@"post" URLString:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
    } error:nil];
    request.timeoutInterval = 50;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        progressblock(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    }];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject){
            NSData *responseData = (NSData *)responseObject;
            NSError *error = nil;
            //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
            if (dict) {
                NSDictionary *dict1 = [dict objectForKey:@"result"];
                if (dict1) {
                    NSDictionary *dict2 = [dict1 objectForKey:@"data"];
                    if (dict2) {
                        NSString *file = [dict2 objectForKey:@"file"];
                        success([NSString stringWithFormat:@"%@%@",ND_IMAGE_FILE_SERVERURL,file]);
                        return ;
                    }
                }
            }
            
            errorBlock(client.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
        }else{
            errorBlock(client.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(client.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
    }];
    
}


/**
 *  上传图片文件到文件服务器中..
 *
 *  @param request 请求对象
 *  @param sucess 成功返回的Block
 *  @param fail 失败返回的Block
 *
 */

+(void)uploadImageFiles:(NSArray *)images successBlock:(void(^)(NSArray *filepaths))success errorBlock:(void(^)(BOOL NotReachable))errorBlock{
    
     NSMutableArray *t_mArr = [NSMutableArray new];
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:ND_IMAGE_FILE_SERVERURL]];
    client.responseSerializer.acceptableContentTypes = nil;
    NSString *path = [NSString stringWithFormat:@"%@%@",ND_IMAGE_FILE_SERVERURL,@"/v1/fs/upload"];
    [client POST:path parameters:@{@"appid":@"moment",@"user_id":[[ShareValue sharedShareValue].user.user_id stringValue],@"token":[NDAPIShareValue standardShareValue].token} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (images.count>0) {
            for (UIImage *image in images) {
                ImageFileInfo *fileInfo = [[ImageFileInfo alloc]initWithImage:image];
                [formData appendPartWithFileData:fileInfo.fileData name:fileInfo.name fileName:fileInfo.fileName mimeType:fileInfo.mimeType];
                [t_mArr addObject:fileInfo];
                
            }
        }
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if(responseObject){
            //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
            NSDictionary *dict = responseObject;
            if (dict) {
                NSDictionary *dict1 = [dict objectForKey:@"result"];
                if (dict1) {
                    NSArray *array = [dict1 objectForKey:@"data"];
                    if (array) {
                        NSMutableArray *result = [NSMutableArray array];
                        for (NSDictionary *fileDict in array) {
                            NSString *filepath = [fileDict objectForKey:@"path"];
                            NSString *name  = [fileDict objectForKey:@"name"];
                            if ([t_mArr count] > 0 ) {
                                
                                for (ImageFileInfo *imageFileInfo in t_mArr) {
                                    if ([imageFileInfo.fileName isEqualToString:name]) {
                                        filepath =  [filepath stringByAppendingString:[NSString stringWithFormat:@"?imageWidth=%.1f&&imageHeight=%.1f",imageFileInfo.image.size.width,imageFileInfo.image.size.height]];
                                        break;
                                    }
                                    
                                }
                            }
                           
                           
                            [result addObject:[NSString stringWithFormat:@"%@%@",ND_IMAGE_FILE_SERVERURL,filepath]];
                        }
                        success(result);
                        return ;
                    }
                }
            }
            errorBlock(client.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
        }else{
            errorBlock(client.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
        }

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorBlock(client.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
    }];
    
}



/**
 *  上传语音文件到图片文件服务器中..
 *
 *  @param request 请求对象
 *  @param sucess 成功返回的Block
 *  @param fail 失败返回的Block
 *
 */

+(void)uploadGreetingFile:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType ProgressBlock:(void(^)(NSInteger bytesWritten, long long totalBytesWritten,long long totalBytesExpectedToWrite))progressblock successBlock:(void(^)(NSString *filepath))success errorBlock:(void(^)(BOOL NotReachable))errorBlock{
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:ND_IMAGE_FILE_SERVERURL]];
    [client.requestSerializer setValue:@"333" forHTTPHeaderField:@"openid"];
    [client.requestSerializer setValue:@"33" forHTTPHeaderField:@"key"];
    [client.requestSerializer setValue:@"3" forHTTPHeaderField:@"secret"];
    
    NSString *path = [NSString stringWithFormat:@"%@%@",ND_IMAGE_FILE_SERVERURL,@"/v1/fs/file"];
    NSMutableURLRequest *request = [client.requestSerializer multipartFormRequestWithMethod:@"post" URLString:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
    } error:nil];
    request.timeoutInterval = 50;
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        progressblock(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    }];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject){
            NSData *responseData = (NSData *)responseObject;
            
            NSError *error = nil;
            //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
            if (dict) {
                NSDictionary *dict1 = [dict objectForKey:@"result"];
                if (dict1) {
                    NSDictionary *dict2 = [dict1 objectForKey:@"data"];
                    if (dict2) {
                        NSString *file = [dict2 objectForKey:@"file"];
                        success([NSString stringWithFormat:@"%@%@",ND_IMAGE_FILE_SERVERURL,file]);
                        return ;
                    }
                }
            }
            
            errorBlock(client.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
        }else{
            errorBlock(client.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(client.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
    }];

}

/**
 *  上传语音文件到文件服务器中..
 *
 *  @param request 请求对象
 *  @param sucess 成功返回的Block
 *  @param fail 失败返回的Block
 *
 */

+(void)uploadFile:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType ProgressBlock:(void(^)(NSInteger bytesWritten, long long totalBytesWritten,long long totalBytesExpectedToWrite))progressblock successBlock:(void(^)(NSString *filepath))success errorBlock:(void(^)(BOOL NotReachable))errorBlock{
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:ND_FILE_SERVERURL]];
    NSString *path = [NSString stringWithFormat:@"%@%@",ND_FILE_SERVERURL,@"/kvx/79dbf1ad280a4589e75e209fccaf167c/audio/key/2"];

    NSMutableURLRequest *request = [client.requestSerializer multipartFormRequestWithMethod:@"post" URLString:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
    } error:nil];
    request.timeoutInterval = 50;

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        progressblock(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    }];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject){
            NSData *responseData = (NSData *)responseObject;
            NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
            responseString = [responseString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            if (responseString) {
                success([NSString stringWithFormat:@"%@%@%@",ND_FILE_SERVERURL,@"/kvx/79dbf1ad280a4589e75e209fccaf167c/audio/",responseString]);
                return ;
            }
            errorBlock(client.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
        }else{
            errorBlock(client.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(client.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
    }];
}

+(void)downloadFile:(NSURL *)url fileid:(NSString *)fileId downloadProgress:(void(^)(float progress))downloadProgress successBlock:(void(^)(NSURL *filepath))success errorBlock:(void(^)(NSString *))errorBlock;
{
    NSString *saveDirectory =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savePath = [saveDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[url lastPathComponent]]];

    NSURL *fileUrl = [NSURL fileURLWithPath:savePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath]){
        success(fileUrl);
        return;
    }
    
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *downloadPath = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[url lastPathComponent]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //检查文件是否已经下载了一部分
    unsigned long long downloadedBytes = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadPath]) {
        NSFileManager * filemanager = [NSFileManager defaultManager];
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:downloadPath error:nil];
        // file size
        NSNumber *theFileSize;
        theFileSize = [attributes objectForKey:NSFileSize];
        downloadedBytes= [theFileSize intValue];
        if (downloadedBytes > 0) {
            NSMutableURLRequest *mutableURLRequest = [request mutableCopy];
            NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", downloadedBytes];
            [mutableURLRequest setValue:requestRange forHTTPHeaderField:@"Range"];
            request = mutableURLRequest;
        }
    }
    //下载请求
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //下载路径
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:downloadPath append:YES];
    //下载进度回调
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //下载进度
        float progress = ((float)totalBytesRead + downloadedBytes) / (totalBytesExpectedToRead + downloadedBytes);
        downloadProgress(progress);
    }];
    //成功和失败回调
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        BOOL flag =  [[NSFileManager defaultManager]copyItemAtPath:downloadPath toPath:savePath error:(&error)];
        if (!flag) {
            errorBlock(NSLocalizedString(@"RspMsgError",nil));
        }else{
            success(fileUrl);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(NSLocalizedString(@"NetworkNotGood", nil));
    }];
    [operation start];
}




@end
