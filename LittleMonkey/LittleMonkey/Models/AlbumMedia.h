//
//  AlbumMedia.h
//  HelloToy
//
//  Created by nd on 15/4/29.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumMedia : NSObject

@property(nonatomic,strong) NSNumber *media_id;     //媒体ID
@property(nonatomic,strong) NSString *name;         //媒体名字
@property(nonatomic,strong) NSString *icon;         //媒体头像
@property(nonatomic,strong) NSString *url;          //媒体URL
@property(nonatomic,strong) NSNumber *media_type;   //媒体类型
@property(nonatomic,strong) NSNumber *duration;     //媒体时长
@property(nonatomic,strong) NSNumber *download;     //忽略
@property(nonatomic,strong) NSNumber *album_type;   //专辑类型;


@property(nonatomic,strong) NSNumber *status;       //下载状态 0：未下载  1:已下载  2:下载中..

-(void)save;

@end
