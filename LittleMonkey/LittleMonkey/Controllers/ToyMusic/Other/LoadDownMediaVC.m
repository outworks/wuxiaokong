//
//  LoadDownMediaVC.m
//  HelloToy
//
//  Created by nd on 15/11/19.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "LoadDownMediaVC.h"
#import "QRCodeVC.h"
#import "AFNetworking.h"
#import "NDAPIShareValue.h"
#import "ShareValue.h"
#import "NDAPIShareValue.h"


@interface LoadDownMediaVC ()<QRCodeVCDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lb_content;

@end

@implementation LoadDownMediaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"上传", nil);
    [_lb_content setText:[NSString stringWithFormat:NSLocalizedString(@"请在电脑上访问 http://%@/user ，扫描网页上的二维码进行登录", nil),ND_SERVERURL_IP]];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - init

#pragma mark - private 

- (IBAction)scanAction:(id)sender {

    QRCodeVC *vc = [[QRCodeVC alloc]init];
    vc.delegate = self;
    vc.content =NSLocalizedString(@"将二维码放入框内，即可自动扫描", nil);
    UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:t_nav animated:YES completion:^{
        
    }];
}


#pragma mark - QRCodeDelegate

-(void)scanReturn:(NSString *)result QRCodeVC:(QRCodeVC *)codeVc{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSString *url = [NSString stringWithFormat:@"%@?user_id=%@&token=%@",result,[[ShareValue sharedShareValue].user_id stringValue],[NDAPIShareValue standardShareValue].token];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        
        [session GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"登录成功", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles: nil];
            [alert show];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"网络不给力", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles: nil];
            [alert show];
            
        }];
        
    }];
}

-(void)scanError{
    
    
    
}

#pragma mark - dealloc

- (void)dealloc{
    
    NSLog(@"LoadDownMediaVC dealloc");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
