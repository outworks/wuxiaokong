//
//  ToyNightModelVC.h
//  HelloToy
//
//  Created by nd on 15/7/17.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "Setting.h"

@interface ToyNightModelVC : HideTabSuperVC


@property(nonatomic,strong)NSNumber *toy_id;
@property(nonatomic,strong)Setting *setting;

@property (nonatomic, copy) void (^SaveBlock)(Setting *setting);

@end
