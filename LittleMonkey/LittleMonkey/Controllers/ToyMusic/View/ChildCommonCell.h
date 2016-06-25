//
//  ChildCommonCell.h
//  HelloToy
//
//  Created by huanglurong on 16/4/19.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyPlay.h"
#import "DownloadMediaInfo.h"
#import "AlbumMedia.h"
#import "AlbumInfo.h"
#import "XMTrack.h"
#import "MediaDownloadStatus.h"
#include "FSAudioController.h"
#import "FSPlaylistItem.h"

@class ChildCommonCell;

typedef void(^ChildCommonCellMoreBlock)();
typedef void(^ChildCommonCellPlayBlock)(ChildCommonCell *cell);
typedef void(^ChildCommonCellDownBlock)(ChildCommonCell *cell);

static FSAudioController * audioController_cell;

@interface ChildCommonCell : UITableViewCell

@property(copy,nonatomic) ChildCommonCellMoreBlock block_more;
@property(copy,nonatomic) ChildCommonCellPlayBlock block_play;
@property(copy,nonatomic) ChildCommonCellDownBlock block_down;


@property(nonatomic,strong)AlbumInfo *albumInfo;
@property(nonatomic,strong)AlbumMedia *albumMedia;
@property(nonatomic,strong)ToyPlay   *toyPlay;
@property(nonatomic,strong)DownloadMediaInfo *downloadMediaInfo;
@property(nonatomic,strong)XMTrack *album_xima;
@property(nonatomic,strong)MediaDownloadStatus *downloadStatus;

@property(nonatomic,assign) BOOL isLocal;
@property(nonatomic,assign) BOOL isPlay;
@property(nonatomic,assign) BOOL isGedan; //是不是歌单



@property (weak, nonatomic) IBOutlet UIButton *btn_status;

@property(nonatomic,strong) NSNumber *playMediaId;

@property(nonatomic,assign) BOOL hideMore;

@property(nonatomic,assign) BOOL hideStuats;


- (void)btnTryListen:(NSNumber *)media_id WithUrl:(NSString *)url;


@end
