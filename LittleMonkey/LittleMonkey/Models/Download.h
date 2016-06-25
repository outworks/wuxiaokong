//
//  Download.h
//  HelloToy
//
//  Created by nd on 15/7/10.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Download : NSObject

@property(nonatomic,strong)NSNumber *toy_id;
@property(nonatomic,strong)NSNumber *download_id;
@property(nonatomic,strong)NSNumber *content_type;
@property(nonatomic,strong)NSString *content_name;
@property(nonatomic,strong)NSNumber *content_id;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *ext;
@property(nonatomic,strong)NSNumber *Flag;

@end
