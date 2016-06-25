//
//  ChildSelectView.h
//  HelloToy
//
//  Created by huanglurong on 16/4/27.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChildSelectView;

typedef void (^ChildSelectViewTagBlock)(NSInteger index);

@interface ChildSelectView : UIView

@property(nonatomic,copy) ChildSelectViewTagBlock block_tag;

-(void)setUpLabels:(NSInteger)number WithIndex:(NSInteger)index;


+ (ChildSelectView *)initCustomView;

-(void)show;
-(void)hide;

@end
