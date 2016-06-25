//
//  UINavigationBar+BarItem.h
//  jiulifang
//
//  Created by hesh on 13-10-29.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (Codoon)

- (void)showLeftBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action ;

- (void)showRightBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action ;

- (void)showLeftBarButtonItemWithImage:(NSString *)image target:(id)target action:(SEL)action ;

- (void)showRightBarButtonItemWithImage:(NSString *)image target:(id)target action:(SEL)action ;

- (void)showLeftBarButtonItemWithTitle:(NSString *)title BgImageName:(NSString *)imageName target:(id)target action:(SEL)action;

- (void)showRightBarButtonItemWithTitle:(NSString *)title BgImageName:(NSString *)imageName target:(id)target action:(SEL)action;

-(void) showRightBarButtonItemToSelected;

- (void)setTitleButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end