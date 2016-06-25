//
//  DownloadMediaInfo.h
//  HelloToy
//
//  Created by huanglurong on 16/4/21.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadMediaInfo : NSObject

@property(nonatomic,strong) NSNumber * media_id;//官方id
@property(nonatomic,strong) NSNumber * third_mid;//第三方id
@property(nonatomic,strong) NSNumber * download; //下载状态
@property(nonatomic,strong) NSString * name;//媒体名称
@property(nonatomic,strong) NSString * icon;//图标
@property(nonatomic,strong) NSNumber * media_type;//媒体类型
@property(nonatomic,strong) NSString * url;//地址
@property(nonatomic,strong) NSNumber * duration;//时长
@property(nonatomic,strong) NSNumber * status; //0 未下载  1:已下载  2:下载中

@end
