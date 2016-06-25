//
//  MailCollectedDetailVC.m
//  HelloToy
//
//  Created by nd on 15/12/3.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "MailCollectedDetailVC.h"
#import "NDMailAPI.h"
#import "GroupChatMessageCell.h"
#import "VoiceProcess.h"
#import "UIScrollView+PullTORefresh.h"


@interface MailCollectedDetailVC ()<UITableViewDataSource, UITableViewDelegate, GroupChatMessageCellDelegate,VoiceDelegate,AVAudioPlayerDelegate>{
    ShowHUD *_hud;
}

@property (nonatomic,strong) NSMutableArray *mArr_data;     // 总数据
@property (nonatomic,strong) NSMutableArray *arySendTime;   // 总的发送时间
@property (nonatomic,strong) Mail *mail;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL isLastPage;

@end

@implementation MailCollectedDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mArr_data      = [NSMutableArray array];
    _arySendTime    = [NSMutableArray array];
    _page           = 1;
    _isLastPage     = NO;
    
    
    if (_isContact) {
        
        self.navigationItem.title = NSLocalizedString(@"ChatRecord", nil);
        
        __weak MailCollectedDetailVC *weakSelf = self;
        [self.tableView addPullScrollingWithActionHandler:^{
            
            [weakSelf loadContactHistory];
        }];
        
        [self.tableView triggerPullScrolling];
        
    }else{
        
        self.navigationItem.title = _fav.desc;
        
        [self loadFavMailDetail:_fav.fav_id];
    
    }
   
    
    
    // Do any additional setup after loading the view from its nib.
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [_tableView reloadData];
    [VoiceProcess shareInstance].delegate = self;
    
}

#pragma mark - private methods

- (void)loadFavMailDetail:(NSNumber *)fav_id{
    
    __weak typeof(*& self) weakSelf = self;
    
    NDMailFavGetParams *params = [[NDMailFavGetParams alloc] init];
    params.fav_id = fav_id;
    
    _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
    } inView:ApplicationDelegate.window];
    
    [NDMailAPI mailFavGetWithParams:params completionBlockWithSuccess:^(NDMailFavGetResult *data) {
        
        if (_hud) [_hud hide];
        
        
        
        NSArray *resultArray = [data.fav.mails sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            Mail *mail_first = (Mail *)obj1;
            Mail *mail_second = (Mail *)obj2;
            
            NSNumber *number1 = mail_first.send_time;
            NSNumber *number2 =mail_second.send_time;
            
            NSComparisonResult result = [number1 compare:number2];
            
            return result == NSOrderedAscending; // 降序
            //        return result == NSOrderedAscending ;  //升序
        }];
        
        
        [weakSelf.mArr_data  addObjectsFromArray:resultArray];
        
        [weakSelf.tableView reloadData];
        
        
    } Fail:^(int code, NSString *failDescript) {
        
        if (_hud) [_hud hide];
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.0f inView:ApplicationDelegate.window];
        
    }];
    
}

- (void)loadContactHistory{
    
    __weak typeof(self) weakSelf = self;
    
    _tableView.showsPullScrolling = !_isLastPage;

    NDToyGmailListParams *params = [[NDToyGmailListParams alloc] init];
    if (_toyId) {
        params.toy_id = _toyId;
    }else {
       params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    }
    params.target_id = _contactGmail.toy_id;
    params.page = _page;
    params.rows = 20;
    
    [NDToyAPI toyGmailListWithParams:params completionBlockWithSuccess:^(NDToyGmailListResult *data) {
        
        [weakSelf.tableView.pullScrollingView stopAnimating];
        
        if ([data.gmailList count] < 20) {
            
            weakSelf.isLastPage = YES;
            
        }
        
        NSMutableArray *t_mArr = [NSMutableArray array];
        
        for (int i = 0 ; i < [data.gmailList count] ; i++) {
            
            Mail *t_mail = [[Mail alloc] init];
            Gmail *t_Gmail = data.gmailList[i];
            t_mail.mail_id = t_Gmail.mail_id;
            t_mail.send_id = t_Gmail.from_id;
            t_mail.url = t_Gmail.url;
            t_mail.duration = t_Gmail.duration;
            t_mail.send_time = t_Gmail.time;
            t_mail.isRead = YES;
            [t_mArr addObject:t_mail];
            
        }
        
        NSArray *resultArray = [t_mArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            Mail *mail_first = (Mail *)obj1;
            Mail *mail_second = (Mail *)obj2;
            
            NSNumber *number1 = mail_first.send_time;
            NSNumber *number2 =mail_second.send_time;
            
            NSComparisonResult result = [number1 compare:number2];
            
            return result == NSOrderedAscending; // 降序
            //        return result == NSOrderedAscending ;  //升序
        }];

        [weakSelf.mArr_data addObjectsFromArray:resultArray];
        
        weakSelf.tableView.showsPullScrolling = !_isLastPage;
        [weakSelf.tableView reloadData];
        
        weakSelf.page ++;
        
    } Fail:^(int code, NSString *failDescript) {
        
        [weakSelf.tableView.pullScrollingView stopAnimating];
        [weakSelf.tableView reloadData];
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }];
    

}

//读邮件
- (void)playOneVoice{
    
    if (self.mail != nil) {
        
        [[VoiceProcess shareInstance] beginPlay:self.mail];
        
    }
}


#pragma mark - Button Action

- (IBAction)handleBtnContinuousPlayClicked{

    if ([_mArr_data count] > 0) {
        
        self.mail = _mArr_data.lastObject;
        [self playOneVoice];
        [self.tableView reloadData];
        
    }

}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mArr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GROUPCHATMESSAGECELL"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"GroupChatMessageCell" bundle:nil] forCellReuseIdentifier:@"GROUPCHATMESSAGECELL"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"GROUPCHATMESSAGECELL"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDelegate:(id<GroupChatMessageCellDelegate> _Nullable)self];
    

    if (_mArr_data.count > 0) {
        
        NSArray* reversedArray = [[_mArr_data reverseObjectEnumerator] allObjects];
        Mail *mail = reversedArray[indexPath.row];
        if (indexPath.row == 0) {
            
            [_arySendTime addObject:mail.send_time];
            if (_isContact) {
                [cell setCellToyWithData:mail andPioneerMail:nil andSendTimeArray:_arySendTime];
            }else{
                [cell setCellWithData:mail andPioneerMail:nil andSendTimeArray:_arySendTime];
            }
            
            
        } else {
            
            Mail *pioneerMail = reversedArray[indexPath.row -1];
            if (_isContact) {
                [cell setCellToyWithData:mail andPioneerMail:pioneerMail andSendTimeArray:_arySendTime];
            }else{
                [cell setCellWithData:mail andPioneerMail:pioneerMail andSendTimeArray:_arySendTime];
            }
        }
        
        //当声音播放完成后会刷新列表，再改变播放的状态
        
        if (_isContact) {
            if (cell.mail.send_id.integerValue == [ShareValue sharedShareValue].toyDetail.toy_id.integerValue) {
                [cell setCellReadingStatus:self.mail isMyVoice:YES];
            } else {
                [cell setCellReadingStatus:self.mail isMyVoice:NO];
            }
        }else{
            if (cell.mail.send_id.integerValue == [ShareValue sharedShareValue].user.user_id.integerValue) {
                [cell setCellReadingStatus:self.mail isMyVoice:YES];
            } else {
                [cell setCellReadingStatus:self.mail isMyVoice:NO];
            }
        }
        
        if (_isContact) {
            [cell setToyIcon:_contactGmail.icon withNickName:_contactGmail.nickname];
        }
        
        
    }
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_mArr_data.count > 0) {
        NSArray* reversedArray = [[_mArr_data reverseObjectEnumerator] allObjects];
        Mail *mail = reversedArray[indexPath.row];
        if (indexPath.row == 0) {
            return [GroupChatMessageCell setHeightWithData:mail andPioneerMail:nil andSendTimeArray:_arySendTime];
        } else {
            Mail *pioneerMail = reversedArray[indexPath.row -1];
            return [GroupChatMessageCell setHeightWithData:mail andPioneerMail:pioneerMail andSendTimeArray:_arySendTime];
            
        }
    } else {
        return 0;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}


#pragma mark - GroupChatMessageCellDelegate

- (void)onCellPlayVoiceDidClicked:(GroupChatMessageCell *)cell
{
    
    if (_isContact) {
        if (cell.mail.send_id.integerValue == [ShareValue sharedShareValue].toyDetail.toy_id.integerValue) {
            [cell setCellReadingStatus:self.mail isMyVoice:YES];
        } else {
            [cell setCellReadingStatus:self.mail isMyVoice:NO];
        }
    }else{
        if (cell.mail.send_id.integerValue == [ShareValue sharedShareValue].user.user_id.integerValue) {
            [cell setCellReadingStatus:self.mail isMyVoice:YES];
        } else {
            [cell setCellReadingStatus:self.mail isMyVoice:NO];
        }
    }
    
    if ([self.mail.mail_id isEqualToNumber:cell.mail.mail_id]) {
        
        [[VoiceProcess shareInstance] stopPlay:self.mail];
        
        return;
    }
    
    self.mail = cell.mail;
    [self playOneVoice];
    [self.tableView reloadData];
    
}

#pragma mark - voiceProcessDelegate

- (void)stopPlaySuccess:(Mail *)mail
{
    self.mail = nil;
    [self.tableView reloadData];
    
}

- (void)onPlayFinish
{
    __weak __typeof(self) weakSelf = self;
    NSArray* reversedArray = [[_mArr_data reverseObjectEnumerator] allObjects];
    [reversedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Mail *t_mail = (Mail *)obj;
        if (weakSelf.mail) {
            if ([t_mail.mail_id isEqualToNumber:weakSelf.mail.mail_id]) {
                if(idx == [reversedArray count]-1){
                    weakSelf.mail = nil;
                    [weakSelf.tableView reloadData];
                    *stop = YES;
                    return ;
                }else if(idx < [reversedArray count]-1){
                    weakSelf.mail = reversedArray[idx +1];
                    *stop = YES;
                }
            }
        }
        
    }];
    
    [self playOneVoice];
    [self.tableView reloadData];

}

- (void)onPlayError{
    
}



#pragma mark - dealloc

- (void)dealloc{
    
    if (self.mail) {
        [[VoiceProcess shareInstance] stopPlay:self.mail];
    }
    
    [VoiceProcess shareInstance].delegate = nil;
    
    NSLog(@"MailCollectedDetailVC dealloc");

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
