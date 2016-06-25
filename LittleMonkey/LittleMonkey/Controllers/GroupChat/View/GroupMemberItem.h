//
//  GroupMemberItem.h
//  HelloToy
//
//  Created by huanglurong on 16/6/1.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Toy.h"

@class GroupMemberItem;

@protocol GroupMemberItemDelegate <NSObject>

-(void)ClickItemAction:(GroupMemberItem *)album;

@end

@interface GroupMemberItem : UIView

@property(nonatomic,strong) User *user;
@property(nonatomic,strong) Toy *toy;
@property(nonatomic,strong) NSString *add;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;

@property (weak, nonatomic) id<GroupMemberItemDelegate> delegate;

+ (GroupMemberItem *)initCustomView;

@end
