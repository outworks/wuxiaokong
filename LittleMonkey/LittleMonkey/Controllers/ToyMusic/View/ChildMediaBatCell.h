//
//  ChildMediaBatCell.h
//  HelloToy
//
//  Created by huanglurong on 16/4/29.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMTrack.h"
#import "MediaDownloadStatus.h"
#import "AlbumMedia.h"

@class ChildMediaBatCell;

typedef void(^ChildMediaBatCellBlock)(ChildMediaBatCell *cell,BOOL isSelected);

@interface ChildMediaBatCell : UITableViewCell

@property(nonatomic,strong)XMTrack *album_xima;
@property(nonatomic,strong) AlbumMedia *albumMedia;
@property(nonatomic,strong)MediaDownloadStatus *downloadStatus;
@property(nonatomic,copy) ChildMediaBatCellBlock block_bat;
@property (nonatomic,assign) BOOL isSelected;

@end
