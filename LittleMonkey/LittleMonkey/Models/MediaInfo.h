//
//  MediaInfo.h
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaInfo : NSObject

@property(nonatomic,strong) NSNumber *media_id;     //媒体ID
@property(nonatomic,strong) NSString *name;         //媒体名字
@property(nonatomic,strong) NSString *icon;         //媒体头像
@property(nonatomic,strong) NSNumber *media_type;   //媒体类型
@property(nonatomic,strong) NSString *url;          //媒体地址
@property(nonatomic,strong) NSNumber *duration;     //媒体时长

-(void)save;

@end
