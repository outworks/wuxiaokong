//
//  TimeTool.m
//  HelloToy
//
//  Created by ilikeido on 15/12/17.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "TimeTool.h"
#import "NSDate+TimeAgo.h"

@implementation TimeTool

+(NSDate *)dateFromTranTime:(NSNumber *)time{
    if (time == 0) {
        return nil;
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    return confromTimesp;
}

+(NSString *)dateStringFromTranTime:(NSNumber *)time format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:format];
    //设置时区
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [TimeTool dateFromTranTime:time];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+(NSString *)timeAgoFromTranTime:(NSNumber *)time{
    NSDate *confromTimesp = [TimeTool dateFromTranTime:time];
    NSString *timeago = [confromTimesp timeAgo];
    return timeago;
}


+(NSString *)localTimeZoneStringFromServerTimeZoneString:(NSString *)dateString format:(NSString *)format{
    //先是将指定时区的日期转换为当前时区时间:
    NSDateFormatter *cnFormatter = [[NSDateFormatter alloc] init];
    [cnFormatter setDateFormat:format];
    [cnFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]] ;
    NSDate *time = [cnFormatter dateFromString:dateString];
    
    NSDateFormatter *localFormatter = [[NSDateFormatter alloc] init];
    [localFormatter setDateFormat:format];
    [localFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    return [localFormatter stringFromDate:time];
}

+(NSString *)serverTimeZoneFromLocalTimeZoneString:(NSString *)dateString format:(NSString *)format{
    NSDateFormatter *localFormatter = [[NSDateFormatter alloc] init];
    [localFormatter setDateFormat:format];
    [localFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *time = [localFormatter dateFromString:dateString];
    //先是将指定时区的日期转换为当前时区时间:
    NSDateFormatter *cnFormatter = [[NSDateFormatter alloc] init];
    [cnFormatter setDateFormat:format];
    [cnFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]] ;
    return [cnFormatter stringFromDate:time];
}

+(NSNumber *)localTimeFromServerTime:(NSNumber *)serverTime{
    NSString *t_timeString = [TimeTool DateStringFromNumber:serverTime];
    NSString *tempString = [TimeTool localTimeZoneStringFromServerTimeZoneString:t_timeString format:@"HH:mm"];
    return [TimeTool timeNumberFromString:tempString];
}

+(NSString *)DateStringFromNumber:(NSNumber *)time{
    NSString *t_timeString = [NSString stringWithFormat:@"%d:%d",[time intValue]/3600, ([time intValue]%3600)/60];
    return t_timeString;
}

+(NSNumber *)timeNumberFromString:(NSString *)timeString{
    NSArray *array = [timeString componentsSeparatedByString:@":"];
    NSString *hour = array[0];
    NSString *min = array[1];
    NSNumber *t_number = @([hour longLongValue]*3600+[min longLongValue]*60);
    return t_number;
}

+(NSNumber *)serverTimeFromLocalTime:(NSNumber *)localTime{
    NSString *t_timeString = [TimeTool DateStringFromNumber:localTime];
    NSString *tempString = [TimeTool serverTimeZoneFromLocalTimeZoneString:t_timeString format:@"HH:mm"];
    return [TimeTool timeNumberFromString:tempString];
}

@end
