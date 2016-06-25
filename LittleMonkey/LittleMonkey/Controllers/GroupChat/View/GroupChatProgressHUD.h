//
//  GroupChatProgressHUD.h
//  HelloToy
//
//  Created by apple on 15/10/23.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupChatProgressHUD : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

+ (void)show;

+ (void)show:(NSString *)duration; 

+ (void)dismissWithSuccess:(NSString *)str;

+ (void)dismissWithError:(NSString *)str;

+ (void)changeSubTitle:(NSString *)str;

@end
