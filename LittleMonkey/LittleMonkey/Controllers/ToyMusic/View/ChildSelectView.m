//
//  ChildSelectView.m
//  HelloToy
//
//  Created by huanglurong on 16/4/27.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildSelectView.h"
#import "PureLayout.h"

@interface ChildSelectView()


@property (weak, nonatomic) IBOutlet UIView *v_top;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_bg;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_height;
@property (nonatomic,strong) NSMutableArray *arr_viewTag;

@end


@implementation ChildSelectView

+ (ChildSelectView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ChildSelectView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.arr_viewTag = [NSMutableArray new];

    // Initialization code
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
        _layout_top.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished){
        
    }];
    
}

-(void)hide{
    [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
        _imageV_bg.alpha = 0.5f;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
            _layout_top.constant = 0;
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    }];
}

-(void)setUpLabels:(NSInteger)number WithIndex:(NSInteger)index{

    NSMutableArray *arr_v = [NSMutableArray new];
  
    NSInteger tagNumber = number/20;
    
    if (number%20 != 0) {
        tagNumber += 1;
    }
    
    for (int i = 1;i <= tagNumber; i++) {
        
        UIButton *t_button = [UIButton newAutoLayoutView];
        
        [t_button setTitle:[NSString stringWithFormat:@"%d~%ld",(i-1)*20+1,i == tagNumber?number:i*20] forState:UIControlStateNormal];
        [t_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [t_button.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        if (i == index) {
            
            [t_button setBackgroundColor:UIColorFromRGB(0xf86442)];
            
        }else{
             [t_button setBackgroundColor:UIColorFromRGB(0xd9dfe5)];
        }
        
        t_button.tag = i +100;
        [t_button addTarget:self action:@selector(btnTagAction:) forControlEvents:UIControlEventTouchUpInside];
        t_button.layer.cornerRadius = 4.0f;
        [t_button autoSetDimension:ALDimensionHeight toSize:25];
        [_v_top addSubview:t_button];
        [_arr_viewTag addObject:t_button];
        
        if ( i % 4 == 1) {
            
            if (arr_v && [arr_v count] > 0) {
                
                [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:10.0 insetSpacing:YES matchedSizes:YES];
                
                
                [arr_v removeAllObjects];
                
            }
            
            if ( i ==  1){
                
                [t_button autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_v_top withOffset:10.0];
                
            }else{
                
                UIButton *btn_before = _arr_viewTag[i - 4];
                
                [t_button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:btn_before withOffset:10.0];
                
            }
            
        }
        
        [arr_v addObject:t_button];
    }
    
    if ([arr_v count] == 1) {
        
        UIButton *btn_before = arr_v[0];
        [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 5*10)/4];
        [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0f];
        
        
    }else if ([arr_v count] == 2){
        
        UIButton *btn_before = arr_v[0];
        UIButton *btn_after = arr_v[1];
        [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 5*10)/4];
        [btn_after autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 5*10)/4];
        
        [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0f];
        [btn_after autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_before withOffset:10.0];
        
        [arr_v autoAlignViewsToAxis:ALAxisHorizontal];
        
    }else if ([arr_v count] == 3){
        
        UIButton *btn_before = arr_v[0];
        UIButton *btn_after = arr_v[1];
        UIButton *btn_third = arr_v[2];
        [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 5*10)/4];
        [btn_after autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 5*10)/4];
        [btn_third autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 5*10)/4];
        
        [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0f];
        [btn_after autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_before withOffset:10.0];
        [btn_third autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_after withOffset:10.0];
    
        [arr_v autoAlignViewsToAxis:ALAxisHorizontal];
    }else if ([arr_v count] == 4){
        
        UIButton *btn_before = arr_v[0];
        UIButton *btn_after = arr_v[1];
        UIButton *btn_third = arr_v[2];
         UIButton *btn_fourth = arr_v[3];
        [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 5*10)/4];
        [btn_after autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 5*10)/4];
        [btn_third autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 5*10)/4];
        [btn_fourth autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 5*10)/4];
        
        [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0f];
        [btn_after autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_before withOffset:10.0];
        [btn_third autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_after withOffset:10.0];
        [btn_fourth autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_third withOffset:10.0];

        
        [arr_v autoAlignViewsToAxis:ALAxisHorizontal];
    }
    
    [arr_v removeAllObjects];
    
    if (_arr_viewTag && [_arr_viewTag count] > 0) {
        
        if ([_arr_viewTag count] % 4 == 0) {
            
            _layout_height.constant = 10 + [_arr_viewTag count]/4*35;
            
        }else{
            
            _layout_height.constant =  10 + ([_arr_viewTag count]/4 + 1 )*35 ;
        }
        
    }
    
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

- (IBAction)btnTagAction:(id)sender{
    
    NSInteger tag = [sender tag];
    
    for (UIButton *t_btn in _arr_viewTag) {
        [t_btn setBackgroundColor:UIColorFromRGB(0xd9dfe5)];
    }
    
    UIButton *btn = (UIButton *)sender;
    
    [btn setBackgroundColor:UIColorFromRGB(0xf86442)];

    if (_block_tag) {
        self.block_tag(tag-100);
    }
    
}



@end
