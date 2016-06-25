//
//  ToySetingCell.h
//  HelloToy
//
//  Created by nd on 15/11/2.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToySetCellDelegate <NSObject>

-(void)swithAction:(BOOL)yesOrNO;

@end


@interface ToySettingCell : UITableViewCell

@property (weak,nonatomic) id<ToySetCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_arrow;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;

@property (weak, nonatomic) IBOutlet UISwitch *swh;
@property (weak, nonatomic) IBOutlet UILabel *lb_nightModel;


@end
