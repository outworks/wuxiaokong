//
//  TransceiverCommentCell.h
//  HelloToy
//
//  Created by yull on 15/12/31.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransceiverCommentCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *iconIV;
@property (strong, nonatomic) IBOutlet UILabel *userNameL;
@property (strong, nonatomic) IBOutlet UILabel *commentL;
@property (strong, nonatomic) IBOutlet UILabel *commentDateL;
@end
