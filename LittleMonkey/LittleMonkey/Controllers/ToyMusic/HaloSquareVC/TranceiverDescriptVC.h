//
//  TranceiverDescriptVC.h
//  HelloToy
//
//  Created by ilikeido on 16/1/18.
//  Copyright © 2016年 NetDragon. All rights reserved.
//
#import "HideTabSuperVC.h"
#import <UIKit/UIKit.h>
#import "Fm.h"

@interface TranceiverDescriptVC : HideTabSuperVC

@property(nonatomic,strong) FM *fm;
@property(nonatomic,strong) NSString *desc;

@end
