//
//  PushLog.h
//  HelloToy
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushLog : NSObject

@property(nonatomic,strong) NSNumber * msg_from;    // 发送者id（0-系统通知 1-系统请求 其他-公众号或其他类型）
@property(nonatomic,strong) NSNumber * unread_cnt;  // 未读个数
@property(nonatomic,strong) NSString * msg_title;   // 最后一条消息
@property(nonatomic,strong) NSNumber * add_time;    // 最后一条时间
@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSURL * iconUrl;

@end
