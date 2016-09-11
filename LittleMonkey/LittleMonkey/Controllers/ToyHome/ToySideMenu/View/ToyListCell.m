//
//  ToyListCell.m
//  LittleMonkey
//
//  Created by Hcat on 16/6/5.
//  Copyright © 2016年 CivetCatsTeam. All rights reserved.
//

#import "ToyListCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ToyListCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_select;


@end


@implementation ToyListCell

- (void)awakeFromNib {
    
    self.imageV_icon.layer.cornerRadius = (50 - 16)/2;
    self.imageV_icon.layer.masksToBounds = YES;
    self.imageV_icon.layer.borderWidth = 0.5f;
    self.imageV_icon.layer.borderColor = [UIColorFromRGB(0xff6948) CGColor];
    
}


- (void)setToy:(Toy *)toy{

    if (toy) {

        _toy = toy;
    
        [self.imageV_icon sd_setImageWithURL:[NSURL URLWithString:_toy.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        
        self.lb_title.text = _toy.nickname;
         [self.imageV_select setHidden:NO];
        
        if (_toy.toy_id.intValue == [ShareValue sharedShareValue].toyDetail.toy_id.intValue) {
            [self.lb_title setTextColor:UIColorFromRGB(0xff6948)];
            [self.imageV_select setImage:[UIImage imageNamed:@"icon_selected.png"]];
        } else {
            [self.imageV_select setImage:[UIImage imageNamed:@"icon_unSelected.png"]];
            [self.lb_title setTextColor:[UIColor blackColor]];
        }

    }else{
    
        
        
        [self.imageV_icon setImage:[UIImage imageNamed:@"icon_addToy.png"]];
        
        self.lb_title.text = @"绑定新设备";
        if (![ShareValue sharedShareValue].toyDetail) {
            [self.lb_title setTextColor:UIColorFromRGB(0xff6948)];
        }else{
            [self.lb_title setTextColor:[UIColor blackColor]];
        }
        
        [self.imageV_select setHidden:YES];
        
    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
