//
//  GroupChatDetailVC.m
//  LittleMonkey
//
//  Created by Hcat on 16/6/18.
//  Copyright © 2016年 CivetCatsTeam. All rights reserved.
//

#import "GroupChatDetailVC.h"
#import "VoiceProcess.h"
#import "LK_NSDictionary2Object.h"
#import "NSObject+LKDBHelper.h"
#import "UIScrollView+PullTORefresh.h"
#import "UserDefaultsObject.h"

#import "NDMailAPI.h"
#import "NDGroupAPI.h"

#import "GroupChatMessageCell.h"
#import "GroupChatProgressHUD.h"

#import "GroupInfo2VC.h"

#define PAGESIZE 10

@interface GroupChatDetailVC ()<UITableViewDataSource, UITableViewDelegate, VoiceDelegate,AVAudioPlayerDelegate>{

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn_send;
@property (weak, nonatomic) IBOutlet UIView *v_bottom;

@property (nonatomic,strong) Mail *mail;            //当前播放的语音
@property (nonatomic,strong) NSTimer *speakTime;    //录音倒计时
@property (nonatomic,assign) BOOL isSpeakTimeUp;    //判断录音倒计时是否结束
@property (nonatomic,assign) BOOL isSpeaking;       //判断是否在录音
@property (nonatomic,assign) NSInteger loadflag;    //判断是否是在请求数据
@property (nonatomic,assign) NSInteger readFlag;    //判断是否连续播放
@property (nonatomic,assign) NSTimeInterval touchTime; //点击下去的时间


@property (nonatomic,strong) NSMutableArray *aryData;  // 总数据
@property (nonatomic,strong) NSMutableArray *arySendTime;//记录发送时间的数组

@end

@implementation GroupChatDetailVC

#pragma mark - viewLift

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailReceiveAction:) name:NOTIFICATION_REMOTE_NEWMAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewAction) name:NOTIFCATION_APPBECOME object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBackgroudAction) name:NOTIFCATION_APPBACKGROUND object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBackgroudAction) name:NOTIFCATION_ALERTVIEWSHOW object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadNewAction) name:NOTIFCATION_WEBSOKETRECONNECT object:nil];
    
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = NSLocalizedString(@"我的家", nil);
    
    [_tableView reloadData];
    
    [VoiceProcess shareInstance].delegate = self;
    if (_loadflag == 0) {
        [self loadPageMails_New];
    }
    
    /********** 让tableView显示到底部 ************/
    
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height + CGRectGetHeight(_v_bottom.frame) + 20);
        [self.tableView setContentOffset:offset animated:NO];
    }
    
    [self groupDetailRequest];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[VoiceProcess shareInstance] stopPlay:self.mail];
  
}


#pragma mark - init

- (void)initData
{
    self.aryData        = [NSMutableArray array];
    self.arySendTime    = [NSMutableArray array];

    self.loadflag = 0;
    self.isSpeaking = NO;
    
}


- (void)initView
{
    /*************** 用于隐藏键盘消失用的 ******************/
    
    [self showRightBarButtonItemWithImage:@"btn_toySetting" target:self action:@selector(handleBtnSettingClicked)];
    
    __weak GroupChatDetailVC *weakSelf = self;
    [_tableView addPullScrollingWithActionHandler:^{
        weakSelf.loadflag = 1;
        [weakSelf loadPageMails_History];
    }];
    
}

#pragma mark - APIs

/************** 获取历史数据 **************/

- (void)loadPageMails_History
{
    Mail *minMail = [self.aryData lastObject];
    Mail *flagMail = [Mail getLastFlagMail];
    Mail *nextMail = nil;
    __weak typeof(self) weakself = self;
    if (minMail && [minMail.mail_id isEqual:flagMail.mail_id]) {
        nextMail = [minMail getNextMinMail];//获取相邻的数
        NDMailQueryParams *params = [[NDMailQueryParams alloc]init];
        params.min_time = nextMail.send_time;
        params.max_time = flagMail.send_time;
        [NDMailAPI mailqueryWithParams:params completionBlockWithSuccess:^(NSArray *data) {
            //NSArray *array = (NSArray *)data;
            
            NSMutableArray *array = [NSMutableArray array];
            
            for (Mail *mail in data) {
                if ([mail.mail_type isEqualToNumber:@0]) {
                    [array addObject:mail];
                }
            }
            
            if (array.count == PAGESIZE) {
                Mail *tempMail = array.lastObject;
                tempMail.flag = 1;
            }
            
            minMail.flag = 0;
            flagMail.flag = 0;
            [flagMail save];
            
            for (Mail *_tempMail in array) {
                [_tempMail save];
            }
            [weakself markMails:array];
            
            [_aryData addObjectsFromArray:array];
            
            if (array.count > 0) {
                [weakself.tableView.pullScrollingView stopAnimating];
                
                [[GCDQueue mainQueue] execute:^{
                    [weakself.tableView reloadData];
                    [weakself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:array.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    [weakself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                } afterDelay:(int64_t)(1.5 * NSEC_PER_SEC)];
                
            }else{
                [weakself loadPageMails_History];
            }
            
            weakself.loadflag = 0;
            
        } Fail:^(int code, NSString *failDescript) {
            
            [weakself.tableView.pullScrollingView stopAnimating];
            
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
            
            weakself.loadflag = 0;
            
        }];
        
    } else {
        
        nextMail = flagMail;
        NSArray *localArray = [Mail localArrayFormMin:nextMail.send_time toMax:minMail.send_time pagesize:PAGESIZE];
        [weakself.aryData addObjectsFromArray:localArray];
        Mail *lastMail = _aryData.lastObject;
        if (lastMail.flag == 1) {
            NDMailQueryParams *params = [[NDMailQueryParams alloc]init];
            params.max_time = lastMail.send_time;
            [NDMailAPI mailqueryWithParams:params completionBlockWithSuccess:^(NSArray *data) {
                //NSArray *array = (NSArray *)data;
                
                NSMutableArray *array = [NSMutableArray array];
                
                for (Mail *mail in data) {
                    if ([mail.mail_type isEqualToNumber:@0]) {
                        [array addObject:mail];
                    }
                }
                
                if (array.count == PAGESIZE) {
                    Mail *temp = array.lastObject;
                    temp.flag = 1;
                }
                
                lastMail.flag = 0;
                [lastMail save];
                
                for (Mail *_tmail in array) {
                    [_tmail save];
                }
                [weakself markMails:array];
                
                [weakself.aryData addObjectsFromArray:array];
                
                if (array.count > 0) {
                    [weakself.tableView.pullScrollingView stopAnimating];
                    
                    [[GCDQueue mainQueue] execute:^{
                        [weakself.tableView reloadData];
                        [weakself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:array.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                        [weakself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    } afterDelay:(int64_t)(1.5 * NSEC_PER_SEC)];
                    
                }else {
                    [weakself.tableView.pullScrollingView stopAnimating];
                }
                
                weakself.loadflag = 0;
                
            } Fail:^(int code, NSString *failDescript) {
                [weakself.tableView.pullScrollingView stopAnimating];
                [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:self.view];
                
                weakself.loadflag = 0;
            }];
            
        } else {
            
            [weakself.tableView.pullScrollingView stopAnimating];
            
            if (localArray.count > 0) {
                
                [[GCDQueue mainQueue] execute:^{
                    [weakself.tableView reloadData];
                    [weakself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:localArray.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    [weakself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:localArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    
                } afterDelay:(int64_t)(1.5 * NSEC_PER_SEC)];
                
            }
            
            weakself.loadflag = 0;
        }
        
    }
    
}

/************** 获取最新数据 **************/

- (void)loadPageMails_New
{
    _loadflag = 1;
    
    Mail *lastFlagMail = [Mail getLastFlagMail];
    if (self.aryData.count == 0) {
        NSArray *array = [Mail localArrayFormMin:lastFlagMail.send_time toMax:nil pagesize:PAGESIZE];
        [self.aryData addObjectsFromArray:array];
        [self.tableView reloadData];
    }
    
    __weak typeof(self) weakself = self;
    NDMailQueryParams *params = [[NDMailQueryParams alloc]init];
    if ([self.aryData count] > 0) {
        Mail *mail = self.aryData.firstObject;
        params.min_time = mail.send_time;
        [[UserDefaultsObject sharedUserDefaultsObject] setLasttime_chat:mail.send_time];
    }
    
    [NDMailAPI mailqueryWithParams:params completionBlockWithSuccess:^(NSArray *data) {
       // NSArray *mails = (NSArray *)data;
        
        NSMutableArray *mails = [NSMutableArray array];
        
        for (Mail *mail in data) {
            if ([mail.mail_type isEqualToNumber:@0]) {
                [mails addObject:mail];
            }
        }
    
        if (mails.count > 0) {
            if (mails.count == PAGESIZE) {
                Mail *temp = mails.lastObject;
                temp.flag = 1;
                [weakself.aryData removeAllObjects];
            }
            
            for (Mail *tmail in mails) {
                [tmail save];
            }
            [weakself markMails:mails];
            
            [weakself.aryData insertObjects:mails atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, mails.count)]];
            [weakself.tableView reloadData];
            [weakself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_aryData.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
        }else{
            
        }
        
        _loadflag = 0;
        
    } Fail:^(int code, NSString *failDescript) {
        [weakself.tableView reloadData];
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        _loadflag = 0;
    }];
}



/*******  标记邮件 ********/

- (void)markMails:(NSArray *)mails
{
    NSMutableArray *ids = [NSMutableArray array];
    for (Mail *mail in mails) {
        [ids addObject:mail.mail_id];
    }
    if (ids.count > 0) {
        
        NDMailMarkParams *params = [[NDMailMarkParams alloc]init];
        params.id_list = [ids componentsJoinedByString:@","];
        [NDMailAPI mailMarkWithParams:params completionBlockWithSuccess:^{
            
        } Fail:^(int code, NSString *failDescript) {
            
        }];
    }
}

/************** 查询群信息 **************/

- (void)groupDetailRequest
{
    NDGroupDetailParams *params = [[NDGroupDetailParams alloc] init];
    [NDGroupAPI groupDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        if (data.count != 0) {
            GroupDetail *groupDetail = data[0];
            [groupDetail save];
            _groupDetail = groupDetail;
            [ShareFun enterGroup:groupDetail];
        }
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }];
}

#pragma mark - ButtonActions

/**************** 返回 ****************/

-(void)handleBtnBackClicked{
    
    if (_isSpeaking) {
        return;
    }
    
    [super handleBtnBackClicked];
    
}


/**************** 设置 ****************/

- (void)handleBtnSettingClicked{
    
    if (_isSpeaking) {
        return;
    }
    
    GroupInfo2VC *groupInfoVC = [[GroupInfo2VC alloc] init];
    groupInfoVC.groupDetail = _groupDetail;
    [self.navigationController pushViewController:groupInfoVC animated:YES];
    
}

/**************** 录音按钮下压在按钮动作 ****************/

- (IBAction)onRecordDown:(id)sender {
    //为了防止在录音的时候再按下按钮，导致GroupChatProgressHUD的UI显示出问题
    if (_isSpeaking == NO) {
        [[VoiceProcess shareInstance] stopPlay:self.mail];
        _isSpeaking = YES;
        
        _touchTime = (double)[[NSDate date]timeIntervalSince1970];
        
        [GroupChatProgressHUD show];
        [self imageShowInside:nil];
        
        if ( !_speakTime && _speakTime.isValid == NO) {
            _isSpeakTimeUp = NO;
            _speakTime = [NSTimer scheduledTimerWithTimeInterval:40.f target:self selector:@selector(speakTimeUp) userInfo:nil repeats:NO];
            
        }
        
        [[VoiceProcess shareInstance] startRecord];
        
    }
}

/**************** 录音按钮下压在按钮中状态 ****************/

- (IBAction)imageShowInside:(id)sender {
    
    [GroupChatProgressHUD changeSubTitle:NSLocalizedString(@"手指上滑，取消发送", nil)];
}

/**************** 录音按钮下压在按钮外状态 ****************/

- (IBAction)imageShowOutside:(id)sender {
    
    [GroupChatProgressHUD changeSubTitle:NSLocalizedString(@"松开手指，取消发送", nil)];
    
}

/**************** 录音按钮上抬在按钮中状态 ****************/

- (IBAction)onRecordUp:(id)sender {
    
    if (_speakTime.isValid == YES) {
        [_speakTime invalidate];
        _speakTime = nil;
    }
    
    if (_isSpeakTimeUp == YES) {
        return;
    }
    
    NSTimeInterval curTime = (double)[[NSDate date]timeIntervalSince1970];
    NSTimeInterval sub = curTime - _touchTime;
    
    if (sub < 1.0) {
        [[VoiceProcess shareInstance] stopRecord];
        [GroupChatProgressHUD dismissWithSuccess:NSLocalizedString(@"说话时间太短了", nil)];
    }else{
        [GroupChatProgressHUD dismissWithSuccess:@""];
        [[VoiceProcess shareInstance] performSelector:@selector(stopRecord) withObject:nil afterDelay:0.5];
        [[VoiceProcess shareInstance] performSelector:@selector(uploadVoiceWith:) withObject:[NSNumber numberWithInt:sub] afterDelay:0.8];
    }
    _isSpeaking = NO;
}


/**************** 录音按钮上抬在按钮外状态 ****************/

- (IBAction)onRecordOutSide:(id)sender {
    
    [GroupChatProgressHUD dismissWithError:NSLocalizedString(@"取消", nil)];
    
    if (_speakTime.isValid == YES) {
        [_speakTime invalidate];
        _speakTime = nil;
    }
    
    [[VoiceProcess shareInstance] stopRecord];
    _isSpeaking = NO;
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_aryData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_aryData.count > 0) {
        
        NSArray* reversedArray = [[_aryData reverseObjectEnumerator] allObjects];
        Mail *mail = reversedArray[indexPath.row];
        
        if (mail.mail_type.intValue == 0) {
            
            GroupChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GROUPCHATMESSAGECELL"];
            
            if (!cell) {
                
                [tableView registerNib:[UINib nibWithNibName:@"GroupChatMessageCell" bundle:nil] forCellReuseIdentifier:@"GROUPCHATMESSAGECELL"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"GROUPCHATMESSAGECELL"];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setDelegate:(id<GroupChatMessageCellDelegate> _Nullable)self];
            
    
            if (indexPath.row == 0) {
                
                [_arySendTime addObject:mail.send_time];
                [cell setCellWithData:mail andPioneerMail:nil andSendTimeArray:_arySendTime];
                
            } else {
                
                Mail *pioneerMail = reversedArray[indexPath.row -1];
                [cell setCellWithData:mail andPioneerMail:pioneerMail andSendTimeArray:_arySendTime];
                
            }
            
            //当声音播放完成后会刷新列表，再改变播放的状态
            if (cell.mail.send_id.integerValue == [ShareValue sharedShareValue].user.user_id.integerValue) {
                [cell setCellReadingStatus:self.mail isMyVoice:YES];
            } else {
                [cell setCellReadingStatus:self.mail isMyVoice:NO];
            }
            
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_aryData.count > 0) {
        
        NSArray* reversedArray = [[_aryData reverseObjectEnumerator] allObjects];
        Mail *mail = reversedArray[indexPath.row];
        
        if (mail.mail_type.intValue == 0) {
            
            if (indexPath.row == 0) {
                
                return [GroupChatMessageCell setHeightWithData:mail andPioneerMail:nil andSendTimeArray:_arySendTime];
                
            } else {
                
                Mail *pioneerMail = reversedArray[indexPath.row -1];
                
                return [GroupChatMessageCell setHeightWithData:mail andPioneerMail:pioneerMail andSendTimeArray:_arySendTime];
                
            }
        }
        
        
    }
    
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - Function

//*************** 录音时间到达 *****************//

- (void)speakTimeUp{
    
    [self onRecordUp:nil];
    _isSpeakTimeUp = YES;
}

//*************** 播放一条语音 *****************//

- (void)playOneVoice{
    
    if (self.mail != nil) {
        
        [[VoiceProcess shareInstance] beginPlay:self.mail];
        
    }
}

#pragma mark - GroupChatMessageCellDelegate

/********* 点击播放语音 ************/

- (void)onCellPlayVoiceDidClicked:(GroupChatMessageCell *)cell
{
    if (cell.mail.send_id.integerValue == [ShareValue sharedShareValue].user.user_id.integerValue) {
        [cell setCellReadingStatus:self.mail isMyVoice:YES];
    } else {
        [cell setCellReadingStatus:self.mail isMyVoice:NO];
    }
    if (self.isSpeaking == YES) {
        return ;
    }
    
    if (self.loadflag == 1) {
        return;
    }
    
    if ([self.mail.mail_id isEqualToNumber:cell.mail.mail_id]) {
        
        [[VoiceProcess shareInstance] stopPlay:self.mail];
        
        return;
    }
    
    if (!cell.mail.isRead) {
        self.readFlag = 0;
        cell.mail.isRead = YES;
        [cell.mail save];
    }else{
        self.readFlag = 1;
    }
    
    self.mail = cell.mail;
    [self playOneVoice];
    [self.tableView reloadData];
    
}



#pragma mark - voiceProcessDelegate

- (void)onSendSuccess:(Mail *)mail
{
    if (mail) {
        
        [_tableView beginUpdates];
        [_aryData insertObject:mail atIndex:0];
        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_aryData.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [_tableView endUpdates];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_aryData.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
    
}

- (void)stopPlaySuccess:(Mail *)mail
{
    self.mail = nil;
    [self onPlayingChangePlayMode:NO];
    [self.tableView reloadData];
    
}


- (void)onSendFail:(NSString *)fail
{
    [ShowHUD showError:NSLocalizedString(@"发送失败", nil) configParameter:^(ShowHUD *config) {
    } duration:1.5f inView:self.view];
}


- (void)onPlayFinish
{
    //播放结束后设置听筒和扬声器的状态
    
    [self onPlayingChangePlayMode:NO];
    
    if (_readFlag == 0) {
        
        __weak __typeof(self) weakSelf = self;
        NSArray* reversedArray = [[_aryData reverseObjectEnumerator] allObjects];
        
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
                        if ([weakSelf.mail.mail_type isEqualToNumber:@0]) {
                            *stop = YES;
                        }
                        
                    }
                }
            }
            
        }];
        
        if (!self.mail.isRead) {
            _readFlag = 0;
            self.mail.isRead = YES;
            [self.mail save];
            [self playOneVoice];
            [self.tableView reloadData];
        }else{
            _readFlag = 1;
            self.mail = nil;
            [self.tableView reloadData];
        }
        
    }else{
        self.mail = nil;
        [self.tableView reloadData];
    }
}

- (void)onPlayError{
    
}

/************* 监听听筒or扬声器 *************/


- (void)onPlayingChangePlayMode:(BOOL)state
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:state]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    if(state)//添加监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification"
                                                   object:nil];
    else//移除监听
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
}

#pragma mark -  NSNotificationCenter

- (void)mailReceiveAction:(NSNotification *)note
{
    NSDictionary *t_dic = [note userInfo];
    if (t_dic != nil) {
        Mail *mail = [t_dic objectByClass:[Mail class]];
        
        Mail *mail_t = [Mail searchSingleWithWhere:[NSString stringWithFormat:@"mail_id=%@ and own_id =%@ and group_id =%@",mail.mail_id,[ShareValue sharedShareValue].user.user_id,[ShareValue sharedShareValue].group_id] orderBy:nil];
        if (mail_t) {
            return;
        }
        
        mail.isRead = NO;
        mail.flag = 0;
        [mail save];
        
        NSArray *t_arr = [[NSArray alloc] initWithObjects:mail, nil];
        
        [self markMails:t_arr];
        
        [self.tableView beginUpdates];
        [self.aryData insertObject:mail atIndex:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_aryData.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_aryData.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }
}

- (void)loadNewAction
{
    if (_loadflag == 0) {
        
        [self loadPageMails_New];
        
    }
}

- (void)appBackgroudAction
{
    [[VoiceProcess shareInstance] stopPlay:self.mail];
    if (_isSpeaking) {
        [self onRecordUp:nil];
    }
    
}

/************* 处理监听触发事件 ****************/

-(void)sensorStateChange:(NSNotificationCenter *)notification
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

#pragma mark - dealloc

- (void)dealloc{

    NSLog(@"GroupChatDetailVC dealloc");

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
