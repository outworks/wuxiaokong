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

// 专辑id，用于只有id无完整专辑详情情况，由页面自行查询. － add by chenzf 20160629
@property(nonatomic,strong) NSNumber *albumId;
// 完整专辑详情
@property(nonatomic,strong) AlbumInfo *albumInfo;
// 喜马拉雅的专辑
@property(nonatomic,strong) XMAlbum *album_xima;
@property(nonatomic,strong) DownloadAlbumInfo *downloadAlbumInfo;


@end
