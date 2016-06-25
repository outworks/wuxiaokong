//
//  AppVersionVC.m
//  HelloToy
//
//  Created by apple on 15/11/19.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "AppVersionVC.h"
#import "ChooseView.h"
#import "UserDefaultsObject.h"

#import "NDBaseAPI.h"

@interface AppVersionVC ()

@property (weak, nonatomic) IBOutlet UIImageView *image_logo;
@property (weak, nonatomic) IBOutlet UILabel *lbAppName;
@property (weak, nonatomic) IBOutlet UILabel *lbVersion;
@property (weak, nonatomic) IBOutlet UILabel *lb_new;

@property (weak, nonatomic) IBOutlet UILabel *lb_gongsi;
@property (weak, nonatomic) IBOutlet UILabel *lb_gongsiEnglish;

@end

@implementation AppVersionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
    [self initView];
   
}

#pragma mark - init

- (void)initView
{
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(netWorkChange)];
    tapGesture.numberOfTapsRequired = 10;
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)initData
{
    self.title = NSLocalizedString(@"软件版本", nil);
    _lbAppName.text = PROGRAMNAME;
    _lbVersion.text = [NSString stringWithFormat:NSLocalizedString(@"当前版本：%@", nil),[ShareFun getVerison]];
  
}



#pragma mark -
#pragma mark 内外网切换

- (void)netWorkChange{
    
    if ([[ShareValue sharedShareValue].netWork isEqualToNumber:@1]) {
        
        [[ShareValue sharedShareValue] setNetWork:@0];
        UIAlertView *t_alert = [[UIAlertView alloc] initWithTitle:PROGRAMNAME message:@"当前网络切换为内网" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [t_alert show];
        
    }else{
        //切换外网
        [[ShareValue sharedShareValue]  setNetWork:@1];
        UIAlertView *t_alert = [[UIAlertView alloc] initWithTitle:PROGRAMNAME message:@"当前网络切换为外网" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [t_alert show];
        
    }
    
}

#pragma mark - dealloc 

- (void)dealloc{
    
    NSLog(@"AppVersionVC dealloc");
    
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
