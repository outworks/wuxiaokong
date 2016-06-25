//
//  HaloSquareCell.h
//  HelloToy
//
//  Created by apple on 16/1/25.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumInfo.h"

@protocol HaloSquareCellDelegate;

@interface HaloSquareCell : UITableViewCell

@property (nonatomic,assign) id<HaloSquareCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *vLine;

- (void)resetCellData:(NSArray *)typeArray andIndexPath:(int)indexPath andData:(NSDictionary *)dataDict;
+ (float)resetCellHeight;

@end

@protocol HaloSquareCellDelegate <NSObject>

/**
 *  @brief 点击按钮
 *
 *  @param button 按钮
 *  @param cell   单元格
 */
- (void)buttonClickAction:(UIButton *)button andHaloSquareCell:(HaloSquareCell *)cell andIndexPath:(NSInteger)indexPath;

@end