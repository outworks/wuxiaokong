//
//  Toy.h
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Toy : NSObject

@property(nonatomic,strong) NSNumber * toy_id;      //玩具ID
@property(nonatomic,strong) NSString * nickname;    // 用户名
@property(nonatomic,strong) NSString * icon;        //头像
@property(nonatomic,strong) NSNumber * electricity; //电量
@property(nonatomic,strong) NSNumber *isonline;     //是否在线
@property(nonatomic,strong) NSNumber *gender;       //性别 0：未知 1：男 2：女
@property(nonatomic,strong) NSString *birthday;     //生日


-(void)save;

@end
