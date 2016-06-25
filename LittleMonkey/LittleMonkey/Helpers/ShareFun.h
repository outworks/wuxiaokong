//
//  ShareFun.h
//  HelloToy
//
//  Created by nd on 15/4/21.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareFun : NSObject

//通过域名获取ip地址

+ (NSString *)getIPWithHostName:(const NSString *)hostName;

//获取版本号
+(NSString *)getVerison;

//判断是否是群主
+ (BOOL)isGroupOwner;

//清空用户所有表内容
+(void)clearAllTable;

//删除用户所有表结构和内容
+(void)deleteAllTable;

//删除邮件表
+(void)deleteMailTable;

//退出登录所做的操作
+ (void)userDatahandleWhenLoginOut;

//退出群
+(void)quitGroup;

//进入群
+(void)enterGroup:(GroupDetail *)group;

//清除播放数据
+(void)clearPlayData;

//退出程序
+ (void)exitApplication;

//时间
+(NSDate *)changeSpToTime:(NSNumber *)sp;
+(long)timeDifference:(NSDate *)date withAfterDate:(NSDate *)afterDate;


@end
