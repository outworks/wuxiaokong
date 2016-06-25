//
//  HideTabSuperVC.m
//  HelloToy
//
//  Created by chenzf on 15/10/9.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "AppDelegate.h"



@interface HideTabSuperVC ()

@end

@implementation HideTabSuperVC


-(IBAction)backAction:(id)sender{
    [self handleBtnBackClicked];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    
    if([self canBack]){
        
        [self showLeftBarButtonItemWithImage:@"icon_back" target:self action:@selector(handleBtnBackClicked)];
        
    }else {
        
        [self showLeftBarButtonItemWithImage:@"" target:nil action:nil];
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [ApplicationDelegate hideTabView];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Functions

-(void)handleBtnBackClicked{
    
    if (self.navigationController.viewControllers.count == 1) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - Super Method

/**
 *  父类方法，用于控制是否显示返回按钮，默认yes
 */
- (BOOL)canBack{
    return YES;
}



@end
