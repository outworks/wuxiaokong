//
//  AlbumInfo.h
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumInfo : NSObject

@property(nonatomic,strong) NSNumber *album_id;     //专辑编号
@property(nonatomic,strong) NSNumber *third_id;    //第三方专辑编号
@property(nonatomic,strong) NSString *name;         //专辑名称
@property(nonatomic,strong) NSString *icon;         //专辑头像
@property(nonatomic,strong) NSNumber *number;       //歌曲数
@property(nonatomic,strong) NSNumber *album_type;   //专辑类型
@property(nonatomic,strong) NSNumber *source;       //权限类型
@property(nonatomic,strong) NSString *desc;//推荐理由
@property(nonatomic,strong) NSString *info;//推荐
@property(nonatomic,strong) NSNumber *cnt;//播放次数

-(void)save;

@end
