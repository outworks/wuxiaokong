//
//  Gmail.h
//  HelloToy
//
//  Created by huanglurong on 16/3/8.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gmail : NSObject

@property(nonatomic,strong) NSNumber *mail_id;
@property(nonatomic,strong) NSNumber *from_id;
@property(nonatomic,strong) NSNumber *to_id;
@property(nonatomic,strong) NSNumber *room_id;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSNumber *duration;
@property(nonatomic,strong) NSNumber *time;

@end
