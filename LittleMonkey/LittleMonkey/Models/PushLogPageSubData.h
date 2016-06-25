//
//  PushLogPageSubData.h
//  HelloToy
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushLogPageSubData : NSObject

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,assign) NSInteger count; 
@property(nonatomic,strong) NSArray   *msgs;

@end
