//
//  ChildMenuView.m
//  HelloToy
//
//  Created by huanglurong on 16/5/4.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildMenuView.h"
#import "PureLayout.h"

#import "ChildMoreListVC.h"

#import "ChildCustomizeVC.h"
#import "LoadDownMediaVC.h"

#import "ChildMusicVC.h"
#import "ShareFun.h"

@interface ChildMenuView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_bg;
@property (weak, nonatomic) IBOutlet UIView *v_bottom;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;

@property (weak, nonatomic) IBOutlet UILabel *lb_second;

@property (weak, nonatomic) IBOutlet UILabel *lb_third;
@property (weak, nonatomic) IBOutlet UIButton *btn_first;
@property (weak, nonatomic) IBOutlet UIButton *btn_secend;
@property (weak, nonatomic) IBOutlet UIButton *btn_third;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_bottom;

@property (strong,nonatomic) NSArray *arr_view;

@end


@implementation ChildMenuView


+ (ChildMenuView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ChildMenuView" owner:self options:nil];
    return [nibView objectAtIndex:0];
    
}

-(void)awakeFromNib{
    
     _arr_view = [[NSArray alloc] initWithObjects:_btn_first,_btn_secend,_btn_third,nil];
    
    [_arr_view autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:20.0 insetSpacing:YES matchedSizes:YES];
    _layout_bottom.constant = -165;
    [self layoutIfNeeded];

    
}

- (IBAction)tapAction:(id)sender {
    
    [self hide];
    
}


#pragma mark - public

-(void)show{
    
    [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
        _imageV_bg.alpha = 0.5f;
    } completion:^(BOOL finished){
        
    }];
    
    [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
        _layout_bottom.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished){
        
    }];
    
}

-(void)hide{
    [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
        _imageV_bg.alpha = 0.5f;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
            _layout_bottom.constant = -165;
            [self layoutIfNeeded];
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    }];
}

#pragma mark - buttonAciton

- (IBAction)btnFirstAciton:(id)sender {
    
    [self pushChildAlbumListVC:@3];
    
}

- (IBAction)btnSecondAction:(id)sender {
    
//    [self pushChildAlbumListVC:@1];
    ChildCustomizeVC *t_vc = [[ChildCustomizeVC alloc] init];
    
    id target = [self superview];
    
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[ChildMusicVC class]]) {
            break;
        }
    }
    
    ChildMusicVC *vc_target = (ChildMusicVC *)target;
    
    [vc_target.navigationController pushViewController:t_vc animated:YES];
}

- (IBAction)btnThirdAction:(id)sender {
    
    id target = [self superview];
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[ChildMusicVC class]]) {
            break;
        }
    }
    ChildMusicVC *vc_target = (ChildMusicVC *)target;
    
    LoadDownMediaVC *t_vc = [[LoadDownMediaVC alloc]init];
    [vc_target.navigationController pushViewController:t_vc animated:YES];

    
    
}

- (void)pushChildAlbumListVC:(NSNumber *)moreType{
    
    ChildMoreListVC *t_vc = [[ChildMoreListVC alloc] init];
    t_vc.moreType = [moreType integerValue];
    id target = [self superview];
    
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[ChildMusicVC class]]) {
            break;
        }
    }
    
    ChildMusicVC *vc_target = (ChildMusicVC *)target;
    
    [vc_target.navigationController pushViewController:t_vc animated:YES];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
