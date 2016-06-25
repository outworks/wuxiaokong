//
//  SubscibeTimeCell.h
//  HelloToy
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubscibeTimeCellDelegate;

@interface SubscibeTimeCell : UITableViewCell

@property(weak,nonatomic) id<SubscibeTimeCellDelegate>delegate;

- (void)resetCellData:(NSMutableArray *)subscibeTimeMuArray andRow:(int)row andSelectedTime:(NSString *)selectedTimeString;

+ (float)resetCellHeight;

@end

@protocol SubscibeTimeCellDelegate <NSObject>

-(void)handleButtonDidClick:(UIButton *)button andSubscibeTimeCell:(SubscibeTimeCell *)cell;

@end