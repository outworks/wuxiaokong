//
//  MsgText.h
//  HelloToy
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgText : NSObject

@property(nonatomic,strong) NSNumber * msg_id;      // 消息id
@property(nonatomic,strong) NSNumber * msg_from;    // 发送用户id
@property(nonatomic,strong) NSNumber * msg_to;      // 接收用户id
@property(nonatomic,strong) NSString * msg_class;   // 消息分类（box_notify,box_req,box_news）
@property(nonatomic,strong) NSString * msg_title;   // 标题
@property(nonatomic,strong) NSString * msg_content; // 内容
@property(nonatomic,strong) NSString * msg_img;     // 图片
@property(nonatomic,strong) NSString * msg_url;     // web url
@property(nonatomic,strong) NSNumber * msg_time;    // 时间戳
@property(nonatomic,strong) NSString * msg_type;    // 消息类别
@property(nonatomic,strong) NSDictionary * msg_obj; // 可变对象，根据msg_type决定


@end
