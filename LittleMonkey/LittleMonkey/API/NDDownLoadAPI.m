//
//  NDDownLoadAPI.m
//  HelloToy
//
//  Created by nd on 15/7/10.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "NDDownLoadAPI.h"

@interface NDDownloadAddRequest : NDAPIRequest

@property(nonatomic,strong) NDDownloadAddParams *params;

@end

@implementation NDDownloadAddRequest

-(NSString *)method{
    return URL_DOWNLOAD_ADD;
}

@end

@interface NDDownloadQueryRequest : NDAPIRequest

@property(nonatomic,strong) NDDownloadQueryParams *params;

@end

@implementation NDDownloadQueryRequest

-(NSString *)method{
    return URL_DOWNLOAD_QUERY;
}
@end



@implementation NDDownloadQueryParams

@end



@implementation NDDownloadAddParams

@end



@implementation NDDownLoadAPI


/**
 *  查询下载
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)downloadQueryWithParams:(NDDownloadQueryParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDDownloadQueryRequest *request = [[NDDownloadQueryRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[Download class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        
        NSArray *data = (NSArray *)result;
        sucess(data);
        
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];


}

/**
 *  增加下载
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)downloadAddWithParams:(NDDownloadAddParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    NDDownloadAddRequest *request = [[NDDownloadAddRequest alloc] init];
    request.params = params;
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

@end
