//
//  ForgetPasswordVC.m
//  LittleMonkey
//
//  Created by huanglurong on 16/5/30.
//  Copyright © 2016年 NDHcat. All rights reserved.
//

#import "ForgetPasswordVC.h"

#import "NDUserAPI.h"
#import "NDGroupAPI.h"

#import "NSString+md5.h"

@interface ForgetPasswordVC ()

//账号
@property (weak, nonatomic) IBOutlet UILabel *lb_account;
@property (weak, nonatomic) IBOutlet UITextField *tf_account;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_account;

//验证码
@property (weak, nonatomic) IBOutlet UILabel *lb_code;
@property (weak, nonatomic) IBOutlet UITextField *tf_code;
@property (weak, nonatomic) IBOutlet UIButton *btn_code;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_code;

//密码
@property (weak, nonatomic) IBOutlet UILabel *lb_password;
@property (weak, nonatomic) IBOutlet UITextField *tf_password;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_password;

//确定密码

@property (weak, nonatomic) IBOutlet UILabel *lb_surePw;
@property (weak, nonatomic) IBOutlet UITextField *tf_surePw;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_surePw;

@property (nonatomic,assign) BOOL isCode;
@property (nonatomic,strong) GCDTimer *timer;

@end

@implementation ForgetPasswordVC

#pragma mark - viewLift

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    self.isCode = NO;
    
    [self initView];
    
    
}

#pragma mark - private 

- (void)initView{

    [_tf_account addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_tf_password addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_tf_code addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_tf_surePw addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];


}



#pragma mark - buttonAction

- (IBAction)btnForgetPwAction:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    
    NSString* phoneNum=@"^\\s\{1,}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNum];
    
    if (weakSelf.tf_account.text.length == 0 || [numberPre evaluateWithObject:weakSelf.tf_account.text]) {
        weakSelf.tf_account.text = @"";
        [ShowHUD showError:NSLocalizedString(@"请输入手机号码", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5 inView:weakSelf.view];
        return ;
    }
    
    if (weakSelf.tf_password.text.length == 0 || [numberPre evaluateWithObject:weakSelf.tf_password.text]) {
        weakSelf.tf_password.text = @"";
        [ShowHUD showError:NSLocalizedString(@"请输入密码", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5 inView:weakSelf.view];
        return ;
    }
    
    if (weakSelf.tf_code.text.length == 0) {
        [ShowHUD showError:NSLocalizedString(@"请输入验证码", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5 inView:weakSelf.view];
        return ;
    }
    
    if (weakSelf.tf_surePw.text.length == 0 || [numberPre evaluateWithObject:weakSelf.tf_surePw.text]) {
        weakSelf.tf_surePw.text = @"";
        [ShowHUD showError:NSLocalizedString(@"请输入确认密码", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5 inView:weakSelf.view];
        return ;
    }
    
    if (![weakSelf.tf_surePw.text isEqualToString:weakSelf.tf_password.text]) {
        weakSelf.tf_surePw.text = @"";
        [ShowHUD showError:NSLocalizedString(@"确认密码和密码不一致", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5 inView:weakSelf.view];
        return ;
    }
    
    
    phoneNum=@"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNum];
    if (![numberPre evaluateWithObject:weakSelf.tf_account.text]) {
        
        [ShowHUD showError:NSLocalizedString(@"手机格式出错", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5 inView:weakSelf.view];
        
        return ;
    }
    
    NSString* number=@"^[A-Za-z0-9]{6,12}$";
    numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    if (![numberPre evaluateWithObject:weakSelf.tf_password.text]) {
        [ShowHUD showError:NSLocalizedString(@"密码格式出错", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5 inView:weakSelf.view];
        return ;
    }
    
    
    [weakSelf.tf_account resignFirstResponder];
    [weakSelf.tf_password resignFirstResponder];
    [weakSelf.tf_code resignFirstResponder];
    [weakSelf.tf_surePw resignFirstResponder];
    
    NDUserUpdatePassword2Params *params = [[NDUserUpdatePassword2Params alloc] init];
    params.phone = weakSelf.tf_account.text;
    params.newpasswd = [weakSelf.tf_password.text md5HexDigest];
    params.code = weakSelf.tf_code.text;
    
    [NDUserAPI userUpdatePassword2WithParams:params completionBlockWithSuccess:^{
        
        [ShowHUD showSuccess:NSLocalizedString(@"修改成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
        
        [weakSelf performSelector:@selector(btnBackAction:) withObject:nil afterDelay:1.5f];
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
        
        if (code == 5014 || code == 5015) {
            weakSelf.tf_code.text = @"";
        }
        
    }];
    
    
    
}

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
        if (weakSelf.tf_account.text.length == 0) {
            [ShowHUD showError:NSLocalizedString(@"请输入手机号码", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5 inView:weakSelf.view];
            return ;
        }
        
        NSString  *phoneNum=@"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
        NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNum];
        if (![numberPre evaluateWithObject:weakSelf.tf_account.text]) {
            [ShowHUD showError:NSLocalizedString(@"手机格式出错", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5 inView:weakSelf.view];
            return ;
        }
        
        NDUserAuthCodeParams *params = [[NDUserAuthCodeParams alloc] init];
        params.phone = weakSelf.tf_account.text;
        [NDUserAPI userAuthCodeWithParams:params completionBlockWithSuccess:^{
            weakSelf.isCode = YES;
            __block int codeTime = 60;
            weakSelf.timer = [[GCDTimer alloc] initInQueue:[GCDQueue mainQueue]];
            [weakSelf.timer event:^{
                codeTime = codeTime - 1;
                [weakSelf.btn_code setTitle:[NSString stringWithFormat:NSLocalizedString(@"%ds后重新发送", nil),codeTime] forState:UIControlStateNormal];
                
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


#pragma mark - UITextFieldNotifition

-(void)textFieldDidBeginEditing:(UITextField*)textField{
    
    if (textField == _tf_account) {
        
        [_imageV_account setBackgroundColor:UIColorFromRGB(0xff6948)];
        [_lb_account setTextColor:[UIColor blackColor]];
        
        [_imageV_password setBackgroundColor:RGB(151, 151, 151)];
        [_lb_password setTextColor:RGB(151, 151, 151)];
        
        [_imageV_code setBackgroundColor:RGB(151, 151, 151)];
        [_lb_code setTextColor:RGB(151, 151, 151)];
        
        [_imageV_surePw setBackgroundColor:RGB(151, 151, 151)];
        [_lb_surePw setTextColor:RGB(151, 151, 151)];
        
    }else if (textField == _tf_password) {
        
        [_imageV_password setBackgroundColor:UIColorFromRGB(0xff6948)];
        [_lb_password setTextColor:[UIColor blackColor]];
        
        [_imageV_account setBackgroundColor:RGB(151, 151, 151)];
        [_lb_account setTextColor:RGB(151, 151, 151)];
        
        [_imageV_code setBackgroundColor:RGB(151, 151, 151)];
        [_lb_code setTextColor:RGB(151, 151, 151)];
        
        [_imageV_surePw setBackgroundColor:RGB(151, 151, 151)];
        [_lb_surePw setTextColor:RGB(151, 151, 151)];

    }else if (textField == _tf_code) {
        
        [_imageV_code setBackgroundColor:UIColorFromRGB(0xff6948)];
        [_lb_code setTextColor:[UIColor blackColor]];
        
        [_imageV_account setBackgroundColor:RGB(151, 151, 151)];
        [_lb_account setTextColor:RGB(151, 151, 151)];
        
        [_imageV_password setBackgroundColor:RGB(151, 151, 151)];
        [_lb_password setTextColor:RGB(151, 151, 151)];
        
        [_imageV_surePw setBackgroundColor:RGB(151, 151, 151)];
        [_lb_surePw setTextColor:RGB(151, 151, 151)];
        
    }else if (textField == _tf_surePw) {
        
        [_imageV_surePw setBackgroundColor:UIColorFromRGB(0xff6948)];
        [_lb_surePw setTextColor:[UIColor blackColor]];
        
        [_imageV_account setBackgroundColor:RGB(151, 151, 151)];
        [_lb_account setTextColor:RGB(151, 151, 151)];
        
        [_imageV_code setBackgroundColor:RGB(151, 151, 151)];
        [_lb_code setTextColor:RGB(151, 151, 151)];
        
        [_imageV_password setBackgroundColor:RGB(151, 151, 151)];
        [_lb_password setTextColor:RGB(151, 151, 151)];
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [_imageV_account setBackgroundColor:RGB(151, 151, 151)];
    [_imageV_code setBackgroundColor:RGB(151, 151, 151)];
    [_imageV_password setBackgroundColor:RGB(151, 151, 151)];
    [_imageV_surePw setBackgroundColor:RGB(151, 151, 151)];
    
    [_lb_account setTextColor:RGB(151, 151, 151)];
    [_lb_code setTextColor:RGB(151, 151, 151)];
    [_lb_password setTextColor:RGB(151, 151, 151)];
    [_lb_surePw setTextColor:RGB(151, 151, 151)];
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
    }else if (textField == _tf_surePw) {
        if (textField.text.length >= 12) {
            textField.text = [textField.text substringToIndex:12];
        }
    }else if (textField == _tf_code) {
        if (textField.text.length >= 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}



#pragma mark - dealloc

- (void)dealloc{

    [_timer destroy];
    [_timer dispatchRelease];
    NSLog(@"ForgetPasswordVC dealloc");
    
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
