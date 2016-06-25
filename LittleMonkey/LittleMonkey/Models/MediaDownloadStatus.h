//
//  MediaDownloadStatus.h
//  HelloToy
//
//  Created by huanglurong on 16/4/20.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaDownloadStatus : NSObject

@property(nonatomic,strong) NSNumber *media_id; //媒体id
@property(nonatomic,strong) NSNumber *third_mid; //第三方媒体id
@property(nonatomic,strong) NSNumber *download; //0:未下载，1：下载, 2:下载中
@end
