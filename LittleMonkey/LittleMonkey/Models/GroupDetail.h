//
//  GroupDetial.h
//  HelloToy
//
//  Created by nd on 15/4/28.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupDetail : NSObject

@property(nonatomic,strong) NSNumber *group_id; // 群ID
@property(nonatomic,strong) NSString *name; //群名称
@property(nonatomic,strong) NSString *icon; //群头像
@property(nonatomic,strong) NSMutableArray *toy_list; //玩具列表
@property(nonatomic,strong) NSMutableArray *user_list; //用户列表
@property(nonatomic,strong) NSNumber *owner_id; //群主ID
@property(nonatomic,strong) NSString *owner_name; //群主名称

-(void)save;

@end
