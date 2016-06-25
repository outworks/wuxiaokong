//
//  AppDelegate.h
//  LittleMonkey
//
//  Created by huanglurong on 16/4/5.
//  Copyright © 2016年 NDHcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AKTabBarController *tabBarController;


-(void)showTabView;

-(void)hideTabView;

-(void)initAKTabBarController;

-(void)reloadTabBar;

@end

