//
//  ToyContactCell.m
//  HelloToy
//
//  Created by huanglurong on 16/3/8.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ToyContactCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <NSDate_TimeAgo/NSDate+TimeAgo.h>
#import "TimeTool.h"

@interface ToyContactCell()


@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@end

@implementation ToyContactCell

- (void)awakeFromNib {
    // Initialization code
    
    self.imageV_icon.layer.cornerRadius = self.imageV_icon.frame.size.width/2;
    self.imageV_icon.layer.masksToBounds = YES;
    
}

- (void)setContactGmail:(ContactGmail *)contactGmail{

    if (contactGmail) {
        _contactGmail = contactGmail;
        
        [_imageV_icon sd_setImageWithURL:[NSURL URLWithString:_contactGmail.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        _lb_title.text = _contactGmail.nickname;
        _lb_time.text =  [TimeTool timeAgoFromTranTime:_contactGmail.time];
        
    }

}


//- (NSString*)dateToString:(NSDate *)date{
//    
//    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
//    [dateFormat setDateFormat:NSLocalizedString(@"YMDHM2DateFormat", nil)];
//    NSString* string=[dateFormat stringFromDate:date];
//    return string;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
