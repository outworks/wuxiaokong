//
//  ShowHUD.h
//  HelloToy
//
//  Created by nd on 15/4/23.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@class ShowHUD;


//定义block
typedef void(^ConfigShowHUDBlock)(ShowHUD *config);
typedef UIView *(^ConfigShowHUDCustomViewBlock)();

typedef enum{
    Fade = MBProgressHUDAnimationFade,
    Zoom = MBProgressHUDAnimationZoom,
    ZoomOut = MBProgressHUDAnimationZoomOut,
    ZoomIn = MBProgressHUDAnimationZoomIn,
} HUDAnimationType;


@interface ShowHUD : NSObject

@property(nonatomic,assign) HUDAnimationType animationStyle;      // 动画样式

// 文本加菊花
@property (nonatomic, strong) NSString          *text;            // 文本
@property (nonatomic, strong) UIFont            *textFont;        // 文本字体

// 自定义view
@property (nonatomic, strong) UIView            *customView;      // 自定义view  37x37尺寸

// 只显示文本的相关设置
@property (nonatomic, assign) BOOL               showTextOnly;    // 只显示文本

// 边缘留白
@property (nonatomic, assign) float              margin;          // 边缘留白

// 颜色设置(设置了颜色之后,透明度就会失效)
@property (nonatomic, strong) UIColor           *backgroundColor; // 背景颜色
@property (nonatomic, strong) UIColor           *labelColor;      // 文本颜色

// 透明度
@property (nonatomic, assign) float              opacity;         // 透明度

// 圆角
@property (nonatomic, assign) float              cornerRadius;    // 圆角

// 蒙版效果
@property (nonatomic, assign) BOOL               dimBackground;   // 蒙版效果


// 仅仅显示文本并持续几秒的方法
/* - 使用示例 -
 [ShowHUD showTextOnly:@"请稍后,显示不了..."
 configParameter:^(ShowHUD *config) {
 config.margin          = 10.f;    // 边缘留白
 config.opacity         = 0.7f;    // 设定透明度
 config.cornerRadius    = 2.f;     // 设定圆角
 } duration:3 inView:self.view];
 */

+ (void)showTextOnly:(NSString *)text
     configParameter:(ConfigShowHUDBlock)config
            duration:(NSTimeInterval)sec
              inView:(UIView *)view;


// 显示文本与菊花并持续几秒的方法(文本为nil时只显示菊花)
/* - 使用示例 -
 [ShowHUD showText:@"请稍后,显示不了..."
 configParameter:^(ShowHUD *config) {
 config.margin          = 10.f;    // 边缘留白
 config.opacity         = 0.7f;    // 设定透明度
 config.cornerRadius    = 2.f;     // 设定圆角
 } duration:3 inView:self.view];
 */

+ (void)showText:(NSString *)text
 configParameter:(ConfigShowHUDBlock)config
        duration:(NSTimeInterval)sec
          inView:(UIView *)view;


// 加载自定义view并持续几秒的方法
/* - 使用示例 -
 [ShowHUD showText:@"请稍后,显示不了..."
 configParameter:^(ShowHUD *config) {
 config.margin          = 10.f;    // 边缘留白
 config.opacity         = 0.7f;    // 设定透明度
 config.cornerRadius    = 2.f;     // 设定圆角
 } duration:3 inView:self.view];
 */

+ (void)showCustomView:(ConfigShowHUDCustomViewBlock)viewBlock
       configParameter:(ConfigShowHUDBlock)config
              duration:(NSTimeInterval)sec
                inView:(UIView *)view;


// 显示警告

+ (void)showWarning:(NSString *)text
    configParameter:(ConfigShowHUDBlock)config
           duration:(NSTimeInterval)sec
             inView:(UIView *)view;

// 显示失败

+ (void)showError:(NSString *)text
  configParameter:(ConfigShowHUDBlock)config
         duration:(NSTimeInterval)sec
           inView:(UIView *)view;

// 显示成功

+ (void)showSuccess:(NSString *)text
    configParameter:(ConfigShowHUDBlock)config
           duration:(NSTimeInterval)sec
             inView:(UIView *)view;






+ (instancetype)showTextOnly:(NSString *)text
             configParameter:(ConfigShowHUDBlock)config
                      inView:(UIView *)view;
+ (instancetype)showText:(NSString *)text
         configParameter:(ConfigShowHUDBlock)config
                  inView:(UIView *)view;
+ (instancetype)showCustomView:(ConfigShowHUDCustomViewBlock)viewBlock
               configParameter:(ConfigShowHUDBlock)config
                        inView:(UIView *)view;


- (void)hide;
- (void)hide:(BOOL)hide afterDelay:(NSTimeInterval)delay;


@end
