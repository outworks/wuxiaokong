//
//  GroupChatSettingCell.h
//  HelloToy
//
//  Created by apple on 15/10/29.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupChatSettingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivHeader;
@property (weak, nonatomic) IBOutlet UILabel *lbRight;
@property (weak, nonatomic) IBOutlet UILabel *lbLeft;
@property (weak, nonatomic) IBOutlet UIImageView *ivArrows;
@property (weak, nonatomic) IBOutlet UIView *vLine;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_lbright;

@end
