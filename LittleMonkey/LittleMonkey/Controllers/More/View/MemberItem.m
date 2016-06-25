//
//  MemberItem.m
//  Talker
//
//  Created by nd on 15/1/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "MemberItem.h"

@implementation MemberItem


+ (MemberItem *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MemberItem" owner:self options:nil];

    return [nibView objectAtIndex:0];
}


- (IBAction)userInfoAction:(id)sender {
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(checkOutUserInfo:)]) {
        [self.delegate checkOutUserInfo:self];
    }

}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    if (_isSelected) {
        self.imageV_selected.hidden = NO;
    }else{
        self.imageV_selected.hidden = YES;
    }

}

@end
