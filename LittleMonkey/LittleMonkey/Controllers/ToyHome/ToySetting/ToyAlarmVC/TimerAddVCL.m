//
//  TimerAddVCL.m
//  belang
//
//  Created by ilikeido on 14-9-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "TimerAddVCL.h"
#import "NSObject+EasyCopy.h"
#import "LKDBHelper.h"
#import "WeekDateChooseVCL.h"
#import "NDAlarmAPI.h"
#import "ToySettingCell.h"
#import "ALarmEventVC.h"
#import "UUDatePicker.h"
#import "UIButton+Block.h"

#define  NickName_MaxLen 16
@interface TimerAddVCL ()<UUDatePickerDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray * arr_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_ok;
@property (strong,nonatomic) UISwitch *swh;
@property (strong,nonatomic) AlarmEvent *alarmEvent;
@property (strong,nonatomic)UUDatePicker *end_datePicker;
@property (strong,nonatomic) NSDate *date;
@property (strong, nonatomic) IBOutlet UIView *vTag;
@property (weak, nonatomic) IBOutlet UIButton *btnCancle;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIView *vCover;

@property(nonatomic,strong)Alarm *alarm_old;

@property (nonatomic,assign) BOOL isShowChange;   // 是否显示修改

@end

@implementation TimerAddVCL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"添加闹钟", nil);
    _arr_title = @[NSLocalizedString(@"重复", nil),NSLocalizedString(@"铃声", nil),NSLocalizedString(@"开关", nil),NSLocalizedString(@"标签", nil)];
    
//    UIImage *image_t = [UIImage imageNamed:@"btn_login_normal"];
//    UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height/2, image_t.size.width/2, image_t.size.height/2, image_t.size.width/2);
//    [_btn_ok setBackgroundImage:[image_t resizableImageWithCapInsets:inset ] forState:UIControlStateNormal];
    
    if (!_alarm) {
        _isShowChange = NO;
        _alarm = [[Alarm alloc]init];
        _alarm.toy_id = self.toy_id;
        _alarm.tag = @"";
        _alarm.enable = @1;
    }else{
        self.alarm_old = [[Alarm alloc] init];
        _alarm_old.alarm_id = _alarm.alarm_id;
        _alarm_old.toy_id = _alarm.toy_id;
        _alarm_old.time = _alarm.time;
        _alarm_old.weekday = _alarm.weekday;
        _alarm_old.tag = _alarm.tag;
        _alarm_old.event = _alarm.event;
        _alarm_old.event_name = _alarm.event_name;
        _alarm_old.enable = _alarm.enable;
        
    }
    
    if (!_alarmEvent) {
        _alarmEvent = [[AlarmEvent alloc] init];
        if (_alarm) {
            _alarmEvent.event_id = _alarm.event;
            _alarmEvent.desc = _alarm.event_name;
        }
    }
    
    if (!_alarm.time) {
        
        _date = [NSDate date];
        
    }else{
        NSString *t_timeString = [NSString stringWithFormat:@"%d:%d",[_alarm.localTime intValue]/3600, ([_alarm.localTime intValue]%3600)/60];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSDate *date = [dateFormatter dateFromString:t_timeString];
        NSLog(@"%@", date);
        _date = date;
    }
   
    
    _end_datePicker = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, ScreenWidth, 200)
                                                Delegate:self
                                             PickerStyle:UUDateStyle_HourMinute];
    _end_datePicker.ScrollToDate = _date;
    _end_datePicker.tag = 12;
    [self.view addSubview:_end_datePicker];
    [self.view bringSubviewToFront:self.vCover];
//    [_datePicker setDatePickerMode:UIDatePickerModeCountDownTimer];
//    _datePicker.date = date;
    
    [_tableView registerNib:[UINib nibWithNibName:@"ToySettingCell" bundle:nil] forCellReuseIdentifier:@"ToySetCell"];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}



- (void)initView
{
    __weak TimerAddVCL *weakSelf = self;
    //设置vPhoneLogin初始frame
    _vTag.frame = CGRectMake(0, -_vTag.frame.size.height, [UIScreen mainScreen].bounds.size.width, _vTag.frame.size.height);
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:_vTag];
    
    //取消按钮
    [_btnCancle handleClickEvent:UIControlEventTouchUpInside withClickBlick:^{
        weakSelf.textField.text = @"";
        [weakSelf.textField resignFirstResponder];
        [self updateNickNameViewHiddenAnimateIfNeed];
    }];
    
    //保存按钮
    [_btnSave handleClickEvent:UIControlEventTouchUpInside withClickBlick:^{
        [weakSelf.textField resignFirstResponder];
        
        if (_textField.text.length > NickName_MaxLen) {
            [ShowHUD showError:NSLocalizedString(@"标签超过16位咯~", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
            return;
        }
        
//        [ShowHUD showSuccess:NSLocalizedString(@"Saving", nil) configParameter:^(ShowHUD *config) {
//        } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
        
        weakSelf.alarm.tag = weakSelf.textField.text;
        [self updateNickNameViewHiddenAnimateIfNeed];
        [_tableView reloadData];
        
    }];
    
    //删除按钮
    [_btnDelete handleClickEvent:UIControlEventTouchUpInside withClickBlick:^{
        weakSelf.textField.text = @"";
    }];

}

#pragma mark - Function

//修改群名视图消失的动画
- (void)updateNickNameViewHiddenAnimateIfNeed
{
    __weak TimerAddVCL *weakSelf = self;
    //vNickName消失
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.vCover.hidden = YES;
        CGRect frame = weakSelf.vTag.frame;
        frame.origin.y = -frame.size.height;
        weakSelf.vTag.frame = frame;
    }];
    
}


#pragma mark - 
#pragma mark buttonActions

-(void)backAction:(id)sender{
    
    if (_alarm_old) {
        NSDate *date = _date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *strDate = [dateFormatter stringFromDate:date];
        NSArray *array = [strDate componentsSeparatedByString:@":"];
        NSString *hour = array[0];
        NSString *min = array[1];
        
        NSNumber *t_number = @([hour longLongValue]*3600+[min longLongValue]*60);
        
        if ([_alarm_old.time isEqualToNumber:t_number] && [_alarm_old.tag isEqualToString:_alarm.tag] && [_alarm_old.event isEqualToNumber:_alarmEvent.event_id] && [_alarm_old.enable isEqualToNumber:_alarm.enable]&& [_alarm_old.weekday isEqualToString:_alarm.weekday]) {
            _isShowChange = NO;
        }else{
        
            _isShowChange = YES;
        }
    }else{
        
        _isShowChange = NO;
    }
    
   
    
    
    if (_isShowChange == YES) {
        
        UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:PROGRAMNAME message:NSLocalizedString(@"是否保存闹钟信息", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"否", nil) otherButtonTitles:NSLocalizedString(@"是", nil), nil];
        [t_alertView show];
        
    }else{
    
         [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

-(IBAction)saveAction:(id)sender{
    
    NSDate *date = _date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    NSArray *array = [strDate componentsSeparatedByString:@":"];
    NSString *hour = array[0];
    NSString *min = array[1];

    _alarm.localTime = @([hour longLongValue]*3600+[min longLongValue]*60);
    
    if (!_alarm.tag) {
        _alarm.tag = @"";
    }
    
    if (_alarmEvent) {
        _alarm.event = _alarmEvent.event_id;
        
    }
    
    if (!_alarm.event) {
        [ShowHUD showError:NSLocalizedString(@"请设置铃声", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return;
    }
    
    if (_alarm.alarm_id) {
        
        NDAlarmModifyParams *params = [[NDAlarmModifyParams alloc] init];
        params.alarm_id = _alarm.alarm_id;
        params.toy_id = _alarm.toy_id;
        params.time = _alarm.time;
        params.weekday = _alarm.weekday;
        params.tag = _alarm.tag;
        params.event = _alarm.event;
        params.enable = _alarm.enable;
        
        ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
        } inView:self.view];
        [NDAlarmAPI alarmModifyWithParams:params completionBlockWithSuccess:^{
            [hud hide];
            [ShowHUD showSuccess:NSLocalizedString(@"修改成功", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
            
            [[GCDQueue mainQueue] execute:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1.5f*NSEC_PER_SEC];
            
        } Fail:^(int code, NSString *failDescript) {
            [hud hide];
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
        }];
        
    }else{
    
        NDAlarmAddParams *params = [[NDAlarmAddParams alloc] init];
        params.toy_id = _alarm.toy_id;
        params.time = _alarm.time;
        params.weekday = _alarm.weekday;
        params.tag = _alarm.tag;
        params.event = _alarm.event;
        params.enable = _alarm.enable;
        
        ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
        } inView:self.view];
        [NDAlarmAPI alarmAddWithParams:params completionBlockWithSuccess:^{
            [hud hide];
            [ShowHUD showSuccess:NSLocalizedString(@"添加成功", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
            
            [[GCDQueue mainQueue] execute:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1.5f*NSEC_PER_SEC];
            
        } Fail:^(int code, NSString *failDescript) {
            [hud hide];
            if (code == 2114) {
                [ShowHUD showError:NSLocalizedString(@"最多只能设置3个闹铃", nil) configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:self.view];
            }else{
                [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:self.view];
            }
            
            
        }];
    
    }
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        WeekDateChooseVCL *vcl = [[WeekDateChooseVCL alloc]init];
        vcl.alarm = _alarm;
        vcl.SaveBlock = ^(Alarm *alarm) {
            
            [tableView reloadData];
        };
        [self.navigationController pushViewController:vcl animated:YES];
        
    }else if (indexPath.row == 1){
        
        ALarmEventVC *t_vc = [[ALarmEventVC alloc] init];
        t_vc.alarmEvent = _alarmEvent;
        t_vc.SelectAlarmBlock = ^(AlarmEvent *alarmEvent) {
          
            self.alarmEvent.event_id = alarmEvent.event_id;
            self.alarmEvent.desc = alarmEvent.desc;
        };
        [self.navigationController pushViewController:t_vc animated:YES];
    }else if (indexPath.row == 3){
        _textField.text = _alarm.tag;
        //vNickName出现[添加下降动画]
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^() {
                             CGRect frame = _vTag.frame;
                             frame.origin.y = 0;
                             _vTag.frame = frame;
                             [UIView animateWithDuration:0.2 animations:^{
                                 _vCover.hidden = NO;
                                 [_textField becomeFirstResponder];
                             } completion:^(BOOL finished) {
                             }];
                             
                         } completion:^(BOOL finished) {
                         }];
    }
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return _arr_title.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString* identifier = @"ToySetCell";
    
    ToySettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.delegate = (id<ToySetCellDelegate>)self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.imageV_icon.hidden = YES;
    if (indexPath.row != _arr_title.count -1) {
//         cell.imageV_downLine.hidden = YES;
    }
   
    cell.lb_nightModel.hidden = YES;
    
    cell.lb_title.text = _arr_title[indexPath.row];
    if (indexPath.row == 0) {
        cell.lb_content.hidden = NO;
        
        if (_alarm.weekday) {
            
            NSArray *array = [_alarm.weekday componentsSeparatedByString:@","];
            NSMutableArray *t_muArr = [NSMutableArray array];
            for (NSString *t_str in array) {
                NSString *tempStr = nil;
                if ([t_str isEqualToString:@"1"]) {
                    tempStr = NSLocalizedString(@"周一", nil);
                }else if ([t_str isEqualToString:@"2"]){
                    tempStr = NSLocalizedString(@"周二", nil);
                }else if ([t_str isEqualToString:@"3"]){
                    tempStr = NSLocalizedString(@"周三", nil);
                }else if ([t_str isEqualToString:@"4"]){
                    tempStr = NSLocalizedString(@"周四", nil);
                }else if ([t_str isEqualToString:@"5"]){
                    tempStr = NSLocalizedString(@"周五", nil);
                }else if ([t_str isEqualToString:@"6"]){
                    tempStr = NSLocalizedString(@"周六", nil);
                }else if ([t_str isEqualToString:@"7"]){
                    tempStr = NSLocalizedString(@"周日", nil);
                }
                
                if (tempStr) {
                    [t_muArr addObject:tempStr];
                }
            }
            
            cell.lb_content.text = [t_muArr componentsJoinedByString:@","];
            
            if ([_alarm.weekday isEqualToString:@"1,2,3,4,5,6,7"]) {
                cell.lb_content.text = NSLocalizedString(@"每天", nil);
            }else if([_alarm.weekday isEqualToString:@"1,2,3,4,5"]){
                cell.lb_content.text = NSLocalizedString(@"工作日", nil);
            }else if([_alarm.weekday isEqualToString:@""]){
                cell.lb_content.text = NSLocalizedString(@"永不", nil);
            }
            
        }else{
            cell.lb_content.text = NSLocalizedString(@"永不", nil);
        }
    }else if (indexPath.row == 1){
        cell.lb_content.hidden = NO;
        if (_alarmEvent) {
            if (!_alarmEvent.desc.length) {
                cell.lb_content.text = NSLocalizedString(@"请选择铃声", nil);
            }else{
                cell.lb_content.text = _alarmEvent.desc;
            }
            
        }else{
            
        }
        
        
    }else if (indexPath.row == 2){
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lb_content.hidden = YES;
        cell.imageV_icon.hidden = YES;
        cell.imageV_arrow.hidden = YES;
        cell.swh.hidden = NO;
        _swh = cell.swh;
        
        if ([_alarm.enable isEqualToNumber:@1]) {
            [cell.swh setOn:YES animated:YES];
        }else{
            [cell.swh setOn:NO animated:YES];
        }
        
    }else if (indexPath.row == 3){
        
        cell.lb_content.hidden = NO;
        cell.imageV_icon.hidden = YES;
        cell.imageV_arrow.hidden = YES;
        cell.swh.hidden = YES;

        if (_alarm.tag) {
            if ([_alarm.tag isEqualToString:@""]) {
                cell.lb_content.text = NSLocalizedString(@"无", nil);
            }else{
                cell.lb_content.text = _alarm.tag;
            }
        }
    }
    
    return cell;
    
    
}

#pragma mark - toyCellDelegate

-(void)swithAction:(BOOL)yesOrNO{
    
    if (yesOrNO) {
        _alarm.enable = @1;
    }else{
        _alarm.enable = @0;
    }


}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [self saveAction:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - UUDatePicker's delegate
- (void)uuDatePicker:(UUDatePicker *)datePicker
                year:(NSString *)year
               month:(NSString *)month
                 day:(NSString *)day
                hour:(NSString *)hour
              minute:(NSString *)minute
             weekDay:(NSString *)weekDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"HH:mm"];
    NSDate *destDate= [dateFormatter dateFromString:[NSString stringWithFormat:@"%@:%@",hour,minute]];
    
    _date = destDate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    NSLog(@"GroupMemberVC dealloc");
    [_vTag removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
