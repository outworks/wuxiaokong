//
//  Mail.h
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mail : NSObject

@property(nonatomic,strong) NSNumber * mail_id;     // 邮件编号
@property(nonatomic,strong) NSNumber * send_id;     // 发件人编号
@property(nonatomic,strong) NSNumber * send_type;   // 0：用户 1：硬件
@property(nonatomic,strong) NSNumber * receive_id;  // 收件人编号
@property(nonatomic,strong) NSNumber * send_time;   //1970年之后的秒数
@property(nonatomic,strong) NSNumber * duration;    //时长(单位:s)
@property(nonatomic,strong) NSString * url;         //语音文件URL或图片URL
@property(nonatomic,strong) NSNumber *own_id;       // 谁的聊天记录
@property(nonatomic,strong) NSNumber *group_id;     //哪个群的聊天记录

@property(nonatomic,strong) NSString *localUrl;     //本地URL
@property(nonatomic,assign) BOOL isRead;            //是否是已读
@property(nonatomic,assign) NSInteger flag;         //是否是连续 0:表示连续  1:表示不连续
@property(nonatomic,strong) NSNumber * mail_type;   // 0：语音 1：文字 2：图片
@property(nonatomic,strong) NSString *content;      //文字内容


-(void)save;

-(Mail *)getNextMinMail;

-(Mail *)getNextFlagMail;

+(Mail *)getLastFlagMail;

+(Mail *)getLastMail;

+(NSArray *)localArrayFormMin:(NSNumber *)min toMax:(NSNumber *)max pagesize:(int)pagesize;

@end
