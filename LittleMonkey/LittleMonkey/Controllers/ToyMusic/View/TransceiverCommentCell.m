//
//  TransceiverCommentCell.m
//  HelloToy
//
//  Created by yull on 15/12/31.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "TransceiverCommentCell.h"

@implementation TransceiverCommentCell

- (void)awakeFromNib {
    // Initialization code
    
    self.iconIV.layer.cornerRadius = CGRectGetHeight(self.iconIV.frame)/2;
    self.iconIV.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
