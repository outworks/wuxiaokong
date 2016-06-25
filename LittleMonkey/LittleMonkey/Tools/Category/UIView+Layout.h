//
//  UIView+Layout.h
//  Diapers.com
//
//  Created by lyy on 7/26/13.
//  Copyright (c) 2013 Suryani. All rights reserved.
//
//  开发版本: v1.0
//  开发者: yoyea
//  编写时间: 13-7-26
//  功能描述: 方便获取坐标x y height width

#import <UIKit/UIKit.h>

@interface UIView (Layout)

@property (assign, nonatomic) CGFloat frameX;
@property (assign, nonatomic) CGFloat frameY;
@property (assign, nonatomic) CGFloat frameWidth;
@property (assign, nonatomic) CGFloat frameHeight;
@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;
@property (assign, nonatomic) CGFloat bottomY;

@property (assign, nonatomic) CGFloat top;
@property (assign, nonatomic) CGFloat bottom;
@property (assign, nonatomic) CGFloat right;
@property (assign, nonatomic) CGFloat left;

@end
