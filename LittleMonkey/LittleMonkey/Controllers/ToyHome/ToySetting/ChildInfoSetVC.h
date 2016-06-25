//
//  ChildInfoSetVC.h
//  HelloToy
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "HideTabSuperVC.h"

@interface ChildInfoSetVC : HideTabSuperVC

@property(nonatomic,strong)Toy *toy;

@property(nonatomic,assign) BOOL isHaveToy;
@property(nonatomic,assign) BOOL isBindSetting;

@end
