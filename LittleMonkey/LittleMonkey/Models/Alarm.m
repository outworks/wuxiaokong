//
//  Alarm.m
//  HelloToy
//
//  Created by nd on 15/6/10.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "Alarm.h"
#import "TimeTool.h"

@implementation Alarm

-(NSNumber *)localTime{
    return [TimeTool localTimeFromServerTime:_time];
}

-(void)setLocalTime:(NSNumber *)localTime{
    NSNumber *serverTime = [TimeTool serverTimeFromLocalTime:localTime];
    [self setTime:serverTime];
}

@end


@implementation AlarmEvent

@end