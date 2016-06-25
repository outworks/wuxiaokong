//
//  HaloSquareCell.m
//  HelloToy
//
//  Created by apple on 16/1/25.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "HaloSquareCell.h"

#define BUTTON_ORIGIN_X ((([UIScreen mainScreen].bounds.size.width == 320) ? 0 : 10)+ (i%3)*(63 + (_vBackground.frame.size.width - (63 * 3))/3.0))

@interface HaloSquareCell ()

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIImageView *ivHead;
@property (weak, nonatomic) IBOutlet UIView *vBackground;
@property (assign, nonatomic) int indexPath;

@end

@implementation HaloSquareCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetCellData:(NSArray *)typeArray andIndexPath:(int)indexPath andData:(NSDictionary *)dataDict
{
    _indexPath = indexPath;
    _lbName.text = typeArray[indexPath];
    _ivHead.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_category_%d",indexPath + 1]];
    
    NSArray *contentArray = [dataDict valueForKey:typeArray[indexPath]];
    
    NSArray *subViews = _vBackground.subviews;
    
    for (UIButton *button in subViews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setTitle:contentArray[button.tag - 100] forState:UIControlStateNormal];
            UIImage *image_n = [UIImage imageNamed:@"icon_tagbutton_n"];
            image_n = [image_n stretchableImageWithLeftCapWidth:image_n.size.width/2.0-1 topCapHeight:image_n.size.height/2.0-1];
            [button setBackgroundImage:image_n forState:UIControlStateNormal];
            UIImage *image_h = [UIImage imageNamed:@"icon_tagbutton_h"];
            image_h = [image_h stretchableImageWithLeftCapWidth:image_h.size.width/2.0-1 topCapHeight:image_h.size.height/2.0-1];
            [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];

        }
    }
    
}

+ (float)resetCellHeight
{
    return 135;
}

- (void)buttonDidClick:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(buttonClickAction:andHaloSquareCell:andIndexPath:)]) {
        [_delegate buttonClickAction:button andHaloSquareCell:self andIndexPath:_indexPath];
    }
    
}

@end
