//
//  TimerCell.m
//  belang
//
//  Created by ilikeido on 14-9-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "TimerCell.h"

@implementation TimerCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAlarm:(Alarm *)alarm{
    if (alarm) {
        _alarm = alarm;
        NSString *t_timeString = [NSString stringWithFormat:@"%d:%d",[_alarm.localTime intValue]/3600, ([_alarm.localTime intValue]%3600)/60];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSDate *date = [dateFormatter dateFromString:t_timeString];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        NSLog(@"%@", destDateString);
        _lb_time.text = destDateString;
        
        if ([_alarm.enable isEqualToNumber:@1]) {
            _switch_time.on = YES;
        }else{
            _switch_time.on = NO;
        }
        
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
            
            _lb_descript.text = [NSString stringWithFormat:@"%@  %@",_alarm.tag,[t_muArr componentsJoinedByString:@","]];
            
            if ([_alarm.weekday isEqualToString:@"1,2,3,4,5,6,7"]) {
                
                _lb_descript.text =[NSString stringWithFormat:@"%@  %@",_alarm.tag,NSLocalizedString(@"每天", nil)];
            }else if([_alarm.weekday isEqualToString:@"1,2,3,4,5"]){
                _lb_descript.text = [NSString stringWithFormat:@"%@  %@",_alarm.tag,NSLocalizedString(@"工作日", nil)];
            }
            
        }else{
            _lb_descript.text = [NSString stringWithFormat:@"%@  %@",_alarm.tag,NSLocalizedString(@"永不", nil)];
        }
        
        
    }
    

}


@end
