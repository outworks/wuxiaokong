//
//  User.h
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject

@property(nonatomic,strong) NSNumber * user_id;     //用户编号
@property(nonatomic,strong) NSString * nickname;    // 用户名
@property(nonatomic,strong) NSString * icon;        //头像


-(void)save;

@end
