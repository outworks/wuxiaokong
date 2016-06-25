//
//  GreetingMail.h
//  HelloToy
//
//  Created by huanglurong on 16/2/1.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GreetingMail : NSObject

@property(nonatomic,strong) NSNumber *greeting_id;
@property(nonatomic,strong) NSNumber *praise;
@property(nonatomic,strong) NSNumber *is_praise; //是否点赞
@property(nonatomic,strong) NSNumber *sender_id;
@property(nonatomic,strong) NSString *duration;   //语音时长
@property(nonatomic,strong) NSString *addtime;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *localUrl;

@end
