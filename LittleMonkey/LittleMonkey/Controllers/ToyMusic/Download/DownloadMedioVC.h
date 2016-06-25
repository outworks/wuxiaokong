//
//  DownloadMedioVC.h
//  HelloToy
//
//  Created by ilikeido on 16/4/29.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadAlbumInfo.h"
#import "HideTabSuperVC.h"

@interface DownloadMedioVC : HideTabSuperVC

@property(nonatomic,weak) UIViewController *ownerVC;

@property(nonatomic,strong) DownloadAlbumInfo *album;

@end
