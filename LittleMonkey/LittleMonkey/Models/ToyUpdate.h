//
//  ToyUpdate.h
//  HelloToy
//
//  Created by nd on 15/5/18.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToyUpdate : NSObject

@property(nonatomic,strong) NSNumber * toy_id;
@property(nonatomic,strong) NSString * version;
@property(nonatomic,strong) NSString * latest_version;
@property(nonatomic,strong) NSString * desc;
@property(nonatomic,strong) NSString * ext;


@end
