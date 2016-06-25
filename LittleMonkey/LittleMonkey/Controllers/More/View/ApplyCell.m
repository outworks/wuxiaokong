//
//  ApplyCell.m
//  HelloToy
//
//  Created by ilikeido on 15/12/15.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "ApplyCell.h"
#import "UIImageView+WebCache.h"

@interface ApplyCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIImageView *iv_icon;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_type;

@end

@implementation ApplyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMsgText:(MsgText *)msgText{
    _msgText = msgText;
    _lb_type.text = _msgText.msg_title;
    _lb_title.text = msgText.msg_content;
    _lb_time.text = [self tranTime: msgText.msg_time];
    [_iv_icon sd_setImageWithURL:[NSURL URLWithString:msgText.msg_img] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
}

- (IBAction)agreeAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(applyCellClickApply:)]) {
        [_delegate applyCellClickApply:self];
    }
}


//时间戳转为时间
- (NSString *)tranTime:(NSNumber *)timeNumber
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //设置时区
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeNumber.intValue];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}


@end
