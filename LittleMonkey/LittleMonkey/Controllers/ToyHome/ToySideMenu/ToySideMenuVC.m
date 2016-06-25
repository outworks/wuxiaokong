//
//  ToySideMenuVC.m
//  HelloToy
//
//  Created by yull on 15/11/19.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "ToySideMenuVC.h"

@interface ToySideMenuVC () <RESideMenuDelegate>

@property (nonatomic, strong) UIView *blackView;

@end

@implementation ToySideMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.sideMenuViewController hideMenuViewController];
    
}

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController {
    
    if (self.blackView) {
        
        [self.blackView removeFromSuperview];
    }
    
    UIView *blackView = [[UIView alloc] initWithFrame:sideMenu.contentViewController.view.bounds];
    blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.blackView = blackView;
    [sideMenu.contentViewController.view addSubview:self.blackView];
    
    self.blackView.hidden = NO;
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController {
    
    self.blackView.hidden = YES;
}


#pragma mark - AKTabBar Method

// 常态图片名称
- (NSString *)tabImageName{
    
    return @"icon_tab_toyHome";
}

// 点击态图片名称
- (NSString *)tabSelectedImageName{
    
    return @"icon_tab_toyHome_selected";
}

// 标题
- (NSString *)tabTitle{
    return NSLocalizedString(@"悟小空", nil);
}



#pragma mark - dealloc 

- (void)dealloc{

    NSLog(@"ToySideMenuVC dealloc");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
