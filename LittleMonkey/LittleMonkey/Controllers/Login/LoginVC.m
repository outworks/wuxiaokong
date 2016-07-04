//
//  LoginVC.m
//  LittleMonkey
//
//  Created by huanglurong on 16/5/29.
//  Copyright © 2016年 NDHcat. All rights reserved.
//

#import "LoginVC.h"
#import "IQKeyboardManager.h"
#import "Reachability.h"

#import "WXApi.h"

#import "UserDefaultsObject.h"
#import "WebSocketHelper.h"

#import "NSString+md5.h"


#import "NDUserAPI.h"
#import "NDGroupAPI.h"

#import "ForgetPasswordVC.h"
#import "RegisterVC.h"
#import "ToyGuideToBindVC.h"




@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_account;
@property (weak, nonatomic) IBOutlet UITextField *tf_password;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_userName;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_password;

@property (weak, nonatomic) IBOutlet UILabel *lb_userName;
@property (weak, nonatomic) IBOutlet UILabel *lb_password;

@property (weak, nonatomic) IBOutlet UIButton *btn_login;   //登录按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_wxLogin; //注册按钮

@end

@implementation LoginVC

#pragma mark - viewLift

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [self initView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if ([UserDefaultsObject sharedUserDefaultsObject].userInfo) {
        
        NSMutableDictionary *t_dic = (NSMutableDictionary *)[UserDefaultsObject sharedUserDefaultsObject].userInfo;
        self.tf_account.text = [t_dic valueForKey:@"account"];
        self.tf_password.text = [t_dic valueForKey:@"password"];
    
    }


}

#pragma mark - private

- (void)initView{
    if (![WXApi isWXAppInstalled]) {
        [_btn_wxLogin setHidden:YES];
    }
    _btn_wxLogin.layer.borderColor = [RGB(148, 219, 148) CGColor];

    [_tf_account addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_tf_password addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}


#pragma mark - buttonAction

- (IBAction)registerAction:(id)sender {
    
    RegisterVC *vc = [[RegisterVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)forgetPasswordAction:(id)sender {
    
    ForgetPasswordVC *vc = [[ForgetPasswordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)loginAction:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    
    NSString* phoneNum=@"^\\s\{1,}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNum];
    
    if (self.tf_account.text.length == 0 || [numberPre evaluateWithObject:self.tf_account.text]) {
        self.tf_account.text = @"";
        
        [ShowHUD showError:@"请输入手机号" configParameter:^(ShowHUD *config) {
            
        } duration:1.5f inView:self.view];
        return;
    }
    
    if (self.tf_password.text.length == 0 || [numberPre evaluateWithObject:self.tf_password.text]) {
        self.tf_password.text = @"";
        
        [ShowHUD showError:@"请输入密码" configParameter:^(ShowHUD *config) {
            
        } duration:1.5f inView:self.view];
        return;
    }
    
    NetworkStatus status = [[Reachability reachabilityWithHostName:@"www.baidu.com"] currentReachabilityStatus];
    
    if (status == NotReachable) {
        
        [ShowHUD showError:@"当前手机无网络" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return ;
        
    }
    
    phoneNum=@"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNum];
    if (![numberPre evaluateWithObject:self.tf_account.text]) {
        [ShowHUD showError:@"手机号码格式出错" configParameter:^(ShowHUD *config) {
        } duration:1.5 inView:self.view];
        return ;
    }
    
    [self.tf_account resignFirstResponder];
    [self.tf_password resignFirstResponder];
    
    ShowHUD *hud = [ShowHUD showText:@"登录中..." configParameter:^(ShowHUD *config) {
    } inView:self.view];
    
    NDUserLoginParams *params = [[NDUserLoginParams alloc] init];
    params.user_name = self.tf_account.text;
    params.password = [self.tf_password.text md5HexDigest];
    
    [NDUserAPI userLoginWithParams:params completionBlockWithSuccess:^(NDUserLoginResult *data) {
        [hud hide];
        
        [ShowHUD showSuccess:NSLocalizedString(@"登录成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.f inView:ApplicationDelegate.window];
        
        [weakSelf todoWhenLoginSuccessed:@([data.user_id longLongValue])];
        
    } Fail:^(int code, NSString *failDescript) {
        
        [hud hide];
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }];
   
}

- (IBAction)wxLoginAction:(id)sender {
    
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"wxlogin" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    
}

#pragma mark - Functions

//登录之后需要做的动作
- (void)todoWhenLoginSuccessed:(NSNumber *)userid
{
    NSMutableDictionary *dictUserInfo = [[NSMutableDictionary alloc]init];
    [dictUserInfo setValue:_tf_account.text forKey:@"account"];
    [dictUserInfo setValue:_tf_password.text forKey:@"password"];
    [[UserDefaultsObject sharedUserDefaultsObject] setUserInfo:dictUserInfo];
    
    
    [ShareValue sharedShareValue].user_id = userid;
    
    [[WebSocketHelper sharedWebSocketHelper] startServer];
    
    [ShareFun clearAllTable];
    
    [GCDQueue executeInGlobalQueue:^{
        [self getUserDetail:[userid stringValue]];
        [self doUserCollect];
    }];
    
    [self uploadJpushId];
    [self juageGroup];
}

/*
 * 请求用户信息
 */

- (void)getUserDetail:(NSString *)id_list{
    
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

/*
 * 更新jpushID
 */

- (void)uploadJpushId{
    
    NSString *jpushid = [ShareValue sharedShareValue].miPushId;
    if (jpushid) {
        NDUserSetJPushIdParams *params = [[NDUserSetJPushIdParams alloc] init];
        params.jpush_id = jpushid;
        [NDUserAPI userSetJPushIdWithParams:params completionBlockWithSuccess:^{
            NSLog(@"JPushID请求或者更新成功");
        } Fail:^(int code, NSString *failDescript) {
            NSLog(@"JPushID请求或者更新失败");
        }];
    }
}

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
            
        }else{
            
            ToyGuideToBindVC * vc = [[ToyGuideToBindVC alloc] init];
            vc.isGuide = YES;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
    
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFCATION_LOGOUT object:nil];
    }];
}

#pragma mark - UITextFieldNotifition

-(void)textFieldDidBeginEditing:(UITextField*)textField{

    if (textField == _tf_account) {
        
        [_imageV_userName setBackgroundColor:UIColorFromRGB(0xff6948)];
        [_imageV_password setBackgroundColor:RGB(151, 151, 151)];
        [_lb_userName setTextColor:[UIColor blackColor]];
        [_lb_password setTextColor:RGB(151, 151, 151)];
        
    }else if (textField == _tf_password) {
       
        [_imageV_password setBackgroundColor:UIColorFromRGB(0xff6948)];
        [_imageV_userName setBackgroundColor:RGB(151, 151, 151)];
        [_lb_userName setTextColor:RGB(151, 151, 151)];
        [_lb_password setTextColor:[UIColor blackColor]];
        
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    [_imageV_userName setBackgroundColor:RGB(151, 151, 151)];
    [_imageV_password setBackgroundColor:RGB(151, 151, 151)];
    [_lb_userName setTextColor:RGB(151, 151, 151)];
    [_lb_password setTextColor:RGB(151, 151, 151)];
}



- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _tf_account) {
        
        if (textField.text.length >= 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }else if (textField == _tf_password) {
        
        if (textField.text.length >= 12) {
            textField.text = [textField.text substringToIndex:12];
        }
    }
}

#pragma mark - notifition 

-(void)setToyInfoSucess:(NSNotification *)note{
    
    [self juageGroup];
    
}


#pragma mark - dealloc

- (void)dealloc{

    NSLog(@"LoginVC dealloc");

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
