//
//  ToyStat.h
//  HelloToy
//
//  Created by nd on 15/12/17.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ToyDaily : NSObject

@property(nonatomic,strong) NSString * date;            //玩具ID
@property(nonatomic,strong) NSNumber * play_count;      //播放次数
@property(nonatomic,strong) NSNumber * mail_count;      //语音次数
@property(nonatomic,strong) NSNumber * robot_count;

@end

@interface ToyStat : NSObject

@property(nonatomic,strong) NSNumber * toy_id;          //玩具ID
@property(nonatomic,strong) NSNumber * play_count;      //播放总次数
@property(nonatomic,strong) NSNumber * mail_count;      //语音总次数
@property(nonatomic,strong) NSNumber * robot_count;
@property(nonatomic,strong) NSArray  *history;          //为历史记录，数组包含ToyDaily对象

@end
