//
//  Alarm.h
//  HelloToy
//
//  Created by nd on 15/6/10.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm : NSObject

@property(nonatomic,strong) NSNumber * toy_id; //玩具ID
@property(nonatomic,strong) NSString * alarm_id; //闹钟ID
@property(nonatomic,strong) NSNumber * time; //当天秒数(服务器时间)
@property(nonatomic,strong) NSString * weekday; // 1.2.3
@property(nonatomic,strong) NSString * tag; //标签
@property(nonatomic,strong) NSNumber * event; //铃声
@property(nonatomic,strong) NSString *event_name; // 铃声名称
@property(nonatomic,strong) NSNumber * enable; //开关
@property(nonatomic,readonly) NSNumber *localTime;//本地秒数
-(void)setLocalTime:(NSNumber *)localTime;

@end


@interface AlarmEvent : NSObject

@property(nonatomic,strong) NSNumber * event_id; //事件ID
@property(nonatomic,strong) NSString * desc; //描述
@property(nonatomic,strong) NSNumber * media_id; //媒体ID
@property(nonatomic,strong) NSString * url;     //媒体url
@property(nonatomic,strong) NSNumber * event_type; // 0:system 1:user

@end