//
//  ChildMoreView.h
//  HelloToy
//
//  Created by huanglurong on 16/4/22.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyPlay.h"
#import "DownloadMediaInfo.h"
#import "AlbumMedia.h"
#import "AlbumInfo.h"



@interface ChildMoreView : UIView

@property (nonatomic,strong) AlbumInfo *albumInfo;

@property (nonatomic,strong) AlbumMedia *albumMedia;
@property (nonatomic,strong) ToyPlay *toyPlay;
@property (nonatomic,strong) DownloadMediaInfo *downloadMediainfo;
@property (nonatomic,assign) BOOL isGedan;


+ (ChildMoreView *)initCustomView;
- (void)judgeToyPlayCollection:(NSArray *)collection;
- (void)judgeCollection:(NSArray *)collection;
-(void)show;
-(void)hide;


@end
