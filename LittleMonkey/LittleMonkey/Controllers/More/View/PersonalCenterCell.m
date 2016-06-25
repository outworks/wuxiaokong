//
//  PersonalCenterCell.m
//  LittleMonkey
//
//  Created by Hcat on 16/6/4.
//  Copyright © 2016年 CivetCatsTeam. All rights reserved.
//

#import "PersonalCenterCell.h"

@interface PersonalCenterCell()


@end


@implementation PersonalCenterCell

- (void)awakeFromNib {
    
    _imageV_icon.layer.cornerRadius = 31;
    _imageV_icon.layer.masksToBounds = YES;
    
}





#pragma mark -

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
