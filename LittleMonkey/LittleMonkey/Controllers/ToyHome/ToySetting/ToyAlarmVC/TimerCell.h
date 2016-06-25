//
//  TimerCell.h
//  belang
//
//  Created by ilikeido on 14-9-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alarm.h"

@interface TimerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_descript;
@property (strong, nonatomic) IBOutlet UISwitch *switch_time;

@property(nonatomic,strong) Alarm *alarm;

@end