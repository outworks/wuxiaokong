//
//  GroupChatHomeVC.m
//  LittleMonkey
//
//  Created by Hcat on 16/6/18.
//  Copyright © 2016年 CivetCatsTeam. All rights reserved.
//

#import "GroupChatHomeVC.h"
#import "GroupChatDetailVC.h"
#import "NDMailAPI.h"
#import "UserDefaultsObject.h"

@interface GroupChatHomeVC (){

    int _unreadChatCount;//未读信息数量
}

@end

@implementation GroupChatHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (id)init{

    if (self = [super init]) {
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailReceiveAction:) name:NOTIFICATION_REMOTE_NEWMAIL object:nil];
        [self mailQueryUnreadCountRequest];
    }

    return self;
}

- (void)mailQueryUnreadCountRequest
{
    if (![ShareValue sharedShareValue].groupDetail) {
        _unreadChatCount = 0;
        [ApplicationDelegate reloadTabBar];
    }else{
        NSNumber *lasttime_chat = [[UserDefaultsObject sharedUserDefaultsObject] lasttime_chat];
        NDMailQueryUnreadCountParams *params = [[NDMailQueryUnreadCountParams alloc]init];
        params.min_time = lasttime_chat;
        [NDMailAPI mailQueryUnreadCountWithParams:params completionBlockWithSuccess:^(NDMailQueryUnreadCountResult *data) {
            NSLog(@"%@",data);
            _unreadChatCount = [data.count intValue];
            [ApplicationDelegate reloadTabBar];
        } Fail:^(int code, NSString *failDescript) {
            _unreadChatCount = 0;
            NSLog(@"%@",failDescript);
        }];
    }
}

#pragma mark -  NSNotificationCenter

- (void)mailReceiveAction:(NSNotification *)note
{
    NSDictionary *t_dic = [note userInfo];
    if (t_dic != nil) {
       
        [self mailQueryUnreadCountRequest];
        
    }
}



#pragma mark - AKTabBar Method

// 常态图片名称
- (NSString *)tabImageName{
    
    return @"icon_tab_groupChat";
}

// 点击态图片名称
- (NSString *)tabSelectedImageName{
    
    return @"icon_tab_groupChat_selected";
}

// 标题
- (NSString *)tabTitle{
    return NSLocalizedString(@"聊天", nil);
}

//消息提醒
-(BOOL)showMask{
    return (_unreadChatCount)>0 || ![ShareValue sharedShareValue].groupDetail;
}

- (BOOL)canChangeTab{
    
    GroupChatDetailVC *groupChatDetailVC = [[GroupChatDetailVC alloc]init];
    groupChatDetailVC.groupDetail = [ShareValue sharedShareValue].groupDetail;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:groupChatDetailVC];
    [ApplicationDelegate.tabBarController presentViewController:nav animated:YES completion:^{
            [self mailQueryUnreadCountRequest];
    }];
    
    return NO;
}

#pragma mark - dealloc

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"GroupChatHomeVC dealloc");
    
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
