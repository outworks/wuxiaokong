//
//  TransceiverDetailCell.m
//  HelloToy
//
//  Created by yull on 15/12/30.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "TransceiverDetailCell.h"
#import "UIImageView+WebCache.h"

@interface TransceiverDetailCell()
@property (strong, nonatomic) IBOutlet UIImageView *iconIV;
@property (strong, nonatomic) IBOutlet UIButton *playB;
@property (strong, nonatomic) IBOutlet UILabel *nameL;
@property (strong, nonatomic) IBOutlet UILabel *byL;
@property (strong, nonatomic) IBOutlet UIButton *playCountB;
@property (strong, nonatomic) IBOutlet UIButton *saveCountB;
@property (strong, nonatomic) IBOutlet UIButton *commentCountB;
@property (strong, nonatomic) IBOutlet UIButton *timeLengthL;
@property (strong, nonatomic) IBOutlet UILabel *timeL;
@property (strong, nonatomic) IBOutlet UIButton *downloadB;
@end

@implementation TransceiverDetailCell

- (void)awakeFromNib {
    // Initialization code
    
    self.iconIV.layer.cornerRadius = CGRectGetHeight(self.iconIV.frame)/2;
    self.iconIV.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setFmDetail:(FMDetail *)fmDetail{
    _fmDetail = fmDetail;
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:fmDetail.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
    _nameL.text = fmDetail.name;
    [_saveCountB setTitle:[NSString stringWithFormat:@" %lld", fmDetail.like_cnt.longLongValue] forState:0];
    [_commentCountB setTitle:[NSString stringWithFormat:@" %lld", fmDetail.reply_cnt.longLongValue] forState:0];
    _timeL.text = [fmDetail.play_date substringWithRange:NSMakeRange(0, 10)];
    NSMutableString *timeLengthStr = [NSMutableString string];
    if (fmDetail.duration.longValue >= 3600) {
        [timeLengthStr appendFormat:@" %ld:%02ld:%02ld", fmDetail.duration.longValue / 3600, fmDetail.duration.longValue % 3600 / 60, fmDetail.duration.longValue % 60];
    } else {
        [timeLengthStr appendFormat:@" %02ld:%02ld", fmDetail.duration.longValue / 60, fmDetail.duration.longValue % 60];
    }
    [_timeLengthL setTitle:timeLengthStr forState:0];
}


-(void)setPlaying:(BOOL)playing{
    [_playB setSelected:playing];
}

- (IBAction)playAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(playFm:)]) {
        [_delegate playFm:self];
    }
}


@end
