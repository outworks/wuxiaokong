//
//  ToyThemeCell.m
//  HelloToy
//
//  Created by nd on 15/5/28.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "ToyThemeCell.h"
#import "UIImageView+WebCache.h"

@implementation ToyThemeCell

- (void)awakeFromNib {
    // Initialization code
    self.imageV_icon.layer.cornerRadius = self.imageV_icon.frame.size.width/2;
    self.imageV_icon.layer.masksToBounds = YES;
    self.imageV_icon.layer.borderWidth = 0.5f;
    //self.imageV_icon.layer.borderColor = [[UIColor colorWithRed:0.090 green:0.706 blue:0.839 alpha:1.000] CGColor];
    self.imageV_icon.layer.borderColor = [[UIColor clearColor] CGColor];
    _isSelected = NO;
}

-(void)setTheme:(Theme *)theme{
    if (theme) {
        _theme = theme;
        _lb_title_only.hidden = YES;
        [_imageV_icon sd_setImageWithURL:[NSURL URLWithString:_theme.icon] placeholderImage:[UIImage imageNamed:@"LogoIcon"]];
        _lb_title.text = _theme.name;
        
    }
}

-(void)setAlarmEvent:(AlarmEvent *)alarmEvent{
    if (alarmEvent) {
        _alarmEvent = alarmEvent;
        
        _imageV_icon.hidden = YES;
        _lb_title.hidden = YES;
        _btn_tryListen.hidden = YES;
        _lb_title_only.text = _alarmEvent.desc;
    }
}



-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    if (_isSelected) {
        _imageV_selected.hidden = NO;
    }else{
        _imageV_selected.hidden = YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
