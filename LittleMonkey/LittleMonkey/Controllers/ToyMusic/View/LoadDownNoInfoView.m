//
//  LoadDownNoInfoView.m
//  HelloToy
//
//  Created by apple on 16/1/11.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "LoadDownNoInfoView.h"


@implementation LoadDownNoInfoView

- (IBAction)handleAddDidClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(onViewAddDidClicked:)]) {
        [_delegate onViewAddDidClicked:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
