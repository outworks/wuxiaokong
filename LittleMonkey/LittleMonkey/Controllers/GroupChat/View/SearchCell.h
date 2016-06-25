//
//  SearchCell.h
//  HelloToy
//
//  Created by apple on 15/11/2.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupDetail.h"

@protocol SearchCellDelegate;

@interface SearchCell : UITableViewCell

@property (assign, nonatomic) id <SearchCellDelegate> delegate;
@property (strong, nonatomic) GroupDetail *groupDetail;
@property (weak, nonatomic) IBOutlet UIView *vLine;

-(void)setCellDataWithGroupDetail:(GroupDetail *)groupDetail;
+ (CGFloat)height;

@end

@protocol SearchCellDelegate <NSObject>

- (void)searchCellJoinDidClick:(UIButton *)joinButton andSearchCell:(SearchCell *)cell;

@end
