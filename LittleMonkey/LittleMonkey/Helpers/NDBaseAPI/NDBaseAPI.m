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
            failDescription = NSLocalizedString(@"ServiceNotFind", nil);
            break;
        case 1001:
            failDescription = NSLocalizedString(@"ParameterWrong", nil);
            break;
        case 1002:
            failDescription = NSLocalizedString(@"InsufficientParameters", nil);
            break;
        case 1003:
            failDescription = NSLocalizedString(@"IPNotAllowedToLogin", nil);
            break;
        case 1012:
            failDescription = NSLocalizedString(@"VerificationCodeNotSend", nil);
            break;
        case 1011:
            failDescription = NSLocalizedString(@"PasswordNotMatch", nil);
            break;
        case 1021:
            failDescription = NSLocalizedString(@"OldPasswordWrong", nil);
            break;
        case 2021:
            failDescription = NSLocalizedString(@"DatabaseError", nil);
            break;
        case 2101:
            failDescription = NSLocalizedString(@"GroupNotExist", nil);
            break;
        case 2102:
            failDescription = NSLocalizedString(@"InviteNotExist", nil);
            break;
        case 2103:
            failDescription = NSLocalizedString(@"NotGroupOwners", nil);
            break;
        case 2104:
            failDescription = NSLocalizedString(@"UserNotExist", nil);
            break;
        case 2105:
            failDescription = NSLocalizedString(@"EquipmentNotExist", nil);
            break;
        case 2106:
            failDescription = NSLocalizedString(@"DatabaseError", nil);
            break;
        case 2107:
            failDescription = NSLocalizedString(@"ApplyExist", nil);
            break;
        case 2108:
            failDescription = NSLocalizedString(@"ApplyNotExist", nil);
            break;
        case 2109:
            failDescription = NSLocalizedString(@"JoinedOtherFamilyCircle", nil);
            break;
        case 2110:
            failDescription = NSLocalizedString(@"NotFindEmail", nil);
            break;
        case 2111:
        {
            if ([ShareValue sharedShareValue].cur_toyState == ToyStateDormancyState) {
               failDescription = NSLocalizedString(@"EquipmentOffline1", nil);
            }else{
                failDescription = NSLocalizedString(@"EquipmentOffline", nil);
            }
        }
            break;
        case 2112:
            failDescription = NSLocalizedString(@"NoUpdate", nil);
            break;
        case 2113:
            failDescription = NSLocalizedString(@"ContactFailure", nil);
            break;
        case 2115:
            failDescription = NSLocalizedString(@"EquipmentBusying", nil);
            break;
        case 2116:
            failDescription = NSLocalizedString(@"TopicNotExist", nil);
            break;
        case 2117:
            failDescription = NSLocalizedString(@"CurrentAlbumIDError", nil);
            break;
        case 2118:
            failDescription = NSLocalizedString(@"ExistingPownloadsPleaseWait", nil);
            break;
        case 2119:
            failDescription = NSLocalizedString(@"NotFindGroup", nil);
            break;
        case 2120:
            failDescription = NSLocalizedString(@"MediaUsedNotDelete", nil);
            break;
        case 2121:
            failDescription = NSLocalizedString(@"FriendsHaveReachedMax", nil);
            break;
        case 2122:
            failDescription = NSLocalizedString(@"SubscribedRadioTimeConflict", nil);
            break;
        case 2123:
            failDescription = NSLocalizedString(@"RadioNotExist", nil);
            break;
        case 2124:
            failDescription = NSLocalizedString(@"ToysInTheTimesSubscribedAnotherStation", nil);
            break;
        case 2125:
            failDescription = NSLocalizedString(@"RadioContentDateError", nil);
            break;
        case 2126:
            failDescription = NSLocalizedString(@"MediaDownloadingPleaseWait", nil);
            break;
        case 2127:
            failDescription = NSLocalizedString(@"DiskFulledNotDownload", nil);
            break;
        case 2128:
            failDescription = NSLocalizedString(@"AlbumNotDownloadFinishPleaseWait", nil);
            break;
        case 3000:
            failDescription = NSLocalizedString(@"MySqlDirectionError", nil);
            break;
        case 3001:
            failDescription = NSLocalizedString(@"ParameterError", nil);
            break;
        case 3002:
            failDescription = NSLocalizedString(@"UserPermissionError", nil);
            break;
        case 3003:
            failDescription = NSLocalizedString(@"ScriptCountTooMore", nil);
            break;
        case 3004:
            failDescription = NSLocalizedString(@"TimerCountTooMore", nil);
            break;
        case 3005:
            failDescription = NSLocalizedString(@"MediaUsedUnableDelete", nil);
            break;
        case 3006:
            failDescription = NSLocalizedString(@"EquipmentCountTooMore", nil);
            break;
        case 3007:
            failDescription = NSLocalizedString(@"UserNumTooMore", nil);
            break;
        case 3008:
            failDescription = NSLocalizedString(@"RoomNotExist", nil);
            break;
        case 3009:
            failDescription = NSLocalizedString(@"TimerParameterError", nil);
            break;
        case 3010:
            failDescription = NSLocalizedString(@"TimerNotExist", nil);
            break;
        case 3011:
            failDescription = NSLocalizedString(@"ScriptNotExist", nil);
            break;
        case 3012:
            failDescription = NSLocalizedString(@"HomeNumberTooMore", nil);
            break;
        case 3013:
            failDescription = NSLocalizedString(@"NotHomeOwner", nil);
            break;
        case 3014:
            failDescription = NSLocalizedString(@"HomeNotExist", nil);
            break;
        case 3015:
            failDescription = NSLocalizedString(@"AuthorizationRoleError", nil);
            break;
        case 3016:
            failDescription = NSLocalizedString(@"PermissionInadequate", nil);
            break;
        case 5000:
            failDescription = NSLocalizedString(@"SMSSendFailure", nil);
            break;
        case 5001:
            failDescription = NSLocalizedString(@"SMSSendedNotRequestAgain", nil);
            break;
        case 5002:
            failDescription = NSLocalizedString(@"PhoneNumWrong", nil);
            break;
        case 5003:
            failDescription = NSLocalizedString(@"AuthorizationFailure", nil);
            break;
        case 5004:
            failDescription = NSLocalizedString(@"UserNameFormatError", nil);
            break;
        case 5005:
            failDescription = NSLocalizedString(@"PasswordError", nil);
            break;
        case 5006:
            failDescription = NSLocalizedString(@"UserNameNotExist", nil);
            break;
        case 5007:
            failDescription = NSLocalizedString(@"UserNotLogin", nil);
            break;
        case 5008:
            failDescription = NSLocalizedString(@"RequestError", nil);
            break;
        case 5009:
        case 5019:
            failDescription = NSLocalizedString(@"ServerException", nil);
            break;
        case 5010:
            failDescription = NSLocalizedString(@"UnbindPhone", nil);
            break;
        case 5011:
            failDescription = NSLocalizedString(@"PasswordFormatError", nil);
            break;
        case 5012:
            failDescription = NSLocalizedString(@"AccountError", nil);
            break;
        case 5013:
            failDescription = NSLocalizedString(@"ResetPasswordHasSame", nil);
            break;
        case 5014:
            failDescription = NSLocalizedString(@"PhoneNumBound", nil);
            break;
        case 5015:
            failDescription = NSLocalizedString(@"VerificationCodeFailure", nil);
            break;
        case 5016:
            failDescription = NSLocalizedString(@"VerificationCodeError", nil);
            break;
        case 5017:
            failDescription = NSLocalizedString(@"UserLogined", nil);
            break;
        case 5018:
            failDescription = NSLocalizedString(@"UserFormatError", nil);
            break;
        case 5020:
            failDescription = NSLocalizedString(@"UserNameExist", nil);
            break;
        case 5021:
            failDescription = NSLocalizedString(@"EquipmentNotExist", nil);
            break;
        case 5022:
            failDescription = NSLocalizedString(@"ThirdAPINotOpen", nil);
            break;
        case 5023:
            failDescription = NSLocalizedString(@"ThirdLoginFail", nil);
            break;
        case 5024:
            failDescription = NSLocalizedString(@"UserIdNotExist", nil);
            break;
        case 5025:
            failDescription = NSLocalizedString(@"ServerError", nil);
            break;
        case 5026:
            failDescription = NSLocalizedString(@"EquipmentNotOnline", nil);
            break;
        case 5200:
            failDescription = NSLocalizedString(@"UpdateUserInfoFail", nil);
            break;
        case 5201:
            failDescription = NSLocalizedString(@"GetUserInfoFail", nil);
            break;
        case 5202:
            failDescription = NSLocalizedString(@"CommercialTenantsNotExist", nil);
            break;
        case 5203:
            failDescription = NSLocalizedString(@"LoginOuttime", nil);
            break;
        case 5204:
            failDescription = NSLocalizedString(@"CommercialTenantsNotLogin", nil);
            break;
        case 5205:
            failDescription = NSLocalizedString(@"RegistFail", nil);
            break;
        case 5206:
            failDescription = NSLocalizedString(@"CommercialTenantsNameNotStandard", nil);
            break;
        case 5207:
            failDescription = NSLocalizedString(@"CommercialTenantsPasswordError", nil);
            break;
        case 5208:
            failDescription = NSLocalizedString(@"FileUploadError", nil);
            break;
        case 5209:
            failDescription = NSLocalizedString(@"CommercialTenantsInfoError", nil);
            break;
        case 5210:
            failDescription = NSLocalizedString(@"CommercialTenantsNameError", nil);
            break;
        case 5211:
            failDescription = NSLocalizedString(@"CommercialTenantsBrandError", nil);
            break;
        case 5212:
            failDescription = NSLocalizedString(@"CommercialTenantsExist", nil);
            break;
        case 5213:
            failDescription = NSLocalizedString(@"UserNotBelongToCommercialTenants", nil);
            break;
        case 6000:
            failDescription = NSLocalizedString(@"ControlTimeout", nil);
            break;
        case 6001:
            failDescription = NSLocalizedString(@"EquipmentNotOnline", nil);
            break;
        case 6002:
            failDescription = NSLocalizedString(@"TokenOutDate", nil);
            break;
        case 6003:
            failDescription = NSLocalizedString(@"ServerHandleError", nil);
            break;
        case 6004:
            failDescription = NSLocalizedString(@"AuthCheckNotPass", nil);
            break;
        case 6005:
            failDescription = NSLocalizedString(@"DataSignatureError", nil);
            break;
        case 6006:
            failDescription = NSLocalizedString(@"TimeError", nil);
            break;
        case 6007:
            failDescription = NSLocalizedString(@"HousekeeperPasswordError", nil);
            break;
        case 6008:
            failDescription = NSLocalizedString(@"HousekeeperNotBelongToYour", nil);
            break;
        case 7001:
            failDescription = NSLocalizedString(@"UserPointInsufficient", nil);
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
