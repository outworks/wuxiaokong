//
//  ToyPlay.h
//  HelloToy
//
//  Created by huanglurong on 16/3/1.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToyPlay : NSObject

@property(nonatomic,strong) NSNumber *media_id;
@property(nonatomic,strong) NSNumber *play_count;
@property(nonatomic,strong) NSString *update_at;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *icon;
@property(nonatomic,strong) NSNumber *media_type;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSNumber *duration;

@end
