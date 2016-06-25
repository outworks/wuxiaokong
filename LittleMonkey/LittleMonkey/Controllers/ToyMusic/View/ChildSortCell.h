//
//  ChildSortCell.h
//  HelloToy
//
//  Created by huanglurong on 16/4/13.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMAlbum.h"
#import "XMTag.h"

@class ChildSortCell;

typedef void (^ChildSortCellMoreBlock)(ChildSortCell *cell);
typedef void (^ChildSortCellAlbumBlock)(ChildSortCell *cell, XMAlbum *album);
typedef void (^ChildSortCellTagBlock)(ChildSortCell *cell, XMTag *tag);


@interface ChildSortCell : UITableViewCell

@property(nonatomic,strong) NSString *ChildTag;
@property(nonatomic,strong) NSMutableArray *mArr_album;
@property(nonatomic,copy) ChildSortCellMoreBlock block_more;
@property(nonatomic,copy) ChildSortCellAlbumBlock block_album;
@property(nonatomic,copy) ChildSortCellTagBlock block_tag;


@property(nonatomic,strong) NSMutableArray *mArr_tag;

@property (nonatomic,assign) BOOL isLoaded;


@end
