//
//  DataNetWorkSuperView.m
//  HelloToy
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "DataNetWorkSuperView.h"

@implementation DataNetWorkSuperView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)handleReloadDidClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(onViewReloadDidClicked:)]) {
        [_delegate onViewReloadDidClicked:self];
    }
}
@end
