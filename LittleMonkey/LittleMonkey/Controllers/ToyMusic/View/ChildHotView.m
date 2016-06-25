//
//  ChildHotView.m
//  HelloToy
//
//  Created by huanglurong on 16/4/14.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildHotView.h"

@implementation ChildHotView


- (IBAction)btnMoreAction:(id)sender {
    
    if (_block) {
        self.block();
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
