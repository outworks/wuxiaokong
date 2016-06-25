//
//  SubscibeTimeCell.m
//  HelloToy
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "SubscibeTimeCell.h"

@implementation SubscibeTimeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetCellData:(NSMutableArray *)subscibeTimeMuArray andRow:(int)row andSelectedTime:(NSString *)selectedTimeString
{
    NSArray *subViews = self.contentView.subviews;
    for (UIButton *button in subViews) {
        if ([button isKindOfClass:[UIButton class]]) {
            NSString *titleString = subscibeTimeMuArray[((row * 3) + (button.tag - 100)) - 1];
            [button setTitle:[NSString stringWithFormat:@" %@",titleString] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@" %@",titleString] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
            if ([titleString isEqualToString:selectedTimeString]) {
                button.selected = YES;
            } else {
                button.selected = NO;
            }
        }
    }
}

+ (float)resetCellHeight
{
    return 42;
}

- (void)buttonDidClick:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(handleButtonDidClick:andSubscibeTimeCell:)]) {
        [_delegate handleButtonDidClick:button andSubscibeTimeCell:self];
    }
}

@end
