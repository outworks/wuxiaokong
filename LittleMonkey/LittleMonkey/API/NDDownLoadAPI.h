//
//  NDDownLoadAPI.h
//  HelloToy
//
//  Created by nd on 15/7/10.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDBaseAPI.h"
#import "Download.h"

@interface NDDownloadQueryParams : NSObject

@property(nonatomic,strong)NSNumber *toy_id;

@end

@interface NDDownloadAddParams : NSObject

@property(nonatomic,strong)NSNumber *toy_id;
@property(nonatomic,strong)NSNumber *content_type;
@property(nonatomic,strong)NSString *content_name;
@property(nonatomic,strong)NSNumber *content_id;

@end



@interface NDDownLoadAPI : NDBaseAPI

/**
 *  查询下载
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)downloadQueryWithParams:(NDDownloadQueryParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  增加下载
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)downloadAddWithParams:(NDDownloadAddParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


@end
