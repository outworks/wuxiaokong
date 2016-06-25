//
//  ChildSortCell.m
//  HelloToy
//
//  Created by huanglurong on 16/4/13.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildSortCell.h"
#import "ChildAlbumInfo.h"
#import "XMSDK.h"
#import "PureLayout.h"


@interface ChildSortCell()

@property (weak, nonatomic) IBOutlet UIView *v_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_tagTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgV_topLine;
@property (weak, nonatomic) IBOutlet UIButton *btn_more;



@property (weak, nonatomic) IBOutlet UIView *v_loading;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *act_loading;

@property (strong,nonatomic) NSMutableArray *arr_view;
@property (strong,nonatomic) NSMutableArray *arr_viewTag;



@end

@implementation ChildSortCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.arr_view = [NSMutableArray new];
    self.arr_viewTag = [NSMutableArray new];
    _imgV_topLine.translatesAutoresizingMaskIntoConstraints = NO;
    _v_content.translatesAutoresizingMaskIntoConstraints = NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMArr_album:(NSMutableArray *)mArr_album{

    if (mArr_album) {
        
        _mArr_album = mArr_album;
        
         _btn_more.hidden = NO;
        
        if (_arr_viewTag && [_arr_viewTag count] > 0) {
            
            for (UIButton *t_button in _arr_viewTag) {
                t_button.hidden = YES;
            }
        
        }
    
        if (_arr_view && [_arr_view count] > 0) {
            
            for (ChildAlbumInfo *ablumInfo in _arr_viewTag) {
                ablumInfo.hidden = YES;
            }
            
            for (int i = 0;i < [_mArr_album count]; i++) {
                
                if (i == 3) {
                    
                    break;
                }
                
                XMAlbum * album = _mArr_album[i];
                
                ChildAlbumInfo *ablumInfo  = _arr_view[i];
                ablumInfo.hidden = NO;
                ablumInfo.album = album;
                
                __weak typeof(self) weakSelf = self;
                
                ablumInfo.block = ^(XMAlbum *album){
                    
                    if (weakSelf.block_album) {
                        
                        weakSelf.block_album(weakSelf,album);
                        
                    }
                    
                };
              
            }
            
        }else{
            
            for (int i = 0;i < [_mArr_album count]; i++) {
                
                if (i == 3) {
                    
                    break;
                }
                
                XMAlbum * album = _mArr_album[i];
                
                ChildAlbumInfo *ablumInfo  = [[[NSBundle mainBundle] loadNibNamed:@"ChildAlbumInfo" owner:nil options:nil] lastObject];
                ablumInfo.album = album;
                
                __weak typeof(self) weakSelf = self;
                
                ablumInfo.block = ^(XMAlbum *album){
                    
                    if (weakSelf.block_album) {
                        
                        weakSelf.block_album(weakSelf,album);
                        
                    }
                    
                };
                [_v_content addSubview:ablumInfo];
                ablumInfo.translatesAutoresizingMaskIntoConstraints = NO;
                if (i == 1) {
                    
                    [ablumInfo autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.imgV_topLine withOffset:10.0];
                    
                }
                
                [_arr_view addObject:ablumInfo];
                
            }
            
            if (_arr_view && [_arr_view count] > 0) {
                
                [_arr_view autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:15.0 insetSpacing:YES matchedSizes:YES];
                
                ChildAlbumInfo *ablumInfo = _arr_view[0];
                
                [_arr_view autoSetViewsDimension:ALDimensionHeight toSize:(ScreenWidth - 4*15)/3 + 40.0];
                
                [ablumInfo autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.imgV_topLine withOffset:10.0];
                
                //            [ablumInfo autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.v_content withOffset:5.0];
                
            }
            
            [self setNeedsUpdateConstraints];
            [self updateConstraintsIfNeeded];
            
            [self setNeedsLayout];
            [self layoutIfNeeded];
            
            
            
        }

    }
    
}

- (void)setMArr_tag:(NSMutableArray *)mArr_tag{

    if (mArr_tag) {
        
        _mArr_tag = mArr_tag;
        
        _btn_more.hidden = YES;
        
        
        if (_arr_view && [_arr_view count] > 0) {
            
            for (ChildAlbumInfo *ablumInfo in _arr_view) {
                ablumInfo.hidden = YES;
            }
            
        }
        
        if (_arr_viewTag && [_arr_viewTag count] > 0) {
            
            for (UIButton *t_button in _arr_viewTag) {
                t_button.hidden = YES;
            }
            
            for (int i = 0;i < [_mArr_tag count]; i++) {
                
                XMTag *tag  = _mArr_tag[i];
                
                UIButton *t_button  = _arr_viewTag[i];
                t_button.hidden = NO;
                [t_button setTitle:tag.tagName forState:UIControlStateNormal];
                t_button.tag = i +100;
                [t_button addTarget:self action:@selector(btnTagAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }else{
        
            NSMutableArray *arr_v = [NSMutableArray new];
            
            for (int i = 0;i < [_mArr_tag count]; i++) {
                
                XMTag *tag  = _mArr_tag[i];
                
                UIButton *t_button = [UIButton newAutoLayoutView];
                UIImage *image_n = [UIImage imageNamed:@"icon_tagbutton_n"];
                image_n = [image_n stretchableImageWithLeftCapWidth:image_n.size.width/2.0-1 topCapHeight:image_n.size.height/2.0-1];
                [t_button setBackgroundImage:image_n forState:UIControlStateNormal];
                [t_button setTitle:tag.tagName forState:UIControlStateNormal];
                [t_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [t_button.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
                t_button.tag = i +100;
                [t_button addTarget:self action:@selector(btnTagAction:) forControlEvents:UIControlEventTouchUpInside];
                [t_button autoSetDimension:ALDimensionHeight toSize:25];
                [_v_content addSubview:t_button];
                [_arr_viewTag addObject:t_button];
                
                if ( i % 3 == 0) {
                    
                    if (arr_v && [arr_v count] > 0) {
                        
                        [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:10.0 insetSpacing:YES matchedSizes:YES];
                        
                        
                        [arr_v removeAllObjects];
                        
                    }
                    
                    if ( i ==  0){
                        
                        [t_button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.imgV_topLine withOffset:10.0];
                        
                    }else{
                        
                        UIButton *btn_before = _arr_viewTag[i - 3];
                        
                        [t_button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:btn_before withOffset:5.0];
                        
                    }
                    
                }
                
                [arr_v addObject:t_button];
            }
            
            if ([arr_v count] == 1) {
                
                UIButton *btn_before = arr_v[0];
                [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 4*10)/3];
                [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0f];
                
                
            }else if ([arr_v count] == 2){
                
                UIButton *btn_before = arr_v[0];
                UIButton *btn_after = arr_v[1];
                [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 4*10)/3];
                [btn_after autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 4*10)/3];
                
                [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0f];
                 [btn_after autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_before withOffset:10.0];
                
                [arr_v autoAlignViewsToAxis:ALAxisHorizontal];
            
            }
            
            [arr_v removeAllObjects];
            
            
            
            [self setNeedsUpdateConstraints];
            [self updateConstraintsIfNeeded];
            
            [self setNeedsLayout];
            [self layoutIfNeeded];
        
        }
    
    }

}

- (void)setIsLoaded:(BOOL)isLoaded{

    _isLoaded = isLoaded;
    
    if (_isLoaded) {
        
        _v_loading.hidden = YES;
        [_act_loading stopAnimating];
        
    }else{
        
        _v_loading.hidden = NO;
        [_act_loading startAnimating];
        
        if (_arr_view && [_arr_view count] > 0) {
            
            for (ChildAlbumInfo *ablumInfo in _arr_view) {
                ablumInfo.hidden = YES;
            }
            
        }
        
        if (_arr_viewTag && [_arr_viewTag count] > 0) {
            
            for (UIButton *t_button in _arr_viewTag) {
                t_button.hidden = YES;
            }
            
        }
        
    }
    
}

- (void)setChildTag:(NSString *)ChildTag{

    if (ChildTag) {
        
        _ChildTag = ChildTag;
        _lb_tagTitle.text = _ChildTag;
        
    }

}


- (IBAction)btnMoreAlbumAction:(id)sender {
    
    if (_block_more) {
        self.block_more(self);
    }
    
}

- (IBAction)btnTagAction:(id)sender{

    NSInteger tag = [sender tag];

    if (_block_tag) {
        self.block_tag(self,_mArr_tag[tag-100]);
    }
    
}


@end
