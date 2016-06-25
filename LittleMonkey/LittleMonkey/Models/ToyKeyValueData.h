//
//  ToyKeyValueData.h
//  HelloToy
//
//  Created by chenzf on 15/11/13.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToyStatus.h"

@interface ToyKeyValueData : NSObject

@property(nonatomic,strong) NSNumber *isonline;     //是否在线(1-在线，0-不在线)
@property(nonatomic,strong) NSArray *elems;         //查询回来的keyvalue
@property(nonatomic,strong) ToyStatus *toyStatus;

@end
