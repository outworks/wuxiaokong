//
//  ChildAlbumDetailVC.h
//  HelloToy
//
//  Created by huanglurong on 16/4/24.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "AlbumInfo.h"
#import "XMSDK.h"
#import "DownloadAlbumInfo.h"

@interface ChildAlbumDetailVC : HideTabSuperVC

@property(nonatomic,strong) AlbumInfo *albumInfo;
@property(nonatomic,strong) XMAlbum *album_xima; //喜马拉雅的专辑
@property(nonatomic,strong) DownloadAlbumInfo *downloadAlbumInfo;


@end
