//
//  ChildCustomizeCell.h
//  HelloToy
//
//  Created by huanglurong on 16/4/21.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumInfo.h"

@interface ChildCustomizeCell : UITableViewCell

@property(nonatomic,strong) AlbumInfo *albumInfo;

@property(nonatomic,strong) AlbumInfo *albumInfo_selected;
@property(nonatomic,assign) BOOL isAdd;

@end
