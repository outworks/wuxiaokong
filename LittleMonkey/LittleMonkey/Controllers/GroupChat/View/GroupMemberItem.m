//
//  GroupMemberItem.m
//  HelloToy
//
//  Created by huanglurong on 16/6/1.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "GroupMemberItem.h"
#import "UIImageView+WebCache.h"
#import "ChooseView.h"

#import "NDGroupAPI.h"
#import "NDToyAPI.h"
#import "NSObject+LKDBHelper.h"

@implementation GroupMemberItem

+ (GroupMemberItem *)initCustomView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"GroupMemberItem" owner:self options:nil];
    return [nibView objectAtIndex:0];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *myTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapEvent:)];
    _imageV_icon.userInteractionEnabled = YES;
    [_imageV_icon addGestureRecognizer:myTapGesture];
    
    self.imageV_icon.layer.cornerRadius = 5.f;
    self.imageV_icon.layer.masksToBounds = YES;
    
}


- (void)setUser:(User *)user{

    if (user) {
        _user = user;
        
        //self.backgroundColor = [UIColor clearColor];
  
        if (_user.icon.length == 0) {
            [self.imageV_icon setImage:[UIImage imageNamed:@"icon_defaultuser"]];
        }else{
            [self.imageV_icon sd_setImageWithURL:[NSURL URLWithString:_user.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        }
        
        self.lb_title.text = _user.nickname;
        
    }

}

- (void)setToy:(Toy *)toy{
    
    if (toy) {
        _toy = toy;
        
        //self.backgroundColor = [UIColor clearColor];
        if (_toy.icon.length == 0) {
            [self.imageV_icon setImage:[UIImage imageNamed:@"icon_defaultuser"]];
        }else{
            [self.imageV_icon sd_setImageWithURL:[NSURL URLWithString:_toy.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        }

        self.lb_title.text = _toy.nickname;
        
    }
    
}


-(void)setAdd:(NSString *)add{

    if (add) {
        _add = add;
        //self.backgroundColor = [UIColor clearColor];
        
        [self.imageV_icon setImage:[UIImage imageNamed:@"icon_webchat.png"]];
        self.lb_title.text = @"微信邀请";
        
    }

}


-(void)gestureTapEvent:(UITapGestureRecognizer *)gesture {
    
    //UIImageView* myImageView = (UIImageView*)gesture.view ;
    
    __weak typeof(self) weakSelf = self;
    
    if (_user) {
        
        if (![ShareFun isGroupOwner]) {
            [ShowHUD showError:@"您不是群主,无法删除成员" configParameter:^(ShowHUD *config) {
            } duration:1.5 inView:ApplicationDelegate.window];
            
            return;
            
        }else{
            
            if ([[ShareValue sharedShareValue].group_owner_id isEqualToNumber:_user.user_id]) {
            
                [ShowHUD showError:@"您是群主,无法删除自身" configParameter:^(ShowHUD *config) {
                } duration:1.5 inView:ApplicationDelegate.window];
                
                return;
            }
        }
        
        [ChooseView showChooseViewInMiddleWithTitle:PROGRAMNAME andPrimitiveText:nil andChooseList:@[[NSString stringWithFormat:NSLocalizedString(@"确定删除(%@)成员?", nil),_user.nickname]] andCancelButtonTitle:NSLocalizedString(@"取消", nil) andConfirmButtonTitle:NSLocalizedString(@"确定", nil) andChooseCompleteBlock:^(NSInteger row) {
            NDGroupKickOutParams *params = [[NDGroupKickOutParams alloc] init];
            params.user_id = _user.user_id;
            ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"删除中...", nil) configParameter:^(ShowHUD *config) {
                
            } inView:ApplicationDelegate.window];
            
            [NDGroupAPI groupKickOutWithParams:params completionBlockWithSuccess:^{
                [hud hide];
                [ShowHUD showSuccess:NSLocalizedString(@"删除成功", nil) configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:ApplicationDelegate.window];
                
                if (_delegate && [_delegate respondsToSelector:@selector(ClickItemAction:)]) {
                    [_delegate ClickItemAction:weakSelf];
                }
                
            } Fail:^(int code, NSString *failDescript) {
                [hud hide];
                [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
                    
                } duration:1.5f inView:ApplicationDelegate.window];
            }];
            
        } andChooseCancleBlock:^(NSInteger row) {
            
        }];
        
    }else if (_toy){
        
        if (![ShareFun isGroupOwner]) {
            [ShowHUD showError:@"您不是群主,无法删除玩具" configParameter:^(ShowHUD *config) {
            } duration:1.5 inView:ApplicationDelegate.window];
            
            return;
            
        }

        [ChooseView showChooseViewInMiddleWithTitle:PROGRAMNAME andPrimitiveText:nil andChooseList:@[[NSString stringWithFormat:NSLocalizedString(@"确定删除(%@)玩具?", nil),_toy.nickname]] andCancelButtonTitle:NSLocalizedString(@"取消", nil) andConfirmButtonTitle:NSLocalizedString(@"确定", nil) andChooseCompleteBlock:^(NSInteger row) {
            NDToyDeleteParams *params = [[NDToyDeleteParams alloc] init];
            params.toy_id = _toy.toy_id;
            
            ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"删除中...", nil) configParameter:^(ShowHUD *config) {
            } inView:ApplicationDelegate.window];
            
            [NDToyAPI toyDeleteWithParams:params completionBlockWithSuccess:^{
                
                [hud hide];
                [ShowHUD showSuccess:NSLocalizedString(@"删除成功", nil) configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:ApplicationDelegate.window];
                
                [Toy deleteWithWhere:[NSString stringWithFormat:@"toy_id=%@",_toy.toy_id]];
                
                if (_delegate && [_delegate respondsToSelector:@selector(ClickItemAction:)]) {
                    [_delegate ClickItemAction:weakSelf];
                }
               
                
            } Fail:^(int code, NSString *failDescript) {
                [hud hide];
                [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
                    
                } duration:1.5f inView:ApplicationDelegate.window];
            }];
            
            
        } andChooseCancleBlock:^(NSInteger row) {
            
        }];
        
        
    }else if (_add){
        
        if (_delegate && [_delegate respondsToSelector:@selector(ClickItemAction:)]) {
            [_delegate ClickItemAction:weakSelf];
        }
    
    
    }

}

@end
