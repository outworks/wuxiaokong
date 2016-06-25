//
//  DescVC.m
//  LittleMonkey
//
//  Created by ilikeido on 16/6/25.
//  Copyright © 2016年 CivetCatsTeam. All rights reserved.
//

#import "DescVC.h"

@interface DescVC ()
@property (weak, nonatomic) IBOutlet UILabel *lb_titile;
@property (weak, nonatomic) IBOutlet UITextView *tv_content;

@end

@implementation DescVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助中心";
    // Do any additional setup after loading the view from its nib.
    _lb_titile.text = [_dict objectForKey:@"title"];
    _tv_content.text = [_dict objectForKey:@"content"];
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
