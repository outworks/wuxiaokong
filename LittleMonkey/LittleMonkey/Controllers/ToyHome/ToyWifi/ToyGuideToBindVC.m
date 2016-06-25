//
//  ToyGuideToBindVC.m
//  LittleMonkey
//
//  Created by Hcat on 16/6/5.
//  Copyright © 2016年 CivetCatsTeam. All rights reserved.
//

#import "ToyGuideToBindVC.h"

#import <RESideMenu/UIViewController+RESideMenu.h>

#import "ToyWifiFirstVC.h"
#import "GroupAddVC.h"
#import "NDGroupAPI.h"

@interface ToyGuideToBindVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_toyBing;
@property (weak, nonatomic) IBOutlet UIView *v_top;

@property (weak, nonatomic) IBOutlet UIButton *btn_changeUser;

@property (weak, nonatomic) IBOutlet UIButton *btn_addGroup;




@end

@implementation ToyGuideToBindVC

#define ALERTVIEW_TAG_ADDNEWTOY 110


#pragma mark - viewLift

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setToyInfoSucess:) name:NOTIFICATION_SETTOYINFOSUCESS object:nil];
    
    self.navigationController.navigationBarHidden = YES;
    if (_isGuide == NO) {
        [ApplicationDelegate showTabView];
    }else{
        if (_isHaveToy) {
            [ApplicationDelegate hideTabView];
        }else{
            [ApplicationDelegate showTabView];

        }
    
    }
    
    self.imageV_toyBing.layer.cornerRadius = 220/2;
    self.imageV_toyBing.layer.borderWidth = 4.f;
    self.imageV_toyBing.layer.borderColor = [RGB(230, 230, 230) CGColor];
    self.imageV_toyBing.layer.masksToBounds = YES;
    
    if (_isGuide) {
        _btn_changeUser.hidden = NO;
        _btn_addGroup.hidden = NO;
        _v_top.hidden = YES;
        
    }else{
        
        _btn_changeUser.hidden = YES;
        _btn_addGroup.hidden = YES;
        
        if (_isHaveToy) {
            _v_top.hidden = NO;
        }else{
            _v_top.hidden = YES;
        }
        
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    //[super viewWillAppear:animated];
   self.navigationController.navigationBarHidden = YES;
    if (_isGuide == NO) {
        [ApplicationDelegate showTabView];
        if (_isHaveToy) {
            [ApplicationDelegate hideTabView];
        }else{
            [ApplicationDelegate showTabView];
            
        }
    }

}

#pragma mark - privateMethods

- (void)juageGroup
{
    
    NDGroupDetailParams *params = [[NDGroupDetailParams alloc] init];
    [NDGroupAPI groupDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        
        if (data.count != 0) {
            
            GroupDetail *groupDetail = data[0];
            [groupDetail save];
            [ShareFun enterGroup:groupDetail];
            
            [GCDQueue executeInMainQueue:^{
                
                ApplicationDelegate.tabBarController.selectedIndex = 0;
                [ApplicationDelegate initAKTabBarController];
                ApplicationDelegate.window.rootViewController = ApplicationDelegate.tabBarController;
                
            } afterDelaySecs:1];
            
        }
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFCATION_LOGOUT object:nil];
    }];
}


#pragma mark -buttonAction

- (IBAction)btnShowToyListAction:(id)sender {
    
    [self presentLeftMenuViewController:nil];
    
}

- (IBAction)btnAddGroupAction:(id)sender {
    
    GroupAddVC *vc = [[GroupAddVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)btnToyBingAction:(id)sender {
    
    
    if ([ShareValue sharedShareValue].group_id) {
        
        if ([ShareFun isGroupOwner]) {
            
            ToyWifiFirstVC *toyWifiFirstVC = [[ToyWifiFirstVC alloc] init];
            toyWifiFirstVC.type = ToySetType;
            [self.navigationController pushViewController:toyWifiFirstVC animated:YES];
            
        }else{
            
            UIAlertView *t_aler = [[UIAlertView alloc] initWithTitle:PROGRAMNAME message:NSLocalizedString(@"非群主添加玩具,将退出该群,是否退出该群", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"否", nil) otherButtonTitles:NSLocalizedString(@"是", nil), nil];
            t_aler.tag = ALERTVIEW_TAG_ADDNEWTOY;
            [t_aler show];
            
        }
        
        
    }else{
        
        ToyWifiFirstVC *toyWifiFirstVC = [[ToyWifiFirstVC alloc] init];
        toyWifiFirstVC.type = ToySetType;
        [self.navigationController pushViewController:toyWifiFirstVC animated:YES];
        
    }
    
    
}

- (IBAction)btnChangeUserAction:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFCATION_LOGOUT object:nil];

}

- (IBAction)btnHelpAction:(id)sender {
    
    
    
    
}


#pragma mark - UIAlerViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == ALERTVIEW_TAG_ADDNEWTOY) {
        
        if (buttonIndex == 1) {
            
            NDGroupQuitParams *params = [[NDGroupQuitParams alloc] init];
            
            params.group_id = [ShareValue sharedShareValue].group_id;
            
            ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
            } inView:self.view];
            
            [NDGroupAPI groupQuitWithParams:params completionBlockWithSuccess:^{
                
                [hud hide];
                
                [ShowHUD showSuccess:NSLocalizedString(@"退出成功", nil) configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:self.view];
                
                [ShareFun deleteAllTable];
                [ShareFun deleteMailTable];
                [ShareFun quitGroup];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_QUIT object:nil];
            
            } Fail:^(int code, NSString *failDescript) {
                
                [hud hide];
                
                [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:self.view];
                
            }];
        }
    }
}

#pragma mark - notifition

-(void)setToyInfoSucess:(NSNotification *)note{
    
    if (![ShareValue sharedShareValue].groupDetail) {
        [self juageGroup];
    }
    
    
    
}

#pragma mark - dealloc

- (void)dealloc{

    NSLog(@"ToyGuideToBindVC dealloc");

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
