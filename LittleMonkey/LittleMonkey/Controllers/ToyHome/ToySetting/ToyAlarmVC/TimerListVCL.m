//
//  TimerListVCL.m
//  belang
//
//  Created by ilikeido on 14-9-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "TimerListVCL.h"
#import "NDAlarmAPI.h"
#import "TimerCell.h"
#import "TimerAddVCL.h"
#import <BlocksKit/UIControl+BlocksKit.h>


@interface TimerListVCL (){
    Alarm *_timer;
    Alarm *_waitDelete;
}

@property(nonatomic,strong) NSMutableArray *timerList;

@end

@implementation TimerListVCL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timerList = [[NSMutableArray alloc]init];
    self.title = NSLocalizedString(@"玩具闹钟", nil);
    
    UIImage *image = [UIImage imageNamed:@"btn_toyHome_add"];
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(addTimer) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"btn_toyHome_add"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    _lb_none.hidden = YES;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadTimes];
}


-(void)addTimer{
    
    if (_timerList && [_timerList count] >= 3) {
        [ShowHUD showError:NSLocalizedString(@"最多只能设置3个闹铃", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return;
    }
    
    
    TimerAddVCL *vcl = [[TimerAddVCL alloc]init];
    vcl.toy_id = self.toy_id;
    [self.navigationController pushViewController:vcl animated:YES];
}

-(void)loadTimes{
    [_timerList removeAllObjects];
    [self.tableView reloadData];
    if (!_toy_id) {
        _toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    }
    NDAlarmQueryParams * params = [[NDAlarmQueryParams alloc] init];
    params.toy_id  = _toy_id;
    ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"请求中", nil) configParameter:^(ShowHUD *config) {
    } inView:self.view];
    
    [NDAlarmAPI alarmQueryWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        [hud hide];
        if ([data count] > 0) {
             _lb_none.hidden = YES;
            [_timerList addObjectsFromArray:data];
            [self.tableView reloadData];
        }else{
            _lb_none.hidden = NO;
        }
        
    } Fail:^(int code, NSString *failDescript) {
        [hud hide];
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TimerAddVCL *vcl = [[TimerAddVCL alloc]init];
    vcl.toy_id = _toy_id;
    vcl.alarm = _timerList[indexPath.row];
    [self.navigationController pushViewController:vcl animated:YES];
}

#pragma mark - UITableViewDataSource
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"删除", nil);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        _waitDelete = _timerList[indexPath.row];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips", nil) message:NSLocalizedString(@"是否确定要删除定时?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        [alertView show];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _timerList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying 4for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TIMERCELL = @"TimerCell";
    TimerCell *cell = [tableView dequeueReusableCellWithIdentifier:TIMERCELL];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"TimerCell" bundle:nil] forCellReuseIdentifier:TIMERCELL];
        cell = [tableView dequeueReusableCellWithIdentifier:TIMERCELL];
    }
    [cell setAlarm:_timerList[indexPath.row]];
    [cell.switch_time bk_removeEventHandlersForControlEvents:UIControlEventValueChanged];
    [cell.switch_time bk_addEventHandler:^(UISwitch *sender) {
        
        NDAlarmModifyParams *params = [[NDAlarmModifyParams alloc] init];
        params.alarm_id = cell.alarm.alarm_id;
        params.toy_id = cell.alarm.toy_id;
        params.time = cell.alarm.time;
        params.weekday = cell.alarm.weekday;
        params.tag = cell.alarm.tag;
        params.event = cell.alarm.event;
        params.enable = sender.on ? @1 : @0;
        
        ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
        } inView:self.view];
        [NDAlarmAPI alarmModifyWithParams:params completionBlockWithSuccess:^{
            [hud hide];
            [ShowHUD showSuccess:NSLocalizedString(@"修改成功", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
            
            cell.alarm.enable = sender.on ? @1 : @0;
            
        } Fail:^(int code, NSString *failDescript) {
            [hud hide];
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
            
            sender.on = !sender.on;
        }];
    } forControlEvents:UIControlEventValueChanged];
    return cell;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NDAlarmDeleteParams *params = [[NDAlarmDeleteParams alloc] init];
        params.alarm_id = _waitDelete.alarm_id;
        ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"删除中...", nil) configParameter:^(ShowHUD *config) {
        } inView:self.view];
        [NDAlarmAPI alarmDeleteWithParams:params completionBlockWithSuccess:^{
            [hud hide];
            [ShowHUD showSuccess:NSLocalizedString(@"删除成功", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
            
            [[GCDQueue mainQueue] execute:^{
                [self loadTimes];
            } afterDelay:1.5f*NSEC_PER_SEC];
            
        } Fail:^(int code, NSString *failDescript) {
            [hud hide];
            [ShowHUD showError:NSLocalizedString(@"删除失败", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
        }];
        
    }
}


@end
