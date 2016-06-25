//
//  UIButton+Block.h
//  项目框架
//
//  Created by Hcat on 14-2-26.
//  Copyright (c) 2014年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ActionBlock)();


@interface UIButton(Block)

-(void)handleClickEvent:(UIControlEvents)aEvent withClickBlick:(ActionBlock)buttonClickEvent;

/*
 扩展按钮的点击范围
*/

- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
@end
