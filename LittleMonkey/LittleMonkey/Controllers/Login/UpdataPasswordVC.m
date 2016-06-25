//
//  UpdataPasswordVC.m
//  LittleMonkey
//
//  Created by huanglurong on 16/5/31.
//  Copyright © 2016年 NDHcat. All rights reserved.
//

#import "UpdataPasswordVC.h"
#import "NDUserAPI.h"
#import "UserDefaultsObject.h"

@interface UpdataPasswordVC ()

@property (weak, nonatomic) IBOutlet UILabel *lb_oldPw;
@property (weak, nonatomic) IBOutlet UITextField *tf_oldPw;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_oldPw;

@property (weak, nonatomic) IBOutlet UILabel *lb_newPw;
@property (weak, nonatomic) IBOutlet UITextField *tf_newPw;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_newPw;


@end

@implementation UpdataPasswordVC

#pragma mark - viewLift

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setDelegate:(id<UINavigationControllerDelegate> _Nullable)self];
    // Do any additional setup after loading the view from its nib.
}





#pragma mark - buttonAction

- (IBAction)btnBackAction:(id)sender {
    
    [self.view endEditing:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)btnUpdataPasswordAction:(id)sender{
    
    __weak typeof(self) weakSelf = self;
    
    NSString* phoneNum=@"^\\s\{1,}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNum];
    
    if (self.tf_oldPw.text.length == 0 || [numberPre evaluateWithObject:self.tf_oldPw.text]) {
        self.tf_oldPw.text = @"";
        
        [ShowHUD showError:@"请输入当前密码" configParameter:^(ShowHUD *config) {
            
        } duration:1.5f inView:self.view];
        return;
    }
    
    if (self.tf_newPw.text.length == 0 || [numberPre evaluateWithObject:self.tf_newPw.text]) {
        self.tf_newPw.text = @"";
        
        [ShowHUD showError:@"请输入新密码" configParameter:^(ShowHUD *config) {
            
        } duration:1.5f inView:self.view];
        return;
    }
    
    [_tf_newPw resignFirstResponder];
    [_tf_oldPw resignFirstResponder];
    
    NDUserUpdatePasswordParams *params = [[NDUserUpdatePasswordParams alloc] init];
    params.oldpasswd = _tf_oldPw.text;
    params.newpasswd = _tf_newPw.text;
    
    [NDUserAPI userUpdatePasswordWithParams:params completionBlockWithSuccess:^{
        
        [ShowHUD showSuccess:@"修改成功" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        if ([UserDefaultsObject sharedUserDefaultsObject].userInfo) {
            
            NSMutableDictionary *t_dic = (NSMutableDictionary *)[UserDefaultsObject sharedUserDefaultsObject].userInfo;
            [t_dic setValue:_tf_newPw.text forKey:@"password"];
        }

        [[GCDQueue mainQueue] execute:^{
    
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        } afterDelay:1.5f * NSEC_PER_SEC];
    
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }];

}

#pragma mark - UITextFieldNotifition

-(void)textFieldDidBeginEditing:(UITextField*)textField{
    
    if (textField == _tf_oldPw) {
        
        [_imageV_oldPw setBackgroundColor:UIColorFromRGB(0xff6948)];
        [_lb_oldPw setTextColor:[UIColor blackColor]];
        [_imageV_newPw setBackgroundColor:RGB(151, 151, 151)];
        [_lb_newPw setTextColor:RGB(151, 151, 151)];
        
    }else if (textField == _tf_newPw) {
        
        [_imageV_newPw setBackgroundColor:UIColorFromRGB(0xff6948)];
        [_lb_newPw setTextColor:[UIColor blackColor]];
        [_imageV_oldPw setBackgroundColor:RGB(151, 151, 151)];
        [_lb_oldPw setTextColor:RGB(151, 151, 151)];
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [_imageV_newPw setBackgroundColor:RGB(151, 151, 151)];
    [_imageV_oldPw setBackgroundColor:RGB(151, 151, 151)];
    [_lb_newPw setTextColor:RGB(151, 151, 151)];
    [_lb_oldPw setTextColor:RGB(151, 151, 151)];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _tf_oldPw) {
        
        if (textField.text.length >= 12) {
            textField.text = [textField.text substringToIndex:11];
        }
    }else if (textField == _tf_newPw) {
        
        if (textField.text.length >= 12) {
            textField.text = [textField.text substringToIndex:12];
        }
    }
}

#pragma mark - navigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[self class]]) {
        self.navigationController.navigationBarHidden = YES;
    }
}

#pragma mark -dealloc

- (void)dealloc{

    NSLog(@"UpdataPasswordVC dealloc");
    [self.navigationController setDelegate:nil];

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
