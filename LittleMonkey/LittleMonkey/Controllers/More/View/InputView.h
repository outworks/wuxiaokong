//
//  InputView.h
//  HelloToy
//
//  Created by nd on 15/8/25.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabSuperVC.h"

@class InputView;

@protocol InputViewDelegate <NSObject>

@optional
// text
- (void)inputView:(InputView *)inputView sendMessage:(NSString *)message;

// image
- (void)inputView:(InputView *)inputView sendPicture:(UIImage *)image;

//调取相册
- (void)choiceImage;

@end

@interface InputView : UIView


@property (nonatomic, assign) id<InputViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *btn_send; //发送按钮
@property (weak, nonatomic) IBOutlet UITextView *tv_input;//输入框
@property (weak, nonatomic) IBOutlet UIButton *btn_image; //图片按钮

@property (strong, nonatomic) NSString *placeText;
@property (strong, nonatomic) UIColor * placeHolderTextColor;


@property (strong, nonatomic) NSLayoutConstraint *v_height; //聊天视图的高
@property (assign,nonatomic,readonly) CGFloat tv_minHeight; //默认textView高度
@property (nonatomic,assign) CGFloat maxLine; //最多几行
@property (nonatomic, retain) HideTabSuperVC *vc_super; //父控制器

+ (InputView *)initCustomView;
-(void)setUpWithSuperVC:(HideTabSuperVC *)superVC;

@end
