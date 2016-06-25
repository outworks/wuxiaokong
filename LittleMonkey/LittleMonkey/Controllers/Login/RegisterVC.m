//
//  RegisterVC.m
//  LittleMonkey
//
//  Created by huanglurong on 16/5/30.
//  Copyright © 2016年 NDHcat. All rights reserved.
//

#import "RegisterVC.h"
#import "Reachability.h"

#import "CodeVC.h"

@interface RegisterVC ()

@property (weak, nonatomic) IBOutlet UILabel *lb_account;
@property (weak, nonatomic) IBOutlet UITextField *tf_account;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_account;

@property (weak, nonatomic) IBOutlet UILabel *lb_password;
@property (weak, nonatomic) IBOutlet UITextField *tf_password;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_password;




@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tf_account addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_tf_password addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}


#pragma mark -buttonAction

- (IBAction)btnRegisterAction:(id)sender {
    
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
    
    CodeVC *vc = [[CodeVC alloc] init];
    vc.str_account = self.tf_account.text;
    vc.str_password = self.tf_password.text;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)btnBackAction:(id)sender {
    
    [self.view endEditing:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - UITextFieldNotifition

-(void)textFieldDidBeginEditing:(UITextField*)textField{
    
    if (textField == _tf_account) {
        
        [_imageV_account setBackgroundColor:UIColorFromRGB(0xff6948)];
        [_imageV_password setBackgroundColor:RGB(151, 151, 151)];
        [_lb_account setTextColor:[UIColor blackColor]];
        [_lb_password setTextColor:RGB(151, 151, 151)];
        
    }else if (textField == _tf_password) {
        
        [_imageV_password setBackgroundColor:UIColorFromRGB(0xff6948)];
        [_imageV_account setBackgroundColor:RGB(151, 151, 151)];
        [_lb_account setTextColor:RGB(151, 151, 151)];
        [_lb_password setTextColor:[UIColor blackColor]];
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [_imageV_account setBackgroundColor:RGB(151, 151, 151)];
    [_imageV_password setBackgroundColor:RGB(151, 151, 151)];
    [_lb_account setTextColor:RGB(151, 151, 151)];
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

#pragma mark -dealloc

- (void)dealloc{

    NSLog(@"RegisterVC dealloc");

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
