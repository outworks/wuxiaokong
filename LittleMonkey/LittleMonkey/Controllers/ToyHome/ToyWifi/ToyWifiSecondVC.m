//
//  ToyWifiSecondVC.m
//  LittleMonkey
//
//  Created by Hcat on 16/6/5.
//  Copyright © 2016年 CivetCatsTeam. All rights reserved.
//

#import "ToyWifiSecondVC.h"
#import "ToyWifiThirdVC.h"

@interface ToyWifiSecondVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_tip;



@end

@implementation ToyWifiSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

#pragma mark - private 

- (void)initUI{

    self.imageV_tip.layer.cornerRadius = 220/2;
    self.imageV_tip.layer.borderWidth = 4.f;
    self.imageV_tip.layer.borderColor = [RGB(230, 230, 230) CGColor];
    self.imageV_tip.layer.masksToBounds = YES;


}

#pragma mark - buttonAction

- (IBAction)btnBackAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)btnToNextConfigAction:(id)sender {
    
    ToyWifiThirdVC *vcl = [[ToyWifiThirdVC alloc] init];
    vcl.type = _type;
    vcl.wifiSSID = _wifiSSID;
    vcl.wifiPWD = _wifiPWD;
    [self.navigationController pushViewController:vcl animated:YES];
    
    
}


#pragma mark - dealloc

- (void)dealloc{

    NSLog(@"ToyWifiSecondVC dealloc");

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
