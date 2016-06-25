//
//  TimeTool.h
//  HelloToy
//
//  Created by ilikeido on 15/12/17.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTool : NSObject

+(NSDate *)dateFromTranTime:(NSNumber *)time;

+(NSString *)dateStringFromTranTime:(NSNumber *)time format:(NSString *)format;
+(NSString *)timeAgoFromTranTime:(NSNumber *)time;
+(NSString *)localTimeZoneStringFromServerTimeZoneString:(NSString *)dateString format:(NSString *)format;

+(NSString *)serverTimeZoneFromLocalTimeZoneString:(NSString *)dateString format:(NSString *)format;

+(NSNumber *)localTimeFromServerTime:(NSNumber *)serverTime;
+(NSNumber *)serverTimeFromLocalTime:(NSNumber *)localTime;
+(NSNumber *)timeNumberFromString:(NSString *)timeString;
+(NSString *)DateStringFromNumber:(NSNumber *)time;

@end
