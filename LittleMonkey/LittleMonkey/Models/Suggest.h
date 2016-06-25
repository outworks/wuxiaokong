//
//  Suggest.h
//  HelloToy
//
//  Created by nd on 15/8/28.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Suggest : NSObject

@property(nonatomic,strong) NSNumber * suggest_id;      //建议ID
@property(nonatomic,strong) NSString * content;         //内容
@property(nonatomic,strong) NSString * picture;         //图片
@property(nonatomic,strong) NSNumber * pictureWidth;    //image宽度
@property(nonatomic,strong) NSNumber * pictureHeight;   //image高度
@property(nonatomic,strong) NSString * reply;           //回复
@property(nonatomic,strong) NSString * time;            //时间


@end
