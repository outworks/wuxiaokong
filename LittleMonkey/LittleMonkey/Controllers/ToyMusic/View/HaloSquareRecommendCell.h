//
//  HaloSquareRecommendCell.h
//  HelloToy
//
//  Created by apple on 16/1/25.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumInfo.h"
#import "Fm.h"

@protocol HaloSquareRecommendCellDelegate;

@interface HaloSquareRecommendCell : UITableViewCell

@property (nonatomic,assign) id<HaloSquareRecommendCellDelegate> delegate;
@property (nonatomic,assign) int type; // 0 :电台 1：专辑

//电台推荐
- (void)resetRecommendCellData:(NSMutableArray *)fmArray;

//热门专辑
- (void)resetAlbumCellData:(NSMutableArray *)albumInfoArray;

+ (float)resetCellHeight:(int)count;

@end

@protocol HaloSquareRecommendCellDelegate <NSObject>

@optional
/**
 *  @brief 点击按钮
 *
 *  @param button 按钮
 *  @param cell   单元格
 */
- (void)buttonClickActionByFm:(int)tag andHaloSquareRecommendCell:(HaloSquareRecommendCell *)cell;

/**
 *  @brief 点击按钮
 *
 *  @param button 按钮
 *  @param cell   单元格
 */
- (void)buttonClickActionByHot:(int )tag andHaloSquareRecommendCell:(HaloSquareRecommendCell *)cell;

/**
 *  @brief 点击更多按钮
 *
 *  @param button 按钮
 *  @param cell   单元格
 */
- (void)buttonMoreClickAction:(HaloSquareRecommendCell *)cell;

@end