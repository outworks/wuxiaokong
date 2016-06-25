//
//  ApplyCell.h
//  HelloToy
//
//  Created by ilikeido on 15/12/15.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgText.h"

@protocol ApplyCellDelegate ;
@interface ApplyCell : UITableViewCell

@property(nonatomic,strong) MsgText *msgText;
@property(nonatomic,weak) id<ApplyCellDelegate> delegate;

@end

@protocol ApplyCellDelegate <NSObject>

-(void)applyCellClickApply:(ApplyCell *)cell;

@end