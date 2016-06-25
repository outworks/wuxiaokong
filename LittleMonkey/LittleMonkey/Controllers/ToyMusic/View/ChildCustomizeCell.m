//
//  ChildCustomizeCell.m
//  HelloToy
//
//  Created by huanglurong on 16/4/21.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildCustomizeCell.h"
#import "UIImageView+WebCache.h"

@interface ChildCustomizeCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_type;
@property (weak, nonatomic) IBOutlet UIImageView *icon_arrows;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;


@property (weak, nonatomic) IBOutlet UIImageView *imgV_selected;


@end

@implementation ChildCustomizeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imgV_selected.hidden = YES;
    _icon_arrows.hidden = YES;
    _imageV_icon.layer.cornerRadius = 5.f;
    _imageV_icon.layer.masksToBounds = YES;
    
    // Initialization code
}

- (void)setAlbumInfo:(AlbumInfo *)albumInfo{

    if (albumInfo) {
        
        _albumInfo = albumInfo;
        
        _lb_title.text = _albumInfo.name;
        if ([_albumInfo.album_type isEqualToNumber:@0]) {
            _lb_type.text = @"故事";
        }else{
            _lb_type.text = @"音乐";
        }
        
        [_imageV_icon sd_setImageWithURL:[NSURL URLWithString:_albumInfo.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        
    }
    
}

- (void)setAlbumInfo_selected:(AlbumInfo *)albumInfo_selected{

    if (albumInfo_selected) {
        
        _albumInfo_selected = albumInfo_selected;
       
        if ([_albumInfo_selected.album_id isEqualToNumber:_albumInfo.album_id]) {
            _imgV_selected.hidden = NO;
        }else{
            _imgV_selected.hidden = YES;
        }
    
    }

}

- (void)setIsAdd:(BOOL)isAdd{
    
    _isAdd = isAdd;
    
    if (_isAdd) {
        
        _icon_arrows.hidden = YES;
        
    }else{
    
        _icon_arrows.hidden = NO;
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
