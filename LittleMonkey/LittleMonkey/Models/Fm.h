//
//  Fm.h
//  HelloToy
//
//  Created by nd on 15/10/15.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FMContent : NSObject

@property (nonatomic,strong) NSNumber *fm_id;
@property (nonatomic,strong) NSNumber *media_id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSNumber *play_date;
@property (nonatomic,strong) NSNumber *play_type;

@end


@interface FM : NSObject

@property (nonatomic,strong) NSNumber *fm_id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSNumber *play_time;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSNumber *subscribe;
@property (nonatomic,strong) NSArray  *items; //FMContent



@end
