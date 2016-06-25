//
//  HideTabSuperVC.h
//  HelloToy
//
//  Created by chenzf on 15/10/9.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogViewController.h"
#import "UINavigationBar+BarItem.h"

/**
 *  隐藏Tabbar的父类，一般用于次级页面
 */
@interface HideTabSuperVC : LogViewController

-(void)handleBtnBackClicked;

-(IBAction)backAction:(id)sender;

@end
