//
//  Theme.h
//  HelloToy
//
//  Created by nd on 15/5/28.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Theme : NSObject

@property(nonatomic,strong) NSNumber *theme_id;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *icon;
@property(nonatomic,strong) NSString *preview_url;
@property(nonatomic,strong) NSString *localUrl;

@end
