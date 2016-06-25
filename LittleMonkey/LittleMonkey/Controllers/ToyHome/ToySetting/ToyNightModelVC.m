//
//  ToyNightModelVC.m
//  HelloToy
//
//  Created by nd on 15/7/17.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "ToyNightModelVC.h"
#import "UUDatePicker.h"
#import "NDToyAPI.h"
#import "TimeTool.h"

@interface ToyNightModelVC ()<UUDatePickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tf_startTime;
@property (weak, nonatomic) IBOutlet UITextField *tf_endTime;
@property (weak, nonatomic) IBOutlet UIButton *btn_determine;



@property (strong,nonatomic)UUDatePicker *start_datePicker;
@property (strong,nonatomic)UUDatePicker *end_datePicker;
@property (strong,nonatomic)NSString *isOpen;



@end

@implementation ToyNightModelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"夜间模式", nil);
    
    if (!_setting) {
        
        __weak typeof(self) weakSelf = self;
        
        [[GCDQueue globalQueue] execute:^{
            NDToySettingParams *params = [[NDToySettingParams alloc] init];
            params.toy_id = _toy_id;
            params.keys = @"nightMode";
            [NDToyAPI toySettinWithParams:params completionBlockWithSuccess:^(NSArray *data) {
                
                if (data.count > 0) {
                    Setting *setting = data[0];
                    weakSelf.setting = setting;
                    
                    NSArray *arr_setting = [weakSelf.setting.value componentsSeparatedByString:@","];
                    NSString *start_time = arr_setting[0];
                    NSString *end_time = arr_setting[1];
                    weakSelf.isOpen = arr_setting[2];
                    
                    weakSelf.tf_startTime.text = start_time;
                    weakSelf.tf_endTime.text = end_time;
                    
                    weakSelf.start_datePicker = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, ScreenWidth, 200)
                                                                  Delegate:weakSelf
                                                               PickerStyle:UUDateStyle_HourMinute];
                    weakSelf.start_datePicker.ScrollToDate = [weakSelf dateFromString:weakSelf.tf_startTime.text];
                    weakSelf.start_datePicker.tag = 11;
                    weakSelf.tf_startTime.inputView = weakSelf.start_datePicker;
                    
                    
                    
                    weakSelf.end_datePicker = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, 320, 200)
                                                                Delegate:weakSelf
                                                             PickerStyle:UUDateStyle_HourMinute];
                    weakSelf.end_datePicker.ScrollToDate = [weakSelf dateFromString:weakSelf.tf_endTime.text];
                    weakSelf.end_datePicker.tag = 12;
                    weakSelf.tf_endTime.inputView = weakSelf.end_datePicker;
                }
               
                
            } Fail:^(int code, NSString *failDescript) {
                NSLog(@"请求夜间模式失败");
            }];
        }];
    }else{
        
        NSArray *arr_setting = [_setting.value componentsSeparatedByString:@","];
        NSString *start_time = arr_setting[0];
        NSString *end_time = arr_setting[1];
        _isOpen = arr_setting[2];
        
        _tf_startTime.text = [TimeTool localTimeZoneStringFromServerTimeZoneString:start_time format:@"HH:mm"];
        _tf_endTime.text = [TimeTool localTimeZoneStringFromServerTimeZoneString:end_time format:@"HH:mm"];
        
        _start_datePicker = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, ScreenWidth, 200)
                                                      Delegate:self
                                                   PickerStyle:UUDateStyle_HourMinute];
        _start_datePicker.ScrollToDate = [self dateFromString:_tf_startTime.text];
        _start_datePicker.tag = 11;
        _tf_startTime.inputView = _start_datePicker;
        
        
        
        _end_datePicker = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, ScreenWidth, 200)
                                                    Delegate:self
                                                 PickerStyle:UUDateStyle_HourMinute];
        _end_datePicker.ScrollToDate = [self dateFromString:_tf_endTime.text];
        _end_datePicker.tag = 12;
        _tf_endTime.inputView = _end_datePicker;
        
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
    if (datePicker.tag == 11) {
        _tf_startTime.text = [NSString stringWithFormat:@"%@:%@",hour,minute];
    }
    
    if (datePicker.tag == 12) {
        _tf_endTime.text = [NSString stringWithFormat:@"%@:%@",hour,minute];
    }
}


- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat: @"HH:mm"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}


#pragma mark - buttonAction

- (IBAction)DetermineAction:(id)sender {
    
    if (_tf_startTime.text.length == 0) {
        [ShowHUD showError:NSLocalizedString(@"请选择开始时间", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return;
    }
    
    if (_tf_endTime.text.length == 0) {
        [ShowHUD showError:NSLocalizedString(@"请选择结束时间", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return;
    }
    
   
    NDToyChangeSettingParams *params = [[NDToyChangeSettingParams alloc] init];
    params.toy_id = _toy_id;
    
    params.key = @"nightMode";
    if (!_isOpen) {
        _isOpen = @"on";
    }
    
    NSString *serverStartTime = [TimeTool serverTimeZoneFromLocalTimeZoneString:_tf_startTime.text format:@"HH:mm"];
    NSString *serverEndTime = [TimeTool serverTimeZoneFromLocalTimeZoneString:_tf_endTime.text format:@"HH:mm"];
    __weak __typeof(self) weakSelf = self;
    params.value = [NSString stringWithFormat:@"%@,%@,%@",serverStartTime,serverEndTime,_isOpen];
    
    [NDToyAPI toyChangeSettinWithParams:params completionBlockWithSuccess:^{
        [ShowHUD showSuccess:NSLocalizedString(@"切换成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        _setting.value = params.value;
        
        [[GCDQueue mainQueue] execute:^{
            if (self.SaveBlock) {
                self.SaveBlock(_setting);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } afterDelay:1.5f * NSEC_PER_SEC];
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }];
    
}



#pragma mark - dealloc 

- (void) dealloc{
    
    NSLog(@"ToyNightModelVC");

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
