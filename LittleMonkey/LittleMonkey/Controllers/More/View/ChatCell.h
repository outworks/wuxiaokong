//
//  ChatCell.h
//  HelloToy
//
//  Created by nd on 15/8/28.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Suggest.h"

@protocol ChatCellDelegate <NSObject>

@end

@interface ChatCell : UITableViewCell

@property(nonatomic,assign) BOOL isMyMessage;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_otherUserIcon;

@property (weak, nonatomic) IBOutlet UIView *v_other;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_otherBack;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_other;
@property (weak, nonatomic) IBOutlet UILabel *lb_otherContent;


@property (weak, nonatomic) IBOutlet UIImageView *imageV_myUserIcon;
@property (weak, nonatomic) IBOutlet UIView *v_my;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_myBack;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_my;
@property (weak, nonatomic) IBOutlet UILabel *lb_myContent;



@property (nonatomic,strong) Suggest *suggest;

@end
