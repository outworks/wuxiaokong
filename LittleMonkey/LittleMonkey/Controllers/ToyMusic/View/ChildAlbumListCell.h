//
//  ChildAlbumListCell.h
//  HelloToy
//
//  Created by huanglurong on 16/4/18.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMAlbum.h"
#import "AlbumInfo.h"
#import "DownloadAlbumInfo.h"
#import "Fm.h"

@interface ChildAlbumListCell : UITableViewCell

@property(nonatomic,strong) XMAlbum *album;
@property(nonatomic,strong) AlbumInfo *albumInfo;
@property(nonatomic,strong) DownloadAlbumInfo *downloadAlbumInfo;
@property(nonatomic,strong) FM *fm;

@end
