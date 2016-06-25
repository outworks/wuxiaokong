//
//  FMComment.h
//  HelloToy
//
//  Created by yull on 16/1/6.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMComment : NSObject

@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSNumber *media_id;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSNumber *reply_id;
@property (nonatomic, strong) NSNumber *user_id;

@end
