//
//  ChildMusicVC.h
//  HelloToy
//
//  Created by huanglurong on 16/4/11.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

//#import "HideTabSuperVC.h"
#import "ShowTabSuperVC.h"

@interface ChildMusicVC : ShowTabSuperVC

+ (void)loadCollections;

@property(nonatomic,assign) BOOL canBack;


@end
