//
//  ToyMoreVC.m
//  LittleMonkey
//
//  Created by huanglurong on 16/5/25.
//  Copyright © 2016年 NDHcat. All rights reserved.
//

#import "ToyMoreVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "PersonalCenterVC.h"
#import "AppVersionVC.h"
#import "WXApi.h"
#import "ToyChoice.h"
#import "NDUserAPI.h"
#import "NDSystemAPI.h"
#import "MessageListVC.h"
#import "NDGroupAPI.h"
#import "ExplainVC.h"
#import "FeedBackVC.h"

@interface ToyMoreVC ()<ToyChoiceDelegate>{
    
    int _unreadMsgCount;//未读信息数量
}

@property (weak, nonatomic) IBOutlet UIImageView    *imageV_icon;
@property (weak, nonatomic) IBOutlet UILabel        *lb_userName;

@property (nonatomic,strong) ToyChoice *toyChoicView; // 分享界面

@property (weak, nonatomic) IBOutlet UITableView    *tableView;

@property (strong,nonatomic) NSMutableArray         *mArr_data;
@property(nonatomic,strong)  NSMutableArray *pushLogs;
@property(nonatomic,assign) BOOL hasNewRepleat;//是否有新回复
@end

@implementation ToyMoreVC

- (instancetype)init{
    
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveApply:) name:NOTIFICATION_REMOTE_APPLY object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyAction:) name:NOTIFCATION_APPLY_ACTION object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pushLogs =  [NSMutableArray array];
    
    [self initdata];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self initUI];
    self.navigationController.navigationBarHidden = NO;
    [self loadData];
    [self checkRepleat];
    
}

#pragma mark - privateMethods

- (void)initUI{
    
    self.navigationItem.title = @"我的";
    
    [_imageV_icon sd_setImageWithURL:[NSURL URLWithString:[ShareValue sharedShareValue].user.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    _imageV_icon.layer.cornerRadius = 59.f/2;
    _imageV_icon.layer.masksToBounds = YES;
    
    _lb_userName.text = [ShareValue sharedShareValue].user.nickname;
    
}

- (void)initdata{
    
    _unreadMsgCount = 0;
    _mArr_data = [NSMutableArray new];
    
    NSMutableDictionary *t_dic = [[NSMutableDictionary alloc] init];
    [t_dic setValue:@"帮助中心" forKey:@"name"];
    [t_dic setValue:@"icon_helpCenter" forKey:@"icon"];
    
    [_mArr_data addObject:t_dic];
    
    
    t_dic = [[NSMutableDictionary alloc] init];
    [t_dic setValue:@"软件版本" forKey:@"name"];
    [t_dic setValue:@"icon_appUpdate" forKey:@"icon"];
    
    [_mArr_data addObject:t_dic];
    
    t_dic = [[NSMutableDictionary alloc] init];
    [t_dic setValue:@"意见反馈" forKey:@"name"];
    [t_dic setValue:@"icon_faceBack" forKey:@"icon"];
    
    [_mArr_data addObject:t_dic];


    t_dic = [[NSMutableDictionary alloc] init];
    [t_dic setValue:@"消息中心" forKey:@"name"];
    [t_dic setValue:@"icon_tab_groupChat_selected" forKey:@"icon"];
    
    [_mArr_data addObject:t_dic];
    
    t_dic = [[NSMutableDictionary alloc] init];
    [t_dic setValue:@"分享给好友" forKey:@"name"];
    [t_dic setValue:@"icon_shareApp" forKey:@"icon"];
    
    [_mArr_data addObject:t_dic];
    
}

-(void)loadData{
    
    NDUserGetPushLogParams *param = [[NDUserGetPushLogParams alloc]init];
    [NDUserAPI userGetPushLogWithParams:param completionBlockWithSuccess:^(NSArray *data) {
        [_pushLogs removeAllObjects];
        [_tableView reloadData];
        
        _unreadMsgCount = 0;
        
        NSMutableArray *idarray = [ NSMutableArray array];
        int total = 0;
        for (PushLog *log in data) {
            [idarray addObject:log.msg_from];
            if ([log.msg_from isEqualToNumber:@1]) {
                NSLog(@"%@",log.msg_title);
                if ([log.msg_title isEqualToString:@"申请加群"]) {

                   total += log.unread_cnt.integerValue;
                    
                }
        
            }
            
        }
        
        _unreadMsgCount = total;
        
        NDUserDetailParams *params = [[NDUserDetailParams alloc]init];
        params.id_list = [idarray componentsJoinedByString:@","];
        [NDUserAPI userDetailWithParams:params completionBlockWithSuccess:^(NSArray *users) {
            for (int i=0;i<users.count;i++) {
                User *user = [users objectAtIndex:i];
                for (PushLog *log in data) {
                    if ([log.msg_from isEqual:user.user_id]) {
                        log.name = user.nickname;
                        log.iconUrl = [NSURL URLWithString:user.icon];
                    }
                }
            }
            
            [_tableView reloadData];
            
        } Fail:^(int code, NSString *failDescript) {
            
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
                
            } duration:1.5 inView:self.view];
        }];
        
        
        [ApplicationDelegate reloadTabBar];
        [self.pushLogs addObjectsFromArray:data];
        [_tableView reloadData];
        
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }];
}

#pragma mark - API Requests

-(void)juageGroup{
    NDGroupDetailParams *params = [[NDGroupDetailParams alloc] init];
    [NDGroupAPI groupDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        if (data.count != 0) {
            
            GroupDetail *groupDetail = data[0];
            [groupDetail save];
            [ShareFun enterGroup:groupDetail];
        }
        [_tableView reloadData];
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }];
}

-(void)checkRepleat{
    NDSystemCheckReplyParams *params = [[NDSystemCheckReplyParams alloc]init];
    [NDSystemAPI systemCheckReplayWithParams:params completionBlockWithSuccess:^(BOOL hasNews) {
        _hasNewRepleat = hasNews;
        [ApplicationDelegate reloadTabBar];
        [_tableView reloadData];
    } Fail:^(int code, NSString *failDescript) {
        NSLog(@"%@",failDescript);
    }];
}
#pragma mark - Notification

-(void)reciveApply:(NSNotification *)note{
    
    [self loadData];
}

-(void)applyAction:(NSNotification *)note{
    
    NSDictionary *t_dic = [note userInfo];
    
    NSNumber *isAgree = [t_dic objectForKey:@"isAgree"];
    
    if ([isAgree isEqualToNumber:@1]) {
        //同意添加成员
        [self juageGroup];
    }
    [self loadData];
}

#pragma mark -buttonAction

- (IBAction)btnPersonalCenterAction:(id)sender {
    
    PersonalCenterVC *t_vc = [[PersonalCenterVC alloc] init];
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 10;
        
    }else{
        
        return 0;
        
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 3;
        
    } else {
        
        return 2;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToyMoreCell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ToyMoreCell"];
        
        UIImageView *t_imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
        
        [cell.contentView addSubview:t_imageV];
        
        [t_imageV configureForAutoLayout];
        [t_imageV autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [t_imageV autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:10.f];
        
        UIImageView *t_imageV_line = [[UIImageView alloc] init];
        [t_imageV_line setBackgroundColor:RGB(230, 230, 230)];
        [cell.contentView addSubview:t_imageV_line];
        
        [t_imageV_line configureForAutoLayout];
        [t_imageV_line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
        [t_imageV_line autoSetDimension:ALDimensionHeight toSize:1.0f];
        
        UIImageView *t_imagePoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_redpoint"]];
        [t_imagePoint setBackgroundColor:[UIColor clearColor]];
        t_imagePoint.tag = 11;
        [cell.contentView addSubview:t_imagePoint];
        
        [t_imageV_line configureForAutoLayout];
        [t_imagePoint autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:cell.imageView];
        [t_imagePoint autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:cell.imageView];
        [t_imagePoint autoSetDimensionsToSize:CGSizeMake(6, 6)];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.separatorInset = UIEdgeInsetsZero;
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    NSDictionary *t_dic = _mArr_data[indexPath.row];
    
    if (indexPath.section == 1) {
        
        t_dic = _mArr_data[indexPath.row + 3];
        
    }
    
    NSString *str_image = [t_dic objectForKey:@"icon"];
    NSString *str_name  = [t_dic objectForKey:@"name"];
    
    cell.imageView.image = [UIImage imageNamed:str_image];
    cell.textLabel.text  = str_name;
    
    
    UIImageView *t_imagePoint = [cell viewWithTag:11];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        t_imagePoint.hidden = YES;
        
        for (PushLog *log in _pushLogs) {
            
            if ([log.msg_from isEqual:@1]) {
                
                if ([log.msg_title isEqualToString:@"申请加群"]) {
                    
                    t_imagePoint.hidden = ![log.unread_cnt integerValue];
                }
            }
        }
        
    }else{
        
        if (indexPath.row == 3) {
            t_imagePoint.hidden = !_hasNewRepleat;
        }else{
            t_imagePoint.hidden = YES;
        }
        
        
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                ExplainVC *vc = [[ExplainVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1:{
                
                AppVersionVC *vc = [[AppVersionVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
            }
            case 2:{
                
                FeedBackVC *feedBackVC = [[FeedBackVC alloc]init];
                [self.navigationController pushViewController:feedBackVC animated:YES];
                
                break;
            }
                
               
            
            default:
                break;
        }
    }else if (indexPath.section == 1){
        
        switch (indexPath.row) {
            case 0:{
                
                MessageListVC *vc = [[MessageListVC alloc]init];
                vc.msg_from = @1;
                vc.title = @"消息中心";
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
            }
            case 1:{
                
                _toyChoicView = [ToyChoice initCustomView];
                [_toyChoicView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                [_toyChoicView setDelegate:(id<ToyChoiceDelegate>)self];
                [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:_toyChoicView];
                
                NSArray *arr = @[@{@"icon":@"icon_shareWechat.png",@"title":NSLocalizedString(@"分享给好友", nil)},@{@"icon":@"icon_shareFriendCircle.png",@"title":NSLocalizedString(@"分享到朋友圈", nil)}];
                NSMutableArray *t_arr = [NSMutableArray arrayWithArray:arr];
                [_toyChoicView setArr_data:t_arr];
                [_toyChoicView show];
                
                break;
            }
        
            default:
                break;
        }
        
    }
    
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView)
    {
        if (scrollView.contentOffset.y < 0) {
            CGPoint position = CGPointMake(0, 0);
            [scrollView setContentOffset:position animated:NO];
            return;
        }
    }
}
#pragma mark - ToyChoiceDelegate

-(void)checkButtonIndex:(NSInteger)tag{
    
    if (tag == 0) {
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"分享";
        message.description = @"悟小空智能故事机,史上最强的故事机,点我立即了解(必看)";
        [message setThumbImage:[UIImage imageNamed:@"Icon-Spotlight-40"]];
        NSString* url = @"http://hello.99.com";
        
        WXWebpageObject *ext = [WXWebpageObject object];
        
        ext.webpageUrl = url;
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
        
        [WXApi sendReq:req];
        
    }else {
        
        WXMediaMessage *message = [WXMediaMessage message];
        
        message.title =  @"悟小空智能故事机,史上最强的故事机，点我立即了解(必看)";
        message.description = @"悟小空智能故事机,史上最强的故事机，点我立即了解(必看)";
        [message setThumbImage:[UIImage imageNamed:@"Icon-Spotlight-40"]];
        NSString* url = @"http://hello.99.com";
        
        WXWebpageObject *ext = [WXWebpageObject object];
        
        ext.webpageUrl = url;
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
        
        [WXApi sendReq:req];
        
        
    }
    
    [_toyChoicView hide];
    
}



#pragma mark - AKTabBar Method

// 常态图片名称
- (NSString *)tabImageName{
    
    return @"icon_tab_more";
}

// 点击态图片名称
- (NSString *)tabSelectedImageName{
    
    return @"icon_tab_more_selected";
}

// 标题
- (NSString *)tabTitle{
    return NSLocalizedString(@"更多", nil);
}

//消息提醒
-(BOOL)showMask{
    return _unreadMsgCount >0 || ![ShareValue sharedShareValue].groupDetail || _hasNewRepleat;
}

#pragma mark -dealloc

- (void)dealloc{
    
    NSLog(@"ToyMoreVC Dealloc");
    [_toyChoicView removeFromSuperview];
    
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
