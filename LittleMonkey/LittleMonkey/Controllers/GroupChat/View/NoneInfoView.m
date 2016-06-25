//
//  NoneInfoView.m
//  HelloToy
//
//  Created by apple on 15/11/3.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "NoneInfoView.h"

@implementation NoneInfoView

- (instancetype)initWithView:(UIView *)view
{
    if (view == nil) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.imageView.image = [UIImage imageNamed:@"icon_nonInfo"];
        self.lbTitle.text = NSLocalizedString(@"NoData", nil);
    }
    return self;
}

@end
