//
//  LoginHomeVC.m
//  LittleMonkey
//
//  Created by huanglurong on 16/5/29.
//  Copyright © 2016年 NDHcat. All rights reserved.
//

#import "LoginHomeVC.h"
#import "IQKeyboardManager.h"

#import "MiPushSDK.h"
#import "WXApi.h"

#import "WebSocketHelper.h"

#import "NDUserAPI.h"
#import "NDGroupAPI.h"

#import "LoginVC.h"

#import "AFNetworking.h"

#import "ToyGuideToBindVC.h"



@interface LoginHomeVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_bg;

@end

@implementation LoginHomeVC

#pragma mark - viewLift

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    [_imageV_bg setImage:[UIImage imageNamed:@"LoginImage_bg"]];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    if ([ShareValue sharedShareValue].user_id) {
        
        [self todoWhenLoginSuccessed:[ShareValue sharedShareValue].user_id];
        
    } else {
        //设置按钮显示状态
        [self handleLoginDidClick:nil];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ShareValue sharedShareValue].toyDetail = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXLoginSuccess:) name:NOTIFICATION_WX_LOGIN_SUCCESS object:nil];
    
    
}

#pragma mark - ButtonActions

- (IBAction)handleLoginDidClick:(id)sender {
    
    LoginVC *loginVC = [[LoginVC alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

#pragma mark - Fuction

//登录之后需要做的动作
- (void)todoWhenLoginSuccessed:(NSNumber *)userid
{
    /***** 开启webSocket ****/
    [[WebSocketHelper sharedWebSocketHelper] startServer];
    
    /***** 清除数据库中的群成员信息以及user信息还有玩具信息 ******/
    
    [ShareFun clearAllTable];
    
    
    [GCDQueue executeInGlobalQueue:^{
        [self getUserDetail:[userid stringValue]];
        [self doUserCollect];
    }];
    
    [self uploadJpushId];
    [self juageGroup];
    
}

/************ 请求用户信息 *************/

-(void)getUserDetail:(NSString *)id_list{
    
    NDUserDetailParams * params = [[NDUserDetailParams alloc] init];
    params.id_list = nil;
    [NDUserAPI userDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        
        if (data.count > 0) {
            
            NSLog(@"本地用户信息请求或者更新成功");
            User *user = data[0];
            [ShareValue sharedShareValue].user = user;
            
        }
    } Fail:^(int code, NSString *failDescript) {
        
        NSLog(@"本地用户信息请求或者更新失败");
        
    }];
}

/************ 用于用户连接 *************/

- (void)doUserCollect {
    
    NDUSerCollectParams *params = [[NDUSerCollectParams alloc] init];
    params.platform = @"iOS";
    params.devmodel = [UIDevice currentDevice].model;
    params.devversion = [UIDevice currentDevice].systemVersion;
    params.appversion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [NDUserAPI userCollectWithParams:params completionBlockWithSuccess:^{
        
    } Fail:^(int code, NSString *failDescript) {
        
    }];
}

/************** 更新jpushID ****************/

-(void) uploadJpushId{
    
    NSString *jpushid = [ShareValue sharedShareValue].miPushId;
    
    if (jpushid) {
        [MiPushSDK setAlias:[[ShareValue sharedShareValue].user_id stringValue]];
        NDUserSetJPushIdParams *params = [[NDUserSetJPushIdParams alloc] init];
        params.jpush_id = jpushid;
        params.channel = 3;
        
        [NDUserAPI userSetJPushIdWithParams:params completionBlockWithSuccess:^{
            
            NSLog(@"JPushID请求或者更新成功");
            
        } Fail:^(int code, NSString *failDescript) {
            
            NSLog(@"JPushID请求或者更新失败");
            
        }];
        
    }
    
}

/************** 请求群详情 ****************/

- (void)juageGroup
{
    if ([ShareValue sharedShareValue].user_id) {
        
        [ShowHUD showText:@"自动登录中..." configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }
    
    NDGroupDetailParams *params = [[NDGroupDetailParams alloc] init];
    
    [NDGroupAPI groupDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        
        if (data.count != 0) {
            
            GroupDetail *groupDetail = data[0];
            [groupDetail save];
            [ShareFun enterGroup:groupDetail];
            
            [GCDQueue executeInMainQueue:^{
                
                [ApplicationDelegate initAKTabBarController];
                ApplicationDelegate.window.rootViewController = ApplicationDelegate.tabBarController;
                ApplicationDelegate.tabBarController.selectedIndex = 0;
                
            } afterDelaySecs:1];
        
        }else{
        
            ToyGuideToBindVC * vc = [[ToyGuideToBindVC alloc] init];
            vc.isGuide = YES;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
            
        
        }
        
       

    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFCATION_LOGOUT object:nil];
    }];
}


#pragma mark - notification

- (void)WXLoginSuccess:(NSNotification *)notification{
    
    if (notification.userInfo != nil) {
        
        [self getOpenidAndTokenFromWxCode:[notification.userInfo objectForKey:@"code"]];
        
    }
    
}

- (void)getOpenidAndTokenFromWxCode:(NSString*)code {
    
    NSString* reqUrl = [NSString stringWithFormat:WX_BASE_URL, WEIXIN_APP_ID, WEIXIN_APP_SECRET,code];
    NSURL *url = [NSURL URLWithString:[reqUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"url = %@",url);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation  alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            NSDictionary* JSON = (NSDictionary*)dict;
            NSLog(@"get data from weixin = %@",JSON);
            
            ND3rdLoginParams *params = [[ND3rdLoginParams alloc] init];
            params.channel = @"wx";
            params.account = [JSON objectForKey:@"openid"];
            params.token = [JSON objectForKey:@"access_token"];
            [NDUserAPI userThirdLoginWithParams:params completionBlockWithSuccess:^(ND3rdLoginResult * result) {
                
                [ShareValue sharedShareValue].user_id = @([result.user_id longLongValue]);
                [self todoWhenLoginSuccessed:@([result.user_id longLongValue])];
                
            } Fail:^(int code, NSString *failDescript) {
                
                [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:self.view];
                
            }];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"get data from weixin error = %@",error);
        
        [ShowHUD showError:NSLocalizedString(@"登录失败", nil) configParameter:^(ShowHUD *config) {
        } duration:1.4f inView:self.view];
        
    }];
    
    [operation start];
}

#pragma mark - navigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[self class]]) {
        self.navigationController.navigationBarHidden = YES;
    }
}


#pragma mark - dealloc

- (void)dealloc{

    NSLog(@"LoginHomeVC dealloc");
    
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
