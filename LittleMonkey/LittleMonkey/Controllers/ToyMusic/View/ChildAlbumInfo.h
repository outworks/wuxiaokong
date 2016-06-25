//
//  ChildAlbumInfo.h
//  HelloToy
//
//  Created by huanglurong on 16/4/13.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMAlbum.h"

typedef void (^ChildAlbumInfoBlock)(XMAlbum *album);

@interface ChildAlbumInfo : UIView


@property (strong, nonatomic) XMAlbum *album;

@property (weak, nonatomic) IBOutlet UIButton *btn_icon;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;


@property (copy,nonatomic) ChildAlbumInfoBlock block;

@end
