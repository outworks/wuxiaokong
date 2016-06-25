//
//  ChildMediaBatVC.h
//  HelloToy
//
//  Created by huanglurong on 16/4/29.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "XMSDK.h"
#import "AlbumInfo.h"
#import "DownloadAlbumInfo.h"

@interface ChildMediaBatVC : HideTabSuperVC

@property(nonatomic,strong) AlbumInfo *albumInfo;
@property(nonatomic,strong) XMAlbum *album_xima; //喜马拉雅的专辑
@property(nonatomic,strong) DownloadAlbumInfo *downloadAlbumInfo; //下载中的专辑
@property(nonatomic,assign) NSInteger type; // 0 :表示批量下载 1: 表示批量播放

@end
