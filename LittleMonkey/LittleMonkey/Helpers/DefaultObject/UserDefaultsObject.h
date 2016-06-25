//
//  UserDefaultsObject.h
//  HelloToy
//
//  Created by nd on 15/4/22.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsObject : NSObject

@property(nonatomic,strong) NSNumber *user_id; //用户ID
@property(nonatomic,strong) NSNumber *group_id; //群ID
@property(nonatomic,strong) NSNumber *group_owner_id; // 群主ID
@property(nonatomic,strong) NSNumber *toy_id; //当前玩具ID

@property(nonatomic,strong) NSNumber *collection_id; //收藏ID

@property(nonatomic,strong) NSString *miPushId;

@property(nonatomic,assign) BOOL isRememberPassword;//记住密码

@property(nonatomic,strong) NSDictionary *userInfo;//用户信息（账号、密码）

@property(nonatomic,strong) NSNumber *netWork; // 判断是否未外网  1 为外网  0为内网

@property(nonatomic,strong) NSNumber *wechatId;//是否跳过绑定手机

@property(nonatomic,strong) NSNumber *lasttime_chat;//最后一条消息的时间

SYNTHESIZE_SINGLETON_FOR_HEADER(UserDefaultsObject)

@end
