//
//  MemberItem.h
//  Talker
//
//  Created by nd on 15/1/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toy.h"




@protocol MemberItemDelegate;

@interface MemberItem : UIView

@property (weak,   nonatomic)   id<MemberItemDelegate> delegate;
@property (weak,   nonatomic)   IBOutlet UIButton *btn_userIcon;
@property (weak,   nonatomic)   IBOutlet UILabel  *lb_name;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_selected;
@property(assign,nonatomic) BOOL isSelected;
@property (strong, nonatomic)   Toy     *toy;


+ (MemberItem *)initCustomView;

@end



@protocol MemberItemDelegate <NSObject>

-(void) checkOutUserInfo:(MemberItem *)item;

@end