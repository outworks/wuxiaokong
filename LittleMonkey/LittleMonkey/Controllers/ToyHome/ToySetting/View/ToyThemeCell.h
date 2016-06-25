//
//  ToyThemeCell.h
//  HelloToy
//
//  Created by nd on 15/5/28.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"
#import "Alarm.h"

@interface ToyThemeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_selected;
@property (weak, nonatomic) IBOutlet UILabel *lb_title_only;
@property (weak, nonatomic) IBOutlet UIButton *btn_tryListen;

@property (nonatomic,strong) Theme *theme;
@property (nonatomic,strong) AlarmEvent *alarmEvent;

@property (nonatomic,assign) BOOL isSelected;

@end
