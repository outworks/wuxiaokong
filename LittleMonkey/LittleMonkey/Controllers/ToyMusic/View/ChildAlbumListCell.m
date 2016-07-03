//
//  ChildAlbumListCell.m
//  HelloToy
//
//  Created by huanglurong on 16/4/18.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildAlbumListCell.h"
#import "UIImageView+WebCache.h"
#import "DownloadAlbumInfo.h"

@interface ChildAlbumListCell()


@property (weak, nonatomic) IBOutlet UIImageView *imgV_icon;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_playCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_likeCount;

@property (weak, nonatomic) IBOutlet UIImageView *imgV_playNumber;

@property (weak, nonatomic) IBOutlet UIImageView *imgV_number;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_number;


@end


@implementation ChildAlbumListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setAlbum:(XMAlbum *)album{

    if (album) {
        
        _album = album;
        
        [_imgV_icon sd_setImageWithURL:[NSURL URLWithString:_album.coverUrlMiddle] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        _lb_title.text =_album.albumTitle;
        _lb_content.text = _album.albumIntro;
        
        if (_album.playCount > 10000) {
            _lb_playCount.text = [NSString stringWithFormat:@"%.1f万",_album.playCount/10000.0];
            _layout_number.constant = 15.f;
            [self layoutIfNeeded];
            
            
        }else{
            
            if (_album.playCount == 0) {
                _imgV_playNumber.hidden = YES;
                _lb_playCount.text = @"";
                _lb_playCount.hidden = YES;
                _layout_number.constant = -10.f;
                [self layoutIfNeeded];
                
            }else{
                
                _lb_playCount.text = [NSString stringWithFormat:@"%ld",_album.playCount];
                _layout_number.constant = 15.f;
                [self layoutIfNeeded];
            }
        
        }
        _lb_likeCount.text = [NSString stringWithFormat:@"%ld首",_album.includeTrackCount];
        
    }
    
}

-(void)setFm:(FM *)fm{

    if (fm) {
        
        _fm = fm;
        
        [_imgV_icon sd_setImageWithURL:[NSURL URLWithString:fm.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        _lb_title.text =fm.name;
        _lb_content.text = fm.desc;
        
        _lb_playCount.text = @"";
        
        _lb_likeCount.text = @"";
        
        _imgV_playNumber.hidden = YES;
        _imgV_number.hidden = YES;
        
        
        
    }

}

-(void)setDownloadAlbumInfo:(DownloadAlbumInfo *)downloadAlbumInfo{
    if (downloadAlbumInfo) {
        
        _downloadAlbumInfo = downloadAlbumInfo;
        
        [_imgV_icon sd_setImageWithURL:[NSURL URLWithString:_downloadAlbumInfo.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        _lb_title.text =_downloadAlbumInfo.name;
        _lb_content.text = _downloadAlbumInfo.desc;
        
        if ([_downloadAlbumInfo.cnt intValue]> 10000) {
            _lb_playCount.text = [NSString stringWithFormat:@"%.1f万",[_downloadAlbumInfo.cnt intValue]/10000.0];
            _layout_number.constant = 15.f;
            [self layoutIfNeeded];
        }else{
            
            if ([_downloadAlbumInfo.cnt intValue] == 0) {
                _imgV_playNumber.hidden = YES;
                _lb_playCount.text = @"";
                _lb_playCount.hidden = YES;
                _layout_number.constant = -10.f;
                [self layoutIfNeeded];
            }else{
            
                _lb_playCount.text = [NSString stringWithFormat:@"%ld",[_downloadAlbumInfo.cnt integerValue]];
                _layout_number.constant = 15.f;
                [self layoutIfNeeded];
            }
            
        }
        
        
        
        _lb_likeCount.text = [NSString stringWithFormat:@"%ld首",[_downloadAlbumInfo.download_count integerValue]];
    }

}

- (void)setAlbumInfo:(AlbumInfo *)albumInfo{

    if (albumInfo) {
        
        _albumInfo = albumInfo;
        
        [_imgV_icon sd_setImageWithURL:[NSURL URLWithString:_albumInfo.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        _lb_title.text =_albumInfo.name;
        _lb_content.text = _albumInfo.desc;
        
        if (_album.playCount > 10000) {
            _lb_playCount.text = [NSString stringWithFormat:@"%.1f万",[_albumInfo.cnt intValue]/10000.0];
            _layout_number.constant = 15.f;
            [self layoutIfNeeded];

        }else{
            
            if ([_albumInfo.cnt intValue] == 0) {
                _imgV_playNumber.hidden = YES;
                _lb_playCount.text = @"";
                _lb_playCount.hidden = YES;
                _layout_number.constant = -10.f;
                [self layoutIfNeeded];
            }else{
                
                _lb_playCount.text = [NSString stringWithFormat:@"%ld",[_albumInfo.cnt integerValue]];
                _layout_number.constant = 15.f;
                [self layoutIfNeeded];

            }
            
        }
        _lb_likeCount.text = [NSString stringWithFormat:@"%ld首",[_albumInfo.number integerValue]];
        
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
