//
//  ApplyInfo.h
//  HelloToy
//
//  Created by nd on 15/4/28.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyInfo : NSObject

@property(nonatomic,strong) NSString *apply_id; //请求ID
@property(nonatomic,strong) NSNumber *user_id; // 用户ID
@property(nonatomic,strong) NSString *nickname; //用户名
@property(nonatomic,strong) NSString *icon; //用户头像
@property(nonatomic,strong) NSString *content; //请求内容

@end
