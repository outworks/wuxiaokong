//
//  GroupCodeVC.m
//  HelloToy
//
//  Created by huanglurong on 16/6/1.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "GroupCodeVC.h"
#import "QRCodeGenerator.h"
#import "UIImageView+WebCache.h"

@interface GroupCodeVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;

@property (weak, nonatomic) IBOutlet UILabel *lb_name;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_code;



@end

@implementation GroupCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群二维码";
    
    _lb_name.text = _groupDetail.name;
    
    [_imageV_icon sd_setImageWithURL:[NSURL URLWithString:_groupDetail.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
    _imageV_icon.layer.cornerRadius = 50/2;
    _imageV_icon.layer.masksToBounds = YES;
    
    _imageV_code.image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"group:%d",[_groupDetail.group_id intValue]] imageSize:_imageV_code.bounds.size.width];
    _imageV_icon.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view from its nib.
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
