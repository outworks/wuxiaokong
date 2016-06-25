//
//  CodeVC.m
//  LittleMonkey
//
//  Created by huanglurong on 16/5/31.
//  Copyright © 2016年 NDHcat. All rights reserved.
//

#import "CodeVC.h"
#import "NDUserAPI.h"
#import "NDGroupAPI.h"

#import "NSString+md5.h"
#import "UserDefaultsObject.h"

@interface CodeVC ()

@property (weak, nonatomic) IBOutlet UILabel *lb_code;
@property (weak, nonatomic) IBOutlet UITextField *tf_code;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_code;
@property (weak, nonatomic) IBOutlet UIButton *btn_code;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_inputTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_tipTop;

@property (weak, nonatomic) IBOutlet UIView *v_tip;
@property (weak, nonatomic) IBOutlet UILabel *lb_tip;

@property (nonatomic,assign) BOOL isShow;
@property (nonatomic,assign) BOOL isCode;
@property (nonatomic,strong) GCDTimer *timer;

@end

@implementation CodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isCode = NO;
    self.isShow = NO;
    
    self.lb_tip.text  = [NSString stringWithFormat:@"我们已将验证码通过短信发至您的手机%@",self.str_account];
    
    [self.view sendSubviewToBack:self.v_tip];
    _layout_tipTop.constant = -45;
    
    [self.view layoutIfNeeded];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -private

- (void)tipViewShowOrHide:(BOOL)isShow{
    
    if (_isShow == isShow) {
        return;
    }

    _isShow = isShow;
    
    if (isShow) {
    
        
        
        [UIView transitionWithView:self.v_tip duration:1.0 options:0 animations:^{
            
            _layout_tipTop.constant = 0;
            _layout_inputTop.constant = 45;
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
        }];
        
    }else{
    
        [UIView transitionWithView:self.v_tip duration:1.0 options:0 animations:^{
            
            _layout_tipTop.constant = -45;
            _layout_inputTop.constant = 0;
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
        }];
    
    }
    
}

#pragma mark - buttonAction

- (IBAction)btnBackAction:(id)sender {
    
    [self.view endEditing:NO];
    [_timer destroy];
    [_timer dispatchRelease];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)btnCodeAction:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    
    if (weakSelf.isCode) {
        weakSelf.btn_code.enabled = NO;
    }else{
        
        NDUserAuthCodeParams *params = [[NDUserAuthCodeParams alloc] init];
        params.phone = weakSelf.str_account;
        [NDUserAPI userAuthCodeWithParams:params completionBlockWithSuccess:^{
            weakSelf.isCode = YES;
            __block int codeTime = 60;
            weakSelf.timer = [[GCDTimer alloc] initInQueue:[GCDQueue mainQueue]];
            [weakSelf.timer event:^{
                codeTime = codeTime - 1;
                [weakSelf.btn_code setTitle:[NSString stringWithFormat:NSLocalizedString(@"%ds后重新发送", nil),codeTime] forState:UIControlStateNormal];
                
                if (codeTime < 55) {
                    [weakSelf tipViewShowOrHide:NO];
                }else{
                    [weakSelf tipViewShowOrHide:YES];
                }
                if (codeTime == 0) {
                    weakSelf.isCode = NO;
                    weakSelf.btn_code.enabled = YES;
                    [weakSelf.btn_code setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
                    [weakSelf.timer destroy];
                    [weakSelf.timer dispatchRelease];
                }
                
            } timeInterval:1*NSEC_PER_SEC];
            
            [weakSelf.timer start];
            
        } Fail:^(int code, NSString *failDescript) {
            
            [ShowHUD showError:NSLocalizedString(@"获取验证码失败", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:weakSelf.view];
            
        }];
    }
    
}

- (IBAction)btnRegisterAction:(id)sender{

    __weak typeof(self) weakSelf = self;
    
    if (weakSelf.tf_code.text.length == 0) {
        [ShowHUD showError:NSLocalizedString(@"请输入验证码", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5 inView:weakSelf.view];
        return ;
    }
    
    [weakSelf.tf_code resignFirstResponder];

    
    NDUserPhoneRegisterParams *params = [[NDUserPhoneRegisterParams alloc] init];
    params.phone = weakSelf.str_account;
    params.password = [weakSelf.str_password md5HexDigest];
    params.code = weakSelf.tf_code.text;
    
    [NDUserAPI userPhoneRegisterWithParams:params completionBlockWithSuccess:^(NDUserPhoneRegisterResult *data) {
        [ShareValue sharedShareValue].user_id = @([data.user_id longLongValue]);
        NDUserDetailParams *userDetailParams = [[NDUserDetailParams alloc]init];
        [NDUserAPI userDetailWithParams:userDetailParams completionBlockWithSuccess:^(NSArray *data) {
            User *user = data[0];
            [ShareValue sharedShareValue].user = user;
        } Fail:^(int code, NSString *failDescript) {
            NSLog(@"%@",failDescript);
        }];
        [ShowHUD showSuccess:NSLocalizedString(@"注册成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
        
        [self.view endEditing:NO];
        [_timer destroy];
        [_timer dispatchRelease];
        
        NSMutableDictionary *dictUserInfo = [[NSMutableDictionary alloc]init];
        [dictUserInfo setValue:_str_account forKey:@"account"];
        [dictUserInfo setValue:_str_password forKey:@"password"];
        [[UserDefaultsObject sharedUserDefaultsObject] setUserInfo:dictUserInfo];
        
        NSArray *controllers = self.navigationController.viewControllers;
        [self.navigationController popToViewController:[controllers objectAtIndex:1] animated:YES];
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
        
        if (code == 5014 || code == 5015) {
            weakSelf.tf_code.text = @"";
        }
    }];
    
    

}


#pragma mark - UITextFieldNotifition

-(void)textFieldDidBeginEditing:(UITextField*)textField{
    
    if (textField == _tf_code) {
        
        [_imageV_code setBackgroundColor:UIColorFromRGB(0xff6948)];
        [_lb_code setTextColor:[UIColor blackColor]];
    }
        
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [_imageV_code setBackgroundColor:RGB(151, 151, 151)];
    [_lb_code setTextColor:RGB(151, 151, 151)];
    
    
}



- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _tf_code) {
        if (textField.text.length >= 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}


#pragma mark - dealloc

- (void)dealloc{

    [_timer destroy];
    [_timer dispatchRelease];
    _timer = nil;
    
    NSLog(@"CodeVC dealloc");

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
