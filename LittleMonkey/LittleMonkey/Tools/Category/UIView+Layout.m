//
//  UIView+Layout.m
//  Diapers.com
//
//  Created by lyy on 7/26/13.
//  Copyright (c) 2013 Suryani. All rights reserved.
//
//  开发版本: v1.0
//  开发者: yoyea
//  编写时间: 13-7-26
//  功能描述: 方便获取坐标x y height width

#import "UIView+Layout.h"

@implementation UIView (Layout)

- (CGFloat)frameX {
    return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)x {
    CGRect localFrame = self.frame;
    localFrame.origin.x = x;
    
    self.frame = localFrame;
}

- (CGFloat)frameY {
    return self.frame.origin.y;
}

-(void)setFrameY:(CGFloat)y {
    CGRect localFrame = self.frame;
    localFrame.origin.y = y;
    
    self.frame = localFrame;
}

- (CGFloat)frameWidth {
    return self.frame.size.width;
}

-(void)setFrameWidth:(CGFloat)width {
    CGRect localFrame = self.frame;
    localFrame.size.width = width;
    
    self.frame = localFrame;
}

- (CGFloat)frameHeight {
    return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)height {
    CGRect localFrame = self.frame;
    localFrame.size.height = height;
    
    self.frame = localFrame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint localPoint = self.center;
    localPoint.x = centerX;
    
    self.center = localPoint;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint localPoint = self.center;
    localPoint.y = centerY;
    
    self.center = localPoint;
}

- (CGFloat)bottomY {
    return self.frameY + self.frameHeight;
}

- (void)setBottomY:(CGFloat)bottomY {
    CGRect localFrame = self.frame;
    localFrame.origin.y = bottomY - self.frameHeight;
    
    self.frame = localFrame;
}


- (CGFloat)top {
    return self.frame.origin.y;
}


- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setTop:(CGFloat)top {
    self.frame = CGRectMake(self.frame.origin.x, top,
                            self.frame.size.width, self.frame.size.height);
}

- (void)setBottom:(CGFloat)bottom {
    self.frame = CGRectMake(self.frame.origin.x, bottom - self.frame.size.height,
                            self.frame.size.width, self.frame.size.height);
}

- (void)setLeft:(CGFloat)left {
    self.frame = CGRectMake(left, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height);
}

- (void)setRight:(CGFloat)right {
    self.frame = CGRectMake(right - self.frame.size.width, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height);
}

@end
