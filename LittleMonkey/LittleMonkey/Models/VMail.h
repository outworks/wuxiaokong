//
//  VMail.h
//  HelloToy
//
//  Created by nd on 15/6/10.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VMail : NSObject

@property(nonatomic,strong) NSNumber * mail_id; //邮件编号
@property(nonatomic,strong) NSNumber * send_id; //发件人编号
@property(nonatomic,strong) NSNumber * send_type; // 0:用户 1:硬件
@property(nonatomic,strong) NSNumber * target_id; // 收件人编号
@property(nonatomic,strong) NSNumber * target_type; // 0:用户 1:硬件
@property(nonatomic,strong) NSNumber * send_time; // 1970年之后的秒数
@property(nonatomic,strong) NSNumber * duration; // 时长(单位：s)
@property(nonatomic,strong) NSString * url; // 语音文件URL
@property(nonatomic,strong) NSString * localUrl;//本地语音

@end
