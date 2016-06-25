//
//  TransceiverDetailCell.h
//  HelloToy
//
//  Created by yull on 15/12/30.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDetail.h"

@protocol TransceiverDetailCellDelegate;


@interface TransceiverDetailCell : UITableViewCell

@property(weak,nonatomic) id<TransceiverDetailCellDelegate>delegate;

@property(nonatomic,strong) FMDetail *fmDetail;

-(void)setPlaying:(BOOL)playing;

@end


@protocol TransceiverDetailCellDelegate <NSObject>

-(void)playFm:(TransceiverDetailCell *)cell;

@end