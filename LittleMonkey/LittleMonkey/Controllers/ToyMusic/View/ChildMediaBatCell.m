//
//  ChildMediaBatCell.m
//  HelloToy
//
//  Created by huanglurong on 16/4/29.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildMediaBatCell.h"

@interface ChildMediaBatCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_check;
@property (weak, nonatomic) IBOutlet UILabel *lb_size;



@end



@implementation ChildMediaBatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - privateMethods


- (void)setAlbumMedia:(AlbumMedia *)albumMedia{

    if (albumMedia) {
        
        _albumMedia = albumMedia;
        _lb_title.text = _albumMedia.name;
        _lb_size.text = @"";
        
        if (![_albumMedia.download isEqualToNumber:@1]) {
            [_lb_size setText:@"下载中"];
            [_btn_check setImage:[UIImage imageNamed:@"checkbox_disable"] forState:UIControlStateNormal];
            _btn_check.selected = NO;
            _btn_check.userInteractionEnabled = NO;
        }else{
            [_lb_size setText:@"可播放"];
            [_btn_check setImage:[UIImage imageNamed:@"checkbox_uncheck_1"] forState:UIControlStateNormal];
            _btn_check.userInteractionEnabled = YES;

        }

    }

}

- (void)setAlbum_xima:(XMTrack *)album_xima{
    
    if (album_xima) {
        
        _album_xima = album_xima;
        
        _lb_title.text = _album_xima.trackTitle;
        if (_album_xima.playSize32 > 1024*1024) {
            _lb_size.text = [NSString stringWithFormat:@"%.2fMB",_album_xima.playSize32/(1024.f*1024.f)];
        }else{
            _lb_size.text = [NSString stringWithFormat:@"%.1fKB",_album_xima.playSize32/1024.f];
        }
        
    }
    
}


- (void)setDownloadStatus:(MediaDownloadStatus *)downloadStatus{
    
    if (downloadStatus) {
        
        _downloadStatus = downloadStatus;
        
        if ([_downloadStatus.download isEqualToNumber:@0]) {
            [_lb_size setText:@"未下载"];
            [_btn_check setImage:[UIImage imageNamed:@"checkbox_uncheck_1"] forState:UIControlStateNormal];
            _btn_check.userInteractionEnabled = YES;
            
            
        }else if ([_downloadStatus.download isEqualToNumber:@1]){
            [_lb_size setText:@"已下载"];
            [_btn_check setImage:[UIImage imageNamed:@"checkbox_disable"] forState:UIControlStateNormal];
            _btn_check.selected = NO;
            _btn_check.userInteractionEnabled = NO;
            
            
            
        }else if ([_downloadStatus.download isEqualToNumber:@2]){
            [_lb_size setText:@"下载中"];
            [_btn_check setImage:[UIImage imageNamed:@"checkbox_disable"] forState:UIControlStateNormal];
            _btn_check.selected = NO;
            _btn_check.userInteractionEnabled = NO;
            
        }
        
    }
}

- (IBAction)btnCheckAction:(id)sender {
    
    UIButton *t_btn = (UIButton *)sender;
    
    t_btn.selected = !t_btn.selected;

    if (_block_bat) {
        self.block_bat(self,t_btn.selected);
    }
    
}

- (void)setIsSelected:(BOOL)isSelected{

    _isSelected = isSelected;
    
    _btn_check.selected = _isSelected;
        
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
