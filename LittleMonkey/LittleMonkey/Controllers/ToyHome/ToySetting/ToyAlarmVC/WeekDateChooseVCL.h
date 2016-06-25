//
//  WeekDateChooseVCL.h
//  belang
//
//  Created by ilikeido on 14-9-22.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "Alarm.h"

@interface WeekDateChooseVCL : HideTabSuperVC

@property(nonatomic,strong) Alarm *alarm;

@property (nonatomic, copy) void (^SaveBlock)(Alarm *alarm);

@end
