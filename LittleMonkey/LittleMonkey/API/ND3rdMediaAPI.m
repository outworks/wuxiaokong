//
//  ND3rdMediaAPI.m
//  HelloToy
//
//  Created by huanglurong on 16/4/20.
//  Copyright © 2016年 NetDragon. All rights reserved.
//



#import "ND3rdMediaAPI.h"

@interface ND3rdMediaDownloadMediaRequest : NDAPIRequest

@property(nonatomic,strong) ND3rdMediaDownloadMediaParams *params;

@end

@implementation ND3rdMediaDownloadMediaRequest

-(NSString *)method{
    return URL_3RDMEDIA_DOWNLOADMEDIA;
}

@end

@interface ND3rdMediaDownloadAlbumRequest : NDAPIRequest

@property(nonatomic,strong) ND3rdMediaDownloadAlbumParams *params;

@end

@implementation ND3rdMediaDownloadAlbumRequest

-(NSString *)method{
    return URL_3RDMEDIA_DOWNLOADALBUM;
}

@end


@interface ND3rdMediaQeueryMediaRequest : NDAPIRequest

@property(nonatomic,strong) ND3rdMediaQeueryMediaParams *params;

@end

@implementation ND3rdMediaQeueryMediaRequest

-(NSString *)method{
    return URL_3RDMEDIA_QEUERYMEDIA;
}

@end


@interface ND3rdMediaChangeAlbumRequest : NDAPIRequest

@property(nonatomic,strong) ND3rdMediaChangeAlbumParams *params;

@end

@implementation ND3rdMediaChangeAlbumRequest

-(NSString *)method{
    return URL_3RDMEDIA_CHANGEALBUM;
}

@end


@interface ND3rdMediaPlayMediaRequest : NDAPIRequest

@property(nonatomic,strong) ND3rdMediaPlayMediaParams *params;

@end

@implementation ND3rdMediaPlayMediaRequest

-(NSString *)method{
    return URL_3RDMEDIA_PLAYMEDIA;
}

@end

@interface ND3rdMediaAlbumMediaRequest : NDAPIRequest

@property(nonatomic,strong) ND3rdMediaAlbumMediaParams *params;

@end

@implementation ND3rdMediaAlbumMediaRequest

-(NSString *)method{
    return URL_3RDMEDIA_ALBUMMEDIA;
}

@end

@interface ND3rdMediaAlbumDetialRequest : NDAPIRequest

@property(nonatomic,strong) ND3rdMediaAlbumDetialParams *params;

@end

@implementation ND3rdMediaAlbumDetialRequest

-(NSString *)method{
    return URL_3RDMEDIA_ALBUMINFO;
}

@end



@implementation ND3rdMediaDownloadMediaParams
@end

@implementation ND3rdMediaDownloadAlbumParams
@end

@implementation ND3rdMediaQeueryMediaParams
@end

@implementation ND3rdMediaChangeAlbumParams
@end

@implementation ND3rdMediaPlayMediaParams
@end

@implementation ND3rdMediaAlbumMediaParams
@end

@implementation ND3rdMediaAlbumDetialParams
@end

@implementation ND3rdQeueryMediaResult

+(Class)__dataClass{
    return [MediaDownloadStatus class];
}

@end

@implementation ND3rdAlbumMediaResult

+(Class)__dataClass{
    return [ND3RDAlbumMedia class];
}

@end


@implementation ND3rdMediaAPI


/**
 *  下载媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)thirdMediaDownloadMediaWithParams:(ND3rdMediaDownloadMediaParams *)params completionBlockWithSuccess:(void(^)(MediaDownloadStatus *mediaDownloadStatus))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    ND3rdMediaDownloadMediaRequest *request = [[ND3rdMediaDownloadMediaRequest alloc] init];
    request.params = params;
    
    [self request:request resultClass:[MediaDownloadStatus class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        MediaDownloadStatus *data = (MediaDownloadStatus *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  下载专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)thirdMediaDownloadAlbumWithParams:(ND3rdMediaDownloadAlbumParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    ND3rdMediaDownloadAlbumRequest *request = [[ND3rdMediaDownloadAlbumRequest alloc] init];
    request.params = params;
    
    [self request:request resultClass:[MediaDownloadStatus class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  查询媒体的下载状态
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)thirdMediaQeueryMediaWithParams:(ND3rdMediaQeueryMediaParams *)params completionBlockWithSuccess:(void(^)(NSArray *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    ND3rdMediaQeueryMediaRequest *request = [[ND3rdMediaQeueryMediaRequest alloc] init];
    request.params = params;
    
    [self request:request resultClass:[MediaDownloadStatus class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

/**
 *  切换专辑
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)thirdMediaChangeAlbumWithParams:(ND3rdMediaChangeAlbumParams *)params completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    ND3rdMediaChangeAlbumRequest *request = [[ND3rdMediaChangeAlbumRequest alloc] init];
    request.params = params;
    
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  查询专辑媒体
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)thirdMediaAlbumMediaWithParams:(ND3rdMediaAlbumMediaParams *)params completionBlockWithSuccess:(void(^)(NSArray*data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    ND3rdMediaAlbumMediaRequest *request = [[ND3rdMediaAlbumMediaRequest alloc] init];
    request.params = params;
    
    [self request:request resultClass:[ND3RDAlbumMedia class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  查询专辑详情
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */

+(void)thirdMediaAlbumDetialWithParams:(ND3rdMediaAlbumDetialParams *)params completionBlockWithSuccess:(void(^)(ND3rdAlbumInfo *data))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{

    ND3rdMediaAlbumDetialRequest *request = [[ND3rdMediaAlbumDetialRequest alloc] init];
    request.params = params;
    
    [self request:request resultClass:[ND3rdAlbumInfo class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        ND3rdAlbumInfo *data = (ND3rdAlbumInfo *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

@end
