//
//  ToyChoice.m
//  HelloToy
//
//  Created by nd on 15/5/12.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "ToyChoice.h"
#import "MemberItem.h"
#import "UIButton+WebCache.h"

@implementation ToyChoice

+ (ToyChoice *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ToyChoice" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

-(void)setArr_data:(NSMutableArray *)arr_data{
    
    if (arr_data) {
        _index = -1;
        _arr_data = arr_data;
        for (int i = 0; i < [_arr_data count]; i++) {
            id class = _arr_data[i];
            if([class isKindOfClass:[NSDictionary class]]){
                _lb_info.text = NSLocalizedString(@"分享给好友", nil);
                
                NSDictionary *t_dic = (NSDictionary *)class;
                NSString *icon = [t_dic objectForKey:@"icon"];
                NSString *title = [t_dic objectForKey:@"title"];
                MemberItem *item = [MemberItem initCustomView];
                
                [item setDelegate:(id<MemberItemDelegate>)self];
                item.tag = i;
                item.isSelected = NO;
                item.btn_userIcon.layer.cornerRadius = item.btn_userIcon.frame.size.width/2;
                item.btn_userIcon.layer.masksToBounds = YES;
                item.btn_userIcon.layer.borderWidth = 0.5f;
                item.btn_userIcon.layer.borderColor = [[UIColor clearColor] CGColor];
                [item.btn_userIcon setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
                [item.btn_userIcon setContentMode:UIViewContentModeCenter];
                item.lb_name.text = title;
            
                [item setFrame:CGRectMake(i * _scrollow.frame.size.width/2, 0, _scrollow.frame.size.width/2, _scrollow.frame.size.height)];
                [_scrollow addSubview:item];
            }
            
            [_scrollow setContentSize:CGSizeMake([_arr_data count] * _scrollow.frame.size.width/2, _scrollow.frame.size.height)];
        }
        
        
    }
    
}

-(void) checkOutUserInfo:(MemberItem *)item{
    
    NSInteger tag = item.tag;
    id class = _arr_data[tag];
    if ([class isKindOfClass:[Toy class]]) {
        _index = tag;
        [self setSelectedIndex:tag];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(checkButtonIndex:)]) {
        [_delegate checkButtonIndex:tag];
    }

}



-(void)show{

    [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
        _imageV_bg.alpha = 0.5f;
    } completion:^(BOOL finished){
        
    }];
    
    [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
        CGRect frame = _v_bottom.frame;
        frame.origin.y = frame.origin.y - 138;
        _v_bottom.frame = frame;
    } completion:^(BOOL finished){
        
    }];
    
}

- (IBAction)tapAction:(id)sender {
   
    if (_index != -1) {
        if (_delegate && [_delegate respondsToSelector:@selector(checkButtonIndex:)]) {
            [_delegate checkButtonIndex:_index];
        }
    }else {
     [self hide];
    }
    
}


-(void)setSelectedIndex:(NSInteger)tag{
   
    id class = _arr_data[tag];
    if ([class isKindOfClass:[Toy class]]) {
         _index = tag;
        for (UIView *t_view  in _scrollow.subviews) {
            if ([t_view isKindOfClass:[MemberItem class]]) {
                MemberItem *item = (MemberItem *)t_view;
                if (item.tag == tag) {
                    item.isSelected = YES;
                }else{
                    item.isSelected = NO;
                }
                
            }
            
        }
        
    }
}

-(void)hide{
    [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
        _imageV_bg.alpha = 0.5f;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
            CGRect frame = _v_bottom.frame;
            frame.origin.y = frame.origin.y + 138;
            _v_bottom.frame = frame;
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    }];
}


@end
