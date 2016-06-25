//
//  ShowHUD.m
//  HelloToy
//
//  Created by nd on 15/4/23.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "ShowHUD.h"

#define DEFAULTMARGIN 15.0f

@interface ShowHUD ()<MBProgressHUDDelegate>{
    MBProgressHUD   *_hud;
}

@end

@implementation ShowHUD

- (instancetype)initWithView:(UIView *)view
{
    if (view == nil) {
        return nil;
    }
    self = [super init];
    if (self) {
        _hud = [[MBProgressHUD alloc] initWithView:view];
        _hud.delegate                  = self;                       // 设置代理
        _hud.animationType             = MBProgressHUDAnimationZoom; // 默认动画样式
        _hud.removeFromSuperViewOnHide = YES;                        // 该视图隐藏后则自动从父视图移除掉
        [view addSubview:_hud];
    }
    return self;
}

- (void)hide:(BOOL)hide afterDelay:(NSTimeInterval)delay
{
    [_hud hide:hide afterDelay:delay];
}

- (void)hide
{
    [_hud hide:YES];
}

- (void)show:(BOOL)show
{
    // 根据属性判断是否要显示文本
    if (_text != nil && _text.length != 0 && _text.length) {
        if (_text.length > 10) {
            _hud.detailsLabelText = _text;
        }else{
            _hud.labelText = _text;
        }
        
    }
    
    // 设置文本字体
    if (_textFont) {
        if (_text.length > 10) {
            _hud.detailsLabelFont = _textFont;
        }else{
            _hud.labelFont = _textFont;
        }
        
    }
    
    // 如果设置这个属性,则只显示文本
    if (_showTextOnly == YES && _text != nil && _text.length != 0) {
        _hud.mode = MBProgressHUDModeText;
    }
    
    //设置蒙版效果
    
    _hud.dimBackground = _dimBackground;
    
    // 设置背景色
    if (_backgroundColor) {
        _hud.color = _backgroundColor;
    }
    
    // 文本颜色
    if (_labelColor) {
        _hud.labelColor = _labelColor;
    }
    
    // 设置圆角
    if (_cornerRadius) {
        _hud.cornerRadius = _cornerRadius;
    }
    
    // 设置透明度
    if (_opacity) {
        _hud.opacity = _opacity;
    }
    
    // 自定义view
    if (_customView) {
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = _customView;
    }
    
    // 边缘留白
    if (_margin > 0) {
        _hud.margin = _margin;
    }
    
    [_hud show:show];
}

#pragma mark - HUD代理方法

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_hud removeFromSuperview];
    _hud = nil;
}

#pragma mark - 重写setter方法

@synthesize animationStyle = _animationStyle;

- (void)setAnimationStyle:(HUDAnimationType)animationStyle{
    _animationStyle    = animationStyle;
    _hud.animationType = (MBProgressHUDAnimation)_animationStyle;
}

- (HUDAnimationType)animationStyle{
    return _animationStyle;
}

#pragma mark - 便利的方法
+ (void)showTextOnly:(NSString *)text
     configParameter:(ConfigShowHUDBlock)config
            duration:(NSTimeInterval)sec
              inView:(UIView *)view
{
    ShowHUD *hud     = [[ShowHUD alloc] initWithView:view];
    hud.text         = text;
    hud.showTextOnly = YES;
    hud.margin       = DEFAULTMARGIN;
    hud.dimBackground = NO;
    hud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
    hud.animationStyle  = Zoom;   // 设定动画方式
    hud.cornerRadius    = 3.f;    // 边缘圆角
    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    
    // 配置额外的参数
    config(hud);
    
    // 显示
    [hud show:YES];
    
    // 延迟sec后消失
    [hud hide:YES afterDelay:sec];
}

+ (void)showText:(NSString *)text
 configParameter:(ConfigShowHUDBlock)config
        duration:(NSTimeInterval)sec
          inView:(UIView *)view
{
    ShowHUD *hud     = [[ShowHUD alloc] initWithView:view];
    hud.text         = text;
    hud.margin       = DEFAULTMARGIN;
    hud.dimBackground = NO;
    hud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
    hud.animationStyle  = Zoom;   // 设定动画方式
    hud.cornerRadius    = 3.f;    // 边缘圆角
    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];

    // 配置额外的参数
    config(hud);
    
    // 显示
    [hud show:YES];
    
    // 延迟sec后消失
    [hud hide:YES afterDelay:sec];
}


+ (void)showCustomView:(ConfigShowHUDCustomViewBlock)viewBlock
       configParameter:(ConfigShowHUDBlock)config
              duration:(NSTimeInterval)sec
                inView:(UIView *)view
{
    ShowHUD *hud     = [[ShowHUD alloc] initWithView:view];
    hud.margin       = DEFAULTMARGIN;
    hud.dimBackground = NO;
    hud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
    hud.animationStyle  = Zoom;   // 设定动画方式
    hud.cornerRadius    = 3.f;    // 边缘圆角
    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];

    // 配置额外的参数
    config(hud);
    
    // 自定义View
    hud.customView   = viewBlock();
    
    // 显示
    [hud show:YES];
    
    [hud hide:YES afterDelay:sec];
}



// 显示警告

+ (void)showWarning:(NSString *)text
    configParameter:(ConfigShowHUDBlock)config
           duration:(NSTimeInterval)sec
             inView:(UIView *)view{

    ShowHUD *hud = [ShowHUD showCustomView:^UIView *{
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showhud_warning"]];
    } configParameter:^(ShowHUD *confighud) {
        confighud.text = text;
        confighud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
        confighud.animationStyle  = Zoom;   // 设定动画方式
        confighud.cornerRadius    = 3.f;    // 边缘圆角
        confighud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        config(confighud);
    } inView:view];
    
    hud.text = text;
    [hud hide:YES afterDelay:sec];
    
}

// 显示失败

+ (void)showError:(NSString *)text
  configParameter:(ConfigShowHUDBlock)config
         duration:(NSTimeInterval)sec
           inView:(UIView *)view{

    ShowHUD *hud = [ShowHUD showCustomView:^UIView *{
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showhud_error"]];
    } configParameter:^(ShowHUD *confighud) {
        confighud.text = text;
        confighud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
        confighud.animationStyle  = Zoom;   // 设定动画方式
        confighud.cornerRadius    = 3.f;    // 边缘圆角
        confighud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        config(confighud);
    } inView:view];
    
    hud.text = text;
    [hud hide:YES afterDelay:sec];
    
}

// 显示成功

+ (void)showSuccess:(NSString *)text
    configParameter:(ConfigShowHUDBlock)config
           duration:(NSTimeInterval)sec
             inView:(UIView *)view{
    
    
    ShowHUD *hud = [ShowHUD showCustomView:^UIView *{
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showhud_success"]];
    } configParameter:^(ShowHUD *confighud) {
        confighud.text = text;
        confighud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
        confighud.animationStyle  = Zoom;   // 设定动画方式
        confighud.cornerRadius    = 3.f;    // 边缘圆角
        confighud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        config(confighud);
    } inView:view];
    
    hud.text = text;
    [hud hide:YES afterDelay:sec];

}

+ (instancetype)showTextOnly:(NSString *)text
             configParameter:(ConfigShowHUDBlock)config
                      inView:(UIView *)view
{
    ShowHUD *hud     = [[ShowHUD alloc] initWithView:view];
    hud.text         = text;
    hud.showTextOnly = YES;
    hud.margin       = DEFAULTMARGIN;
    hud.dimBackground = NO;
    hud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
    hud.animationStyle  = Zoom;   // 设定动画方式
    hud.cornerRadius    = 3.f;    // 边缘圆角
    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];

    
    // 配置额外的参数
    config(hud);
    
    // 显示
    [hud show:YES];
    
    return hud;
}

+ (instancetype)showText:(NSString *)text
         configParameter:(ConfigShowHUDBlock)config
                  inView:(UIView *)view
{
    ShowHUD *hud     = [[ShowHUD alloc] initWithView:view];
    hud.text         = text;
    hud.margin       = DEFAULTMARGIN;
    hud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
    hud.animationStyle  = Zoom;   // 设定动画方式
    hud.cornerRadius    = 3.f;    // 边缘圆角
    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];

    
    // 配置额外的参数
    config(hud);
    
    // 显示
    [hud show:YES];
    
    return hud;
}

+ (instancetype)showCustomView:(ConfigShowHUDCustomViewBlock)viewBlock
               configParameter:(ConfigShowHUDBlock)config
                        inView:(UIView *)view
{
    ShowHUD *hud     = [[ShowHUD alloc] initWithView:view];
    hud.margin       = DEFAULTMARGIN;
    hud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
    hud.animationStyle  = Zoom;   // 设定动画方式
    hud.cornerRadius    = 3.f;    // 边缘圆角
    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];

    
    // 配置额外的参数
    config(hud);
    
    // 自定义View
    hud.customView   = viewBlock();
    
    // 显示
    [hud show:YES];
    
    return hud;
}

- (void)dealloc
{
    NSLog(@"资源释放了,没有泄露^_^");
}



@end
