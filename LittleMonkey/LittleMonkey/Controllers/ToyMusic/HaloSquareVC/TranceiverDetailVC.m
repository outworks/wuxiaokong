//
//  TranceiverDetailVC.m
//  HelloToy
//
//  Created by yull on 15/12/30.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "TranceiverDetailVC.h"
#import "TransceiverDetailCell.h"
#import "TransceiverCommentListVC.h"
#import "UIImageView+WebCache.h"
#import "LK_NSDictionary2Object.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import <BlocksKit/UIControl+BlocksKit.h>
#import "AFSoundManager.h"
#import "NDFmAPI.h"
#import <MediaPlayer/MediaPlayer.h>  
#import "TranceiverDescriptVC.h"
#import "SubscibeTimeCell.h"

@interface TranceiverDetailVC ()<TransceiverDetailCellDelegate,SubscibeTimeCellDelegate>

@property (nonatomic, strong) NSMutableArray *recordList;

@property (nonatomic, assign) unsigned long page;

@property (nonatomic, strong) FMDetail *playingFMDetail;

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

@property (nonatomic, strong) UIButton *btnSubscibe;

@property (nonatomic,strong) NSMutableArray *marr_toySubscribe;

@property (nonatomic,strong) NSMutableArray *arySubscibeTime;
@property (weak, nonatomic) IBOutlet UITableView *subscibeTableView;
@property (strong, nonatomic) IBOutlet UIView *vSubscibe;
@property (strong, nonatomic) NSString *selectedTimeString;//订阅的时间

- (IBAction)handleHiddenViewDidClick:(id)sender;
- (IBAction)handleCancelDidClick:(id)sender;
- (IBAction)handleSaveDidClick:(id)sender;


@end

@implementation TranceiverDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadToyData) name:NOTIFICATION_REMOTE_QUIT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadToyData) name:NOTIFICATION_REMOTE_ENTER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadToyData) name:NOTIFICATION_REMOTE_DISMISS object:nil];
    
    self.marr_toySubscribe = [NSMutableArray array];
    self.arySubscibeTime = [self resetInitSubscibeTime];
    _selectedTimeString = @"06 : 00";
    
    self.navigationItem.title = NSLocalizedString(@"电台", nil);

    _btnSubscibe = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSubscibe.frame = CGRectMake(0, 0, 70, 30);
    [_btnSubscibe setTitle:NSLocalizedString(@"+ 订阅电台", nil) forState:UIControlStateNormal];
    _btnSubscibe.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [_btnSubscibe addTarget:self action:@selector(handleSubscibeDidClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItemButton = [[UIBarButtonItem alloc]initWithCustomView:_btnSubscibe];
    self.navigationItem.rightBarButtonItem = rightItemButton;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TransceiverDetailCell" bundle:nil] forCellReuseIdentifier:@"TransceiverDetailCell"];
    self.tableView.rowHeight = 66;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.page = 1;
    [self.albumIV sd_setImageWithURL:[NSURL URLWithString:self.fm.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
    self.albumNameL.text = self.fm.name;
    self.albumDescL.text = self.fm.desc;
    self.recordList = [NSMutableArray array];
    [self loadToyData];
    __weak typeof(self) wself = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [wself loadData];
    }];
    [self.tableView triggerInfiniteScrolling];
    
    //设置vSubscibe初始frame
    _vSubscibe.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [ApplicationDelegate.window addSubview:_vSubscibe];

}

-(void)loadToyData{
    
    __weak typeof(*& self) weakSelf = self;
    
    GCDGroup *group = [GCDGroup new];
    if ([ShareValue sharedShareValue].toyDetail) {
        
        [[GCDQueue globalQueue] execute:^{
            
            [weakSelf loadFmDetailData];
            
        } inGroup:group];
    }
    
    if ([ShareValue sharedShareValue].toyDetail) {
        
        [[GCDQueue globalQueue] execute:^{
            
            [weakSelf loadToySubscribeData];
            
        } inGroup:group];
    }
    
//    [[GCDQueue globalQueue] execute:^{
//        
//        [self loadData];
//        
//    } inGroup:group];
    
    [[GCDQueue mainQueue] notify:^{
        
        [weakSelf reloadBtnState];
        
    } inGroup:group];
    
}

-(void)loadFmDetailData{
    GCDSemaphore *semaphore = [GCDSemaphore new];
    NDFmQueryParams *params = [[NDFmQueryParams alloc]init];
    params.fm_id = self.fm.fm_id;
    [NDFmAPI fmQueryWithParams:params CompletionBlockWithSuccess:^(NSArray *data) {
        if (data.count > 0) {
            FM *fmDetail = data[0];
            _fm.desc = fmDetail.desc;
        }
        [semaphore signal];
    } Fail:^(int code, NSString *failDescript) {
        
        [semaphore signal];
    }];
     [semaphore wait];
}


- (void)loadData {
//    GCDSemaphore *semaphore = [GCDSemaphore new];
    __weak typeof(self) weakself = self;
    NDFmDetailParams *params = [[NDFmDetailParams alloc] init];
    params.fm_id = self.fm.fm_id;
    params.page = @(self.page);
    [NDFmAPI fmDetailWithParams:params CompletionBlockWithSuccess:^(id data) {
        
        unsigned long count = [[data objectForKey:@"count"] integerValue];
        weakself.countL.text = [NSString stringWithFormat:NSLocalizedString(@"共%ld集", nil), count];
        
        NSArray *array = [data objectForKey:@"contents"];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakself.recordList addObject:[obj objectByClass:[FMDetail class]]];
        }];
        [weakself.tableView.infiniteScrollingView stopAnimating];
        [weakself.tableView reloadData];
        
        if (weakself.recordList.count >= count) {
            weakself.tableView.showsInfiniteScrolling = NO;
        }else{
            _page ++;
        }
//        [semaphore signal];
    } Fail:^(int code, NSString *failDescript) {
//        _page --;
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
//        [semaphore signal];
    }];
//     [semaphore wait];
}

- (void)loadToySubscribeData{
    
    __weak typeof(*& self) weakSelf = self;
    GCDSemaphore *semaphore = [GCDSemaphore new];
    
    NDFmQuerySubParams *params = [[NDFmQuerySubParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    [NDFmAPI fmQuerySubWithParams:params CompletionBlockWithSuccess:^(NSArray *data) {
        
        if (data && [data count] > 0) {
            
            if ([weakSelf.marr_toySubscribe count] > 0) {
                
                [weakSelf.marr_toySubscribe removeAllObjects];
                
            }
            
            [weakSelf.marr_toySubscribe addObjectsFromArray:data];
        }
        
        [semaphore signal];
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
        [semaphore signal];
    }];
    [semaphore wait];
    
}

- (void)reloadBtnState{
    _albumDescL.text = [NSString stringWithFormat:@"%@",_fm.desc];
    [_btnSubscibe removeTarget:self action:@selector(handleSubscibeDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnSubscibe removeTarget:self action:@selector(handleCancelSubscribeDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_marr_toySubscribe count] == 0) {
        [_btnSubscibe setSelected:NO];
        [_btnSubscibe addTarget:self action:@selector(handleSubscibeDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnSubscibe setTitle:NSLocalizedString(@"+ 订阅电台", nil) forState:UIControlStateNormal];
        _albumNameL.text = [NSString stringWithFormat:@"%@",_fm.name];
    }
    
    for (int i = 0 ; i < [_marr_toySubscribe count] ; i ++) {
        
        FM *fm = _marr_toySubscribe[i];
        
        if (_fm && [fm.fm_id isEqualToNumber:_fm.fm_id]) {
            [_btnSubscibe setSelected:YES];
            [_btnSubscibe addTarget:self action:@selector(handleCancelSubscribeDidClick:) forControlEvents:UIControlEventTouchUpInside];
            [_btnSubscibe setTitle:NSLocalizedString(@"取消订阅", nil) forState:UIControlStateNormal];
            _albumNameL.text = [NSString stringWithFormat:@"%@(播放时间：%@)",_fm.name,[self timeStringFromTime:[fm.play_time intValue]]];
            break;
        }
        
        if (i == [_marr_toySubscribe count] - 1) {
            [_btnSubscibe setSelected:NO];
            [_btnSubscibe addTarget:self action:@selector(handleSubscibeDidClick:) forControlEvents:UIControlEventTouchUpInside];
            [_btnSubscibe setTitle:NSLocalizedString(@"+ 订阅电台", nil) forState:UIControlStateNormal];
            _albumNameL.text = [NSString stringWithFormat:@"%@",_fm.name];
        }
    }
    
}

-(NSString *)playTimeString:(NSInteger)playTime{
    if (playTime > 0) {
        
    }
    return @"";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        return self.recordList.count;
    } else {
        return _arySubscibeTime.count/3;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        TransceiverDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransceiverDetailCell" forIndexPath:indexPath];
        cell.delegate = self;
        FMDetail *fmDetail = self.recordList[indexPath.row];
        cell.fmDetail = fmDetail;
        [cell setPlaying:(self.playingFMDetail == cell.fmDetail)];
        return cell;
    } else {
        SubscibeTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SUBSCIBETIMECELL"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"SubscibeTimeCell" bundle:nil] forCellReuseIdentifier:@"SUBSCIBETIMECELL"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"SUBSCIBETIMECELL"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.delegate = self;
        [cell resetCellData:_arySubscibeTime andRow:(int)indexPath.row andSelectedTime:_selectedTimeString];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _tableView) {
        TransceiverCommentListVC *controller = [[TransceiverCommentListVC alloc] init];
        controller.fmDetail = self.recordList[indexPath.row];
        controller.favCompleteHandler = ^{
            [self.tableView reloadData];
        };
        controller.RefreshCommentHandler = ^{
            [self.tableView reloadData];
        };
        controller.isPlaying = [controller.fmDetail isEqual:self.playingFMDetail];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

#pragma mark - Fuction

//初始化订阅时间的数组
- (NSMutableArray *)resetInitSubscibeTime
{
    NSMutableArray *timeMuArray = [NSMutableArray array];
    int hour = 6,minute = 30;
    for (; hour <= 22; hour++) {
        if (minute == 0) {
            minute = 30;
            hour--;
        } else {
            minute = 0;
        }
        NSString *time = nil;
        if (hour < 10) {
            if (minute == 0) {
                time = [NSString stringWithFormat:@"0%d : 0%d",hour,minute];
            } else {
                time = [NSString stringWithFormat:@"0%d : %d",hour,minute];
            }
        } else {
            if (minute == 0) {
                time = [NSString stringWithFormat:@"%d : 0%d",hour,minute];
            } else {
                time = [NSString stringWithFormat:@"%d : %d",hour,minute];
            }
        }
        [timeMuArray addObject:time];
    }
    return timeMuArray;
}

//通过时间获取小时、分钟并转为数值
- (NSNumber *)transNumberFromSelectedTime:(NSString *)time
{
    int hour = [[time substringWithRange:NSMakeRange(0, 2)]intValue];
    int minute = [[time substringWithRange:NSMakeRange(5, 2)]intValue];
    int second = hour * 3600 + minute * 60;
    return @(second);
    
}

//通过秒数获取时间字符串
-(NSString *)timeStringFromTime:(int)time{
    int hour = time / 3600;
    int minute = (time % 3600)/60;
    NSString *timeString = [NSString stringWithFormat:@"%02d:%02d",hour,minute];
    return timeString;
}

#pragma mark - TransceiverDetailCellDelegate

-(void)playFm:(TransceiverDetailCell *)cell{
    __weak typeof(self) weakSelf = self;
    if (self.playingFMDetail == cell.fmDetail) {
        self.playingFMDetail = nil;
        [[AFSoundManager sharedManager] stop];
        [weakSelf.tableView reloadData];
    }else{
        self.playingFMDetail = cell.fmDetail;
        [[AFSoundManager sharedManager] startStreamingRemoteAudioFromURL:cell.fmDetail.url andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
            if (!error) {
                [weakSelf.tableView reloadData];
            } else {
                weakSelf.playingFMDetail = nil;
                [weakSelf.tableView reloadData];
                [ShowHUD showError:error.description configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:ApplicationDelegate.window];
            }
            if (finished) {
                weakSelf.playingFMDetail = nil;
                [weakSelf.tableView reloadData];
            }
        }];

    }
}

-(void)dealloc{
    [[AFSoundManager sharedManager] stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)moreAction:(id)sender {
    TranceiverDescriptVC *vc = [[TranceiverDescriptVC alloc]init];
    vc.fm = _fm;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)handleHiddenViewDidClick:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = _vSubscibe.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        _vSubscibe.frame = frame;
    }];
}

- (IBAction)handleCancelDidClick:(id)sender {
    _selectedTimeString = @"06 : 00";
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = _vSubscibe.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        _vSubscibe.frame = frame;
    }];
}

- (IBAction)handleSaveDidClick:(id)sender {
    
    __weak typeof (self) weakSelf = self;
    if (![ShareValue sharedShareValue].toyDetail.toy_id) {
        UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:PROGRAMNAME message:[NSString stringWithFormat:NSLocalizedString(@"还没有绑定玩具哦~", nil)] delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
        [t_alertView show];
        return;
    }
    
    NDFmSubscribeParams *params = [[NDFmSubscribeParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.fm_id = _fm.fm_id;
    params.play_time = [self transNumberFromSelectedTime:_selectedTimeString];
    [NDFmAPI fmSubscribeWithParams:params completionBlockWithSuccess:^{
        
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = _vSubscibe.frame;
            frame.origin.y = [UIScreen mainScreen].bounds.size.height;
            _vSubscibe.frame = frame;
        }];
        
        UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:PROGRAMNAME message:[NSString stringWithFormat:NSLocalizedString(@"订阅成功,电台会在24个小时内播放，请留意", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
        t_alertView.tag = 12;
        [t_alertView show];
        [weakSelf.marr_toySubscribe addObject:_fm];
        _fm.play_time = params.play_time;
        [weakSelf reloadBtnState];
        
    } Fail:^(int code, NSString *failDescript) {
        if (code == 2122) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = _vSubscibe.frame;
                frame.origin.y = [UIScreen mainScreen].bounds.size.height;
                _vSubscibe.frame = frame;
            }];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提醒", nil) message:[NSString stringWithFormat:NSLocalizedString(@"该时间段内已订阅下列电台\n%@,\n继续订阅将取消原有订阅。", nil),failDescript] delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"继续订阅", nil), nil];
            alertView.tag = 11;
            [alertView show];
            
        }else{
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:ApplicationDelegate.window];
        }
    }];

}


- (void)handleSubscibeDidClick:(UIButton *)button
{
   
    //phone
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = _vSubscibe.frame;
        frame.origin.y = 0;
        _vSubscibe.frame = frame;
        
        [_subscibeTableView reloadData];
    }];
}

- (void)handleCancelSubscribeDidClick:(UIButton *)button
{
    __weak typeof (self) weakSelf = self;
    
    NDFmCancelParams *params = [[NDFmCancelParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.fm_id = _fm.fm_id;
    [NDFmAPI fmCancelWithParams:params completionBlockWithSuccess:^{
        
        [ShowHUD showSuccess:NSLocalizedString(@"取消订阅成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
        for (FM *fm in weakSelf.marr_toySubscribe) {
            if ([fm.fm_id isEqualToNumber:weakSelf.fm.fm_id]) {
                [weakSelf.marr_toySubscribe removeObject:fm];
                break;
            }
        }
        
        [weakSelf reloadBtnState];
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:NSLocalizedString(@"取消订阅失败", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
    }];

}

#pragma mark - SubscibeTimeCellDelegate

- (void)handleButtonDidClick:(UIButton *)button andSubscibeTimeCell:(SubscibeTimeCell *)cell
{
    NSString *timeTempString = button.titleLabel.text;
    _selectedTimeString = [timeTempString substringWithRange:NSMakeRange(1, timeTempString.length - 1)];
    [_subscibeTableView reloadData];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    __weak typeof (self) weakSelf = self;
    
    if (alertView.tag == 12) {
        
        if (buttonIndex == 1) {
            
            NDFmSubscribeParams *params = [[NDFmSubscribeParams alloc] init];
            params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
            params.fm_id = _fm.fm_id;
            params.play_time = [self transNumberFromSelectedTime:_selectedTimeString];
            [NDFmAPI fmSubscribeWithParams:params completionBlockWithSuccess:^{
                UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:PROGRAMNAME message:[NSString stringWithFormat:NSLocalizedString(@"订阅成功,电台会在24个小时内播放，请留意", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
                [t_alertView show];
                
                [weakSelf.marr_toySubscribe addObject:_fm];
                _fm.play_time = params.play_time;
                [weakSelf reloadBtnState];
                
            } Fail:^(int code, NSString *failDescript) {
                
                [ShowHUD showError:NSLocalizedString(@"订阅失败", nil) configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:ApplicationDelegate.window];
                
            }];
        }
    }else if(alertView.tag == 11 && buttonIndex == 1){
        NDFmSubscribeParams *params = [[NDFmSubscribeParams alloc] init];
        params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
        params.fm_id = _fm.fm_id;
        params.play_time = [self transNumberFromSelectedTime:_selectedTimeString];
        params.flag = @1;
        [NDFmAPI fmSubscribeWithParams:params completionBlockWithSuccess:^{
            
            UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:PROGRAMNAME message:[NSString stringWithFormat:NSLocalizedString(@"取消订阅成功", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
            [t_alertView show];
            
            [weakSelf.marr_toySubscribe addObject:_fm];
            GCDGroup *group = [GCDGroup new];
            [[GCDQueue globalQueue] execute:^{
                
                [weakSelf loadToySubscribeData];
                
            } inGroup:group];
            [[GCDQueue mainQueue] notify:^{
                
                [weakSelf reloadBtnState];
                
            } inGroup:group];
            
        } Fail:^(int code, NSString *failDescript) {
            [ShowHUD showError:NSLocalizedString(@"取消订阅失败", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:ApplicationDelegate.window];
            
        }];
        
    }
}

@end
