//
//  GroupMemberItemCell.h
//  HelloToy
//
//  Created by huanglurong on 16/6/1.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupMemberItem.h"

@protocol GroupMemberItemCellDelegate <NSObject>

-(void)ClickItemAction:(GroupMemberItem *)album;

@end

@interface GroupMemberItemCell : UITableViewCell

@property(nonatomic,strong) NSMutableArray *mArr_groupMember;

@property (weak, nonatomic) id<GroupMemberItemCellDelegate> delegate;

@end
