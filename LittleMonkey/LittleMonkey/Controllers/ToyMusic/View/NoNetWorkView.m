//
//  NoNetWorkView.m
//  HelloToy
//
//  Created by apple on 16/2/3.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "NoNetWorkView.h"

@implementation NoNetWorkView

- (instancetype)initWithView:(UIView *)view
{
    if (view == nil) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.imageView.image = [UIImage imageNamed:@"icon_wifi"];
        self.lbTitle.text = NSLocalizedString(@"当前暂无数据", nil);
    }
    return self;
}


@end
