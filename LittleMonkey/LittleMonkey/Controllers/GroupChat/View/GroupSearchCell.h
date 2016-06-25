//
//  GroupSearchCell.h
//  HelloToy
//
//  Created by apple on 15/11/9.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupSearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIView *vLine;

+ (CGFloat)height;

@end
