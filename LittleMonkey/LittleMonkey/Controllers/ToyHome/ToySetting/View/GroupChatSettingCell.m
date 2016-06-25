//
//  GroupChatSettingCell.m
//  HelloToy
//
//  Created by apple on 15/10/29.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "GroupChatSettingCell.h"

@implementation GroupChatSettingCell

- (void)awakeFromNib {
    // 设置头像为原形
    _ivHeader.layer.cornerRadius = _ivHeader.frame.size.width/2;
    _ivHeader.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
