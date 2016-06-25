//
//  SearchCell.m
//  HelloToy
//
//  Created by apple on 15/11/2.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "SearchCell.h"

#import "UIButton+Block.h"
#import "UIImageView+WebCache.h"

@interface SearchCell ()

@property (weak, nonatomic) IBOutlet UIImageView *ivHeader;
@property (weak, nonatomic) IBOutlet UILabel *lbNickName;
@property (weak, nonatomic) IBOutlet UILabel *lbGroupId;
@property (weak, nonatomic) IBOutlet UIButton *btnJoin;

@end

@implementation SearchCell

- (void)awakeFromNib {
    // 设置头像为原形
    _ivHeader.layer.cornerRadius = _ivHeader.frame.size.width/2;
    _ivHeader.layer.masksToBounds = YES;
    
    [_btnJoin handleClickEvent:UIControlEventTouchUpInside withClickBlick:^{
        //加入
        if(_delegate && [_delegate respondsToSelector:@selector(searchCellJoinDidClick:andSearchCell:)]){
            [_delegate searchCellJoinDidClick:self.btnJoin andSearchCell:self];
        }
    }];
}

- (void)setCellDataWithGroupDetail:(GroupDetail *)groupDetail
{
    if (groupDetail) {
        _groupDetail = groupDetail;
        _lbGroupId.text = [groupDetail.group_id stringValue];
        _lbNickName.text = groupDetail.name;
        [_ivHeader sd_setImageWithURL:[NSURL URLWithString:groupDetail.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
    }
}

+ (CGFloat)height
{
    return 55;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
