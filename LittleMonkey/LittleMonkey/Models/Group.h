//
//  Group.h
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject

@property(nonatomic,strong) NSNumber * group_id; //群ID
@property(nonatomic,strong) NSString * name; // 用户名
@property(nonatomic,strong) NSNumber * owner_id; //群主ID
@property(nonatomic,strong) NSString * icon; //头像

-(void)save;

@end
