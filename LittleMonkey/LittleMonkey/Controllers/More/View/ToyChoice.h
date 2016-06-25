//
//  ToyChoice.h
//  HelloToy
//
//  Created by nd on 15/5/12.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *
 * ******************** 分享给好友页面 **********************
 *
 */


@protocol ToyChoiceDelegate;

@interface ToyChoice : UIView

@property(weak,nonatomic) id<ToyChoiceDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_bg;

@property (weak, nonatomic) IBOutlet UIView *v_bottom;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollow;

@property(nonatomic,strong)NSMutableArray *arr_data;

@property (weak, nonatomic) IBOutlet UILabel *lb_info;

@property (nonatomic,assign) NSInteger index;
  
+ (ToyChoice *)initCustomView;
-(void)show;
-(void)hide;

-(void)setSelectedIndex:(NSInteger)tag;

@end

@protocol ToyChoiceDelegate <NSObject>

-(void)checkButtonIndex:(NSInteger)tag;


@end