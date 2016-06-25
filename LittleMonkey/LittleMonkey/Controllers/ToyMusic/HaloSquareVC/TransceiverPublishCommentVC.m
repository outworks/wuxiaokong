//
//  TransceiverPublishCommentVC.m
//  HelloToy
//
//  Created by yull on 15/12/30.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "TransceiverPublishCommentVC.h"
#import "UITextView+Placeholder.h"
#import "IQKeyboardManager.h"

#import "NDFmAPI.h"

@interface TransceiverPublishCommentVC ()

@end

@implementation TransceiverPublishCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"评论", nil);
    
    self.commentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.commentView.layer.borderWidth = 0.5;
    self.commentView.layer.cornerRadius = 5;
    self.commentView.layer.masksToBounds = YES;
    
    self.commentTextView.placeholder = NSLocalizedString(@"写点评论吧~", nil);
    self.commentTextView.placeholderColor = [UIColor lightGrayColor];
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.frame = CGRectMake(0, 0, 40, 30);
    [rightItemButton setTitleColor:[UIColor colorWithRed:252.0/255.0 green:72.0/255.0 blue:71.0/255.0 alpha:1] forState:UIControlStateNormal];
    [rightItemButton setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(rightItem_action:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
}


- (void)viewWillAppear:(BOOL)animated{

[super viewWillAppear:animated];

 [IQKeyboardManager sharedManager].enable = NO;

}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];

    [IQKeyboardManager sharedManager].enable = YES;

}

- (void)rightItem_action:(id)sender {

    [self.view endEditing:YES];
    __weak typeof(self) weakself = self;
    NDFmCommentParams *params = [[NDFmCommentParams alloc] init];
    params.media_id = self.fmDetail.media_id;
    params.content = self.commentTextView.text;
    [NDFmAPI fmCommentWithParams:params CompletionBlockWithSuccess:^(id data) {
        [ShowHUD showSuccess:NSLocalizedString(@"保存成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
        if (self.saveCompleteHandler) {
            self.saveCompleteHandler();
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.navigationController popViewControllerAnimated:YES];
        });
        
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
    }];
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
