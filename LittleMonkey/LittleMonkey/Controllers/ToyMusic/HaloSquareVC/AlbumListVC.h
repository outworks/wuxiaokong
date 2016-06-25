//
//  AlbumListVC.h
//  HelloToy
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "HideTabSuperVC.h"


@interface AlbumListVC : HideTabSuperVC

@property (strong, nonatomic) NSString *tagName;
@property (nonatomic,assign) int typeList; // 0: 表示电台 1：表示专辑


@end
