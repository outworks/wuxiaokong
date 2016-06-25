//
//  ALarmEventVC.h
//  HelloToy
//
//  Created by nd on 15/6/16.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "NDAlarmAPI.h"

@interface ALarmEventVC : HideTabSuperVC

@property(nonatomic,strong)AlarmEvent * alarmEvent;

@property(nonatomic,copy) void (^SelectAlarmBlock)(AlarmEvent *alarmEvent);

@end
