//
//  ChildAlbumInfo.m
//  HelloToy
//
//  Created by huanglurong on 16/4/13.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildAlbumInfo.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ChildAlbumInfo

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *myTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapEvent:)];
    _imageV_icon.userInteractionEnabled = YES;
    [_imageV_icon addGestureRecognizer:myTapGesture];

}


- (void)setAlbum:(XMAlbum *)album{

    if (album) {
        
        _album = album;
        self.backgroundColor = [UIColor clearColor];
//        [self.btn_icon sd_setBackgroundImageWithURL:[NSURL URLWithString:album.coverUrlMiddle] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_default_info"]];
//        [self.btn_icon sd_setBackgroundImageWithURL:[NSURL URLWithString:album.coverUrlMiddle] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"icon_default_info"]];
        
        [self.imageV_icon sd_setImageWithURL:[NSURL URLWithString:album.coverUrlMiddle] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        self.lb_title.text = album.albumTitle;
        
    }
    
}

-(void)gestureTapEvent:(UITapGestureRecognizer *)gesture {
    
    UIImageView* myImageView = (UIImageView*)gesture.view ;
    if (_block) {
        self.block(_album);
    }
    
}



- (IBAction)btnIconAction:(id)sender {
    if (_block) {
        self.block(_album);
    }
    
}


@end
