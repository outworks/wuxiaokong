//
//  ToySetingCell.m
//  HelloToy
//
//  Created by nd on 15/11/2.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "ToySettingCell.h"

@implementation ToySettingCell

- (void)awakeFromNib {
    // 设置头像为原形
    if (!_imageV_icon.layer.masksToBounds) {
        _imageV_icon.layer.masksToBounds = YES;
        _imageV_icon.layer.cornerRadius = _imageV_icon.bounds.size.width * 0.5;
    }
    
}

- (IBAction)switchAction:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        if (_delegate &&[_delegate respondsToSelector:@selector(swithAction:)]) {
            [self.delegate swithAction:YES];
        }
    }else {
        if (_delegate &&[_delegate respondsToSelector:@selector(swithAction:)]) {
            [self.delegate swithAction:NO];
        }
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
