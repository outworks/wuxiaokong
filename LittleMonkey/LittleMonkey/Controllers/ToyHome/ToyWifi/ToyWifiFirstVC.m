//
//  ToyWifiFirstVC.m
//  LittleMonkey
//
//  Created by Hcat on 16/6/5.
//  Copyright © 2016年 CivetCatsTeam. All rights reserved.
//

#import "ToyWifiFirstVC.h"

#import "Reachability.h"
#import "EASYLINK.h"

#import "ToyWifiSecondVC.h"

@interface ToyWifiFirstVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_wifi;

@property (weak, nonatomic) IBOutlet UITextField *tf_password;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_wifi;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_password;

@property (weak, nonatomic) IBOutlet UILabel *lb_wifi;
@property (weak, nonatomic) IBOutlet UILabel *lb_password;


@end

@implementation ToyWifiFirstVC


#pragma mark -viewLife

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:NOTIFCATION_APPBECOME object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self initData];
    
}


#pragma mark - private 

- (void)initData{
    
    Reachability *wifiReachability = [Reachability reachabilityForLocalWiFi];  //监测Wi-Fi连接状态
    [wifiReachability startNotifier];
    
    NetworkStatus netStatus = [wifiReachability currentReachabilityStatus];
    if ( netStatus == NotReachable ){// No activity if no wifi
        [ShowHUD showError:NSLocalizedString(@"当前手机无网络", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }else if(netStatus == ReachableViaWWAN){
        [ShowHUD showError:NSLocalizedString(@"手机需要连接WIFI才可以进行配置", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }
    [_tf_wifi setText:[EASYLINK ssidForConnectedNetwork]];
//    [_tf_password setText:@"39816723981672"];
}



#pragma mark - buttonAction

- (IBAction)btnBackAction:(id)sender {
    
    [self.view endEditing:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**************** 下一步 *****************/

- (IBAction)btnToNextAction:(id)sender {
    
    if (self.tf_wifi.text.length == 0) {
        [ShowHUD showError:NSLocalizedString(@"请输入wifi账号", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return;
    }
    
    [self.tf_password resignFirstResponder];
    [self.tf_wifi resignFirstResponder];
    
    NetworkStatus status = [[Reachability reachabilityWithHostName:@"www.baidu.com"] currentReachabilityStatus];
    if (status == NotReachable) {
        [ShowHUD showError:NSLocalizedString(@"当前手机无网络", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return ;
        
    }else if(status == ReachableViaWWAN){
        [ShowHUD showError:NSLocalizedString(@"手机需要连接WIFI才可以进行配置", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return ;
    }
    
    ToyWifiSecondVC *vcl = [[ToyWifiSecondVC alloc] init];
    vcl.type = _type;
    vcl.wifiSSID = _tf_wifi.text;
    vcl.wifiPWD = _tf_password.text;
    [self.navigationController pushViewController:vcl animated:YES];
    
    
}


/**************** 切换wifi *****************/

- (IBAction)btnOtherWiFiAction:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

#pragma mark - UITextFieldNotifition

-(void)textFieldDidBeginEditing:(UITextField*)textField{
    
    if (textField == _tf_wifi) {
        
        [_imageV_wifi setBackgroundColor:UIColorFromRGB(0xff6948)];
        [_imageV_password setBackgroundColor:RGB(151, 151, 151)];
        [_lb_wifi setTextColor:[UIColor blackColor]];
        [_lb_password setTextColor:RGB(151, 151, 151)];
        
    }else if (textField == _tf_password) {
        
        [_imageV_password setBackgroundColor:UIColorFromRGB(0xff6948)];
        [_imageV_wifi setBackgroundColor:RGB(151, 151, 151)];
        [_lb_wifi setTextColor:RGB(151, 151, 151)];
        [_lb_password setTextColor:[UIColor blackColor]];
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [_imageV_wifi setBackgroundColor:RGB(151, 151, 151)];
    [_imageV_password setBackgroundColor:RGB(151, 151, 151)];
    [_lb_wifi setTextColor:RGB(151, 151, 151)];
    [_lb_password setTextColor:RGB(151, 151, 151)];
}



#pragma mark - dealloc

- (void)dealloc{

    NSLog(@"ToyWifiFirstVC alloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
