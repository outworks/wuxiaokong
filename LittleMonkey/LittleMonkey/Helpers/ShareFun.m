//
//  ShareFun.m
//  HelloToy
//
//  Created by nd on 15/4/21.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "ShareFun.h"

#include <netdb.h>
#import <arpa/inet.h>
#include <sys/socket.h>
#import "LKDBHelper.h"

#import "ShareValue.h"

#import "User.h"
#import "Toy.h"
#import "GroupDetail.h"

#import "Mail.h"
#import "NDUSerAPI.h"
#import "NDAPIShareValue.h"



#define WANTSHOWNEWVERSION @"WANTSHOWNEWVERSION"

@implementation ShareFun

+ (NSString *) getIPWithHostName:(const NSString *)hostName
{
    const char *hostN= [hostName UTF8String];
    struct hostent* phot;
    
    @try {
        phot = gethostbyname(hostN);
        
    }
    @catch (NSException *exception) {
        return nil;
    }
    
    struct in_addr ip_addr;
    memcpy(&ip_addr, phot->h_addr_list[0], 4);
    char ip[20] = {0};
    inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    
    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
    return strIPAddress;
}

+(NSString *)getVerison{
    NSString * verison = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSString * verison = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return verison;
}

+(NSDate *)changeSpToTime:(NSNumber *)sp{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[sp intValue]];
    return confromTimesp;
}

+(long)timeDifference:(NSDate *)date withAfterDate:(NSDate *)afterDate{
    long difference =fabs([date timeIntervalSinceDate:afterDate]);
    return difference;
}

//判断是否是群主

+ (BOOL)isGroupOwner{
    
    if ([ShareValue sharedShareValue].group_owner_id) {
        return [[ShareValue sharedShareValue].user_id isEqualToNumber:[ShareValue sharedShareValue].group_owner_id];
    }else{
        return NO;
    }
    
    
}

+(void)clearAllTable{
    
    [ShareValue sharedShareValue].group_owner_id = nil;
    [ShareValue sharedShareValue].group_id = nil;
    [LKDBHelper clearTableData:[GroupDetail class]];
    [LKDBHelper clearTableData:[User class]];
    [LKDBHelper clearTableData:[Toy class]];

}

+(void)deleteAllTable{
    
    [ShareValue sharedShareValue].group_owner_id = nil;
    [ShareValue sharedShareValue].group_id = nil;
    
    [[LKDBHelper getUsingLKDBHelper]dropTableWithClass:[GroupDetail class]];
    [[LKDBHelper getUsingLKDBHelper]dropTableWithClass:[User class]];
    [[LKDBHelper getUsingLKDBHelper]dropTableWithClass:[Toy class]];
}

+(void)deleteMailTable{
    
    [Mail deleteWithWhere:[NSString stringWithFormat:@"own_id =%@ and group_id =%@",[ShareValue sharedShareValue].user_id,[ShareValue sharedShareValue].group_id]];
    
}

+ (void)userDatahandleWhenLoginOut{

    [[ShareValue sharedShareValue] setUser_id:nil];
    [[ShareValue sharedShareValue] setUser:nil];
    [NDAPIShareValue standardShareValue].token = nil;
    [NDAPIShareValue standardShareValue].user_id = nil;
    
    [[GCDQueue globalQueue] execute:^{
        
        NDUserClearJPushIdParams *params = [[NDUserClearJPushIdParams alloc] init];
        [NDUserAPI userClearJPushIdWithParams:params completionBlockWithSuccess:^{
            NSLog(@"JPushID注销成功");
        } Fail:^(int code, NSString *failDescript) {
            NSLog(@"JPushID注销失败%@",failDescript);
            
        }];
    }];

}

//退出程序

+ (void)exitApplication{
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(window.bounds.size.width/2, window.bounds.size.height/2, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    
}


//退出群
+(void)quitGroup{
    
    [ShareValue sharedShareValue].groupDetail = nil;
    [ShareValue sharedShareValue].group_id = nil;
    [ShareValue sharedShareValue].group_owner_id = nil;
    [ShareValue sharedShareValue].toyDetail = nil;
    
}

//进入群
+(void)enterGroup:(GroupDetail *)group{
    
    [ShareValue sharedShareValue].groupDetail = group;
    [ShareValue sharedShareValue].group_id = group.group_id;
    [ShareValue sharedShareValue].group_owner_id = group.owner_id;
    
}

//清除播放数据

+(void)clearPlayData{
    
    [ShareValue sharedShareValue].cur_ablumId = nil;
    [ShareValue sharedShareValue].cur_mediaId = nil;
    [ShareValue sharedShareValue].cur_statues = @"0";//暂停状态
    
}


@end
