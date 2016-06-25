//
//  GroupChatMessageCell.m
//  HelloToy
//
//  Created by apple on 15/10/20.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "GroupChatMessageCell.h"
#import "ShareValue.h"
#import "Toy.h"

#import "NDUserAPI.h"
#import "TimeTool.h"
#import "NSObject+LKDBHelper.h"
#import "UIImageView+WebCache.h"

#define MIN_CHAT_WIDTH 95
#define MAX_CHAT_WIDTH ScreenWidth/2
#define CROUPCELL_HEIGHT 90

@interface GroupChatMessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *lbTime;               //时间视图

@property (weak, nonatomic) IBOutlet UIView *vMyVoice;              //本人视图
@property (weak, nonatomic) IBOutlet UIImageView *ivMyVoiceBack;          //本人音频背景图
@property (weak, nonatomic) IBOutlet UIImageView *ivMyHeader;       //本人头像

@property (weak, nonatomic) IBOutlet UILabel *lbMyVoiceDuration;    //本人音频时长
@property (weak, nonatomic) IBOutlet UIImageView *ivMyVoice;        //本人播放视图



@property (weak, nonatomic) IBOutlet UIView *vOtherVoice;           //他人视图
@property (weak, nonatomic) IBOutlet UILabel *lb_userName;          //他人名称
@property (weak, nonatomic) IBOutlet UIImageView *ivOtherHeader;    //他人头像
@property (weak, nonatomic) IBOutlet UIImageView *ivOtherVoiceBack;       //他人音频背景图

@property (weak, nonatomic) IBOutlet UILabel *lbOtherVoiceDuration; //他人音频时长
@property (weak, nonatomic) IBOutlet UIImageView *ivOtherVoice;     //他人播放视图

@property (weak, nonatomic) IBOutlet UIImageView *ivRedPoint;       //是否是已读


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTimeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutOtherVoiceViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutOtherVoiceViewRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutOtherVoiceViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutOtherImageRight;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutMyVoiceViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutMyVoiceViewTop;


@property (nonatomic,strong) GCDTimer *timer; //定时器


@end

@implementation GroupChatMessageCell

- (void)awakeFromNib {
    // 设置头像为原形
    _ivMyHeader.layer.cornerRadius = _ivMyHeader.frame.size.width/2;
    _ivMyHeader.layer.masksToBounds = YES;
    
    _ivOtherHeader.layer.cornerRadius = _ivOtherHeader.frame.size.width/2;
    _ivOtherHeader.layer.masksToBounds = YES;
    
    //设置我的语音按钮背景图片
    UIImage *image_myVoice = [UIImage imageNamed:@"icon_talkbak_right.png"];
    image_myVoice = [image_myVoice stretchableImageWithLeftCapWidth:53/2 topCapHeight:43/2];
    [_ivMyVoiceBack setImage:image_myVoice];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speechAction:)];
    _ivMyVoiceBack.userInteractionEnabled = YES;
    [_ivMyVoiceBack addGestureRecognizer:tap];


    UIImage *image_otherVoice = [UIImage imageNamed:@"icon_talkbak_left.png"];
    image_otherVoice = [image_otherVoice stretchableImageWithLeftCapWidth:55/2 topCapHeight:43/2];
    [_ivOtherVoiceBack setImage:image_otherVoice];
     UITapGestureRecognizer *othertap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speechAction:)];
    _ivOtherVoiceBack.userInteractionEnabled = YES;
    [_ivOtherVoiceBack addGestureRecognizer:othertap];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - set&&get


#pragma mark - pubic methods

- (void)setCellWithData:(Mail *)mail andPioneerMail:(Mail *)pioneerMail andSendTimeArray:(NSMutableArray *)arySendTime
{
    _mail = mail;
    //设置发送时间
    if (pioneerMail == nil) {
        //显示发送时间
        [self setCellShowTime:YES];
    } else {
        if ([arySendTime containsObject:mail.send_time]) {
            //显示发送时间
            [self setCellShowTime:YES];
        } else {
            long timeInterval = [self timeIntervalBetween:mail andBeforeMail:pioneerMail];
            
            if (timeInterval > 5) {
                //显示发送时间
                [self setCellShowTime:YES];
            }else{
                //隐藏发送时间
                [self setCellShowTime:NO];
            }

        }
    }
    
    //通过音频读取状态设置小红点显示/隐藏
    if (mail.isRead) {
        _ivRedPoint.hidden = YES;
    } else {
        _ivRedPoint.hidden = NO;
    }
    
    if ([[mail.send_id stringValue] isEqualToString:[[ShareValue sharedShareValue].user.user_id stringValue]]) {
        //我的语音
        [self setMyVoiceViewHidden:NO];
        
         [self.ivMyHeader sd_setImageWithURL:[NSURL URLWithString:[ShareValue sharedShareValue].user.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        //设置音频时长
        self.lbMyVoiceDuration.text = [NSString stringWithFormat:@"%lds\"",(long)[mail.duration integerValue]];
        CGFloat myVoiceViewWidth = [self fitsWithVoiceWidthByDuration:(long)[mail.duration integerValue]] + 10 + 45;//10：离右侧的宽度
        self.layoutMyVoiceViewLeft.constant = ScreenWidth - myVoiceViewWidth;
    } else {
        //他人的语音
        [self setMyVoiceViewHidden:YES];
        [self setMessageIcon:mail];
        //设置音频时长
        self.lbOtherVoiceDuration.text = [NSString stringWithFormat:@"%lds\"",(long)[mail.duration integerValue]];
        CGFloat otherVoiceViewWidth = [self fitsWithVoiceWidthByDuration:(long)[mail.duration integerValue]] + 45 + 10;//45：除了按钮之外的宽度  20：离左侧的宽度
        self.layoutOtherVoiceViewRight.constant = ScreenWidth - otherVoiceViewWidth;
    }

}



- (void)setCellToyWithData:(Mail *)mail andPioneerMail:(Mail *)pioneerMail andSendTimeArray:(NSMutableArray *)arySendTime
{
    _mail = mail;
    //设置发送时间
    if (pioneerMail == nil) {
        //显示发送时间
        [self setCellShowTime:YES];
    } else {
        if ([arySendTime containsObject:mail.send_time]) {
            //显示发送时间
            [self setCellShowTime:YES];
        } else {
            long timeInterval = [self timeIntervalBetween:mail andBeforeMail:pioneerMail];
            
            if (timeInterval > 5) {
                //显示发送时间
                [self setCellShowTime:YES];
            }else{
                //隐藏发送时间
                [self setCellShowTime:NO];
            }
            
        }
    }
    
    //通过音频读取状态设置小红点显示/隐藏
    if (mail.isRead) {
        _ivRedPoint.hidden = YES;
    } else {
        _ivRedPoint.hidden = NO;
    }
    
    if ([[mail.send_id stringValue] isEqualToString:[[ShareValue sharedShareValue].toyDetail.toy_id stringValue]]) {
        //我的语音
        [self setMyVoiceViewHidden:NO];
        //设置音频时长
        self.lbMyVoiceDuration.text = [NSString stringWithFormat:@"%lds\"",(long)[mail.duration integerValue]];
        CGFloat myVoiceViewWidth = [self fitsWithVoiceWidthByDuration:(long)[mail.duration integerValue]] + 10;//10：离右侧的宽度
        self.layoutMyVoiceViewLeft.constant = ScreenWidth - myVoiceViewWidth;
        [self layoutIfNeeded];
    } else {
        //他人的语音
        [self setMyVoiceViewHidden:YES];
        [self setMessageIcon:mail];
        //设置音频时长
        self.lbOtherVoiceDuration.text = [NSString stringWithFormat:@"%lds\"",(long)[mail.duration integerValue]];
        CGFloat otherVoiceViewWidth = [self fitsWithVoiceWidthByDuration:(long)[mail.duration integerValue]] + 45 + 20;//45：除了按钮之外的宽度  20：离左侧的宽度
        self.layoutOtherVoiceViewRight.constant = ScreenWidth - otherVoiceViewWidth;
        [self layoutIfNeeded];
    }
    
}




+ (CGFloat)setHeightWithData:(Mail *)mail andPioneerMail:(Mail *)pioneerMail andSendTimeArray:(NSMutableArray *)arySendTime
{
    CGFloat messageTotalHeight = 0.0;
//    if (![[mail.send_id stringValue] isEqualToString:[[ShareValue sharedShareValue].user.user_id stringValue]])
//    {
//        messageTotalHeight += 5;//用户名的高度
//    }
    
    if (pioneerMail == nil) {
        return messageTotalHeight + CROUPCELL_HEIGHT;
    } else {
        if ([arySendTime containsObject:mail.send_time]) {
            return messageTotalHeight + CROUPCELL_HEIGHT;
        } else {
            NSDate *beforedate = [ShareFun changeSpToTime:pioneerMail.send_time];
            NSDate *maildate = [ShareFun changeSpToTime:mail.send_time];
            long  timeInterval = [ShareFun timeDifference:maildate withAfterDate:beforedate]/60;
            
            if (timeInterval > 5) {
                //显示时间
                return messageTotalHeight + CROUPCELL_HEIGHT;
            }else{
                //隐藏发送时间
                return messageTotalHeight + CROUPCELL_HEIGHT - 25;//25：时间的高度 
            }

        }
        
    }
}


#pragma mark - ButtonActions

//点击按钮，播放录音
- (IBAction)speechAction:(id)sender {
    
    _ivRedPoint.hidden = YES;
    
    if(_delegate && [_delegate respondsToSelector:@selector(onCellPlayVoiceDidClicked:)]){
        
        [_delegate onCellPlayVoiceDidClicked:self];
    
    }
}


#pragma mark - Functions

/**
 *	@brief 通过音频时长计算宽度
 *
 *	@param 	duration        当前播放音频的时长
 */
- (CGFloat)fitsWithVoiceWidthByDuration:(NSInteger)duration
{
    CGFloat min_width = MIN_CHAT_WIDTH;
    CGFloat max_width = MAX_CHAT_WIDTH;
    
    CGFloat t_f ;
    CGFloat t_width;
    if (duration > 0 && duration <= 1) {
        t_width = min_width;
    } else if (duration > 1 && duration <= 15) {
        t_f = ((max_width - min_width) * 0.5)/15.0;
        t_width = duration * t_f + min_width;
    }else if(duration >15 && duration <= 30){
        t_f = ((max_width - min_width) * 0.375)/15.0;
        t_width = ((duration-15) * t_f) + (max_width * 0.5) + min_width;
    }else if (duration >30 && duration <= 40){
        t_f = ((max_width - min_width) * 0.125)/10.0;
        t_width = ((duration-30) * t_f) + (max_width * 0.875) + min_width;
        
    }else{
        t_width = max_width;
    }
    return  t_width;
}

//设置显示/隐藏发送时间
-(void)setCellShowTime:(BOOL)isNeedShowTime{
    if (isNeedShowTime) {
        if (_mail) {
            NSDate *mailDate = [NSDate dateWithTimeIntervalSince1970:[_mail.send_time intValue]];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            long difference = [self timeDifference:mailDate]/3600;
            if (difference < 12) {
                [dateFormat setDateFormat:@"——  hh:mm a  ——"];
            }else if(difference < 24){
                [dateFormat setDateFormat:NSLocalizedString(@"——  昨天 hh:mm a  ——", nil)];
            }else{
                [dateFormat setDateFormat:@"——  yyyy-MM-dd hh:mm a  ——"];
            }
            NSString *string = [dateFormat stringFromDate:mailDate];
            _lbTime.text = string;
            self.layoutTimeHeight.constant = 25;
            self.layoutOtherVoiceViewTop.constant = 5;
            self.layoutMyVoiceViewTop.constant = 5;
            [self layoutIfNeeded];
        }
        
    }else{
        _lbTime.text = @"";
        self.layoutTimeHeight.constant = 0;
        self.layoutOtherVoiceViewTop.constant = 5;
        self.layoutMyVoiceViewTop.constant = 5;
        [self layoutIfNeeded];
    }
}

- (long)timeDifference:(NSDate *)date{
    
    NSDate *localeDate = [NSDate date];
    long difference =fabs([localeDate timeIntervalSinceDate:date]);
    return difference;
}

//设置时间格式

- (NSString*)dateToString:(NSDate *)date{
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:NSLocalizedString(@"yyyy年MM月dd日 HH:mm", nil)];
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}

//计算两个语音间的时间

- (long)timeIntervalBetween:(Mail *)mail andBeforeMail:(Mail *)beforeMail{
    
    NSDate *beforedate = [ShareFun changeSpToTime:beforeMail.send_time];
    NSDate *maildate = [ShareFun changeSpToTime:mail.send_time];
    long  timeInterval = [ShareFun timeDifference:maildate withAfterDate:beforedate]/60;
    
    return timeInterval;
}

//设置我的语音/他人的语音显示/隐藏

- (void)setMyVoiceViewHidden:(BOOL)hidden
{
    _vMyVoice.hidden = hidden;
    _vOtherVoice.hidden = !hidden;
}

//设置他人语音的头像

- (void)setMessageIcon:(Mail *)mail
{
    if ([mail.send_type isEqualToNumber:@0]) {
        
        UIImage *image_otherVoice = [UIImage imageNamed:@"icon_talkbak_left.png"];
        image_otherVoice = [image_otherVoice stretchableImageWithLeftCapWidth:55/2 topCapHeight:43/2];
        [_ivOtherVoiceBack setImage:image_otherVoice];
        _layoutOtherVoiceViewHeight.constant = 16.f;
        _layoutOtherImageRight.constant = 10.f;
        [self layoutIfNeeded];
        
        User *user = [self loadUserFromList:mail.send_id];
        if (!user) {
            //用户不存在的时候
            NDUserDetailParams *params = [[NDUserDetailParams alloc] init];
            params.id_list = [mail.send_id stringValue];
            [NDUserAPI userDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
                if ([data count] > 0) {
                    User *user = [self loadUserFromList:mail.send_id];
                    [self.ivOtherHeader sd_setImageWithURL:[NSURL URLWithString:user.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
                    self.lb_userName.text = user.nickname;
                }else{
                    [self.ivOtherHeader setImage:[UIImage imageNamed:@"icon_defaultuser"]];
                    self.lb_userName.text = @"匿名用户";
                }
                
            } Fail:^(int code, NSString *failDescript) {
                
                 [self.ivOtherHeader setImage:[UIImage imageNamed:@"icon_defaultuser"]];
                self.lb_userName.text = @"匿名用户";
                
            }];
        } else {
            //用户存在的时候
            [self.ivOtherHeader sd_setImageWithURL:[NSURL URLWithString:user.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
            self.lb_userName.text = user.nickname;
        }
        
    }else{
        
        UIImage *image_otherVoice = [UIImage imageNamed:@"icon_talkbak_toy.png"];
        image_otherVoice = [image_otherVoice stretchableImageWithLeftCapWidth:53/2 topCapHeight:60/2];
        [_ivOtherVoiceBack setImage:image_otherVoice];
        _layoutOtherVoiceViewHeight.constant = 5.f;
        _layoutOtherImageRight.constant = -14.f;
        [self layoutIfNeeded];
        
        Toy *toy = [self loadToyFromList:mail.send_id];
        if (toy) {
            if (toy.icon.length == 0) {
                [self.ivOtherHeader setImage:[UIImage imageNamed:@"icon_defaultuser"]];
            }else{
                
                 [self.ivOtherHeader sd_setImageWithURL:[NSURL URLWithString:toy.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
            
            }
           
            self.lb_userName.text = toy.nickname;
            
        } else {
            
            [self.ivOtherHeader setImage:[UIImage imageNamed:@"icon_defaultuser"]];
            self.lb_userName.text = @"匿名玩具";
        }
        
    }
    
}

- (void)setToyIcon:(NSString *)icon withNickName:(NSString *)nickName{
    
    [self.ivOtherHeader sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
    self.lb_userName.text = nickName;
}

//音频读取状态

/************** 音频读取状态 **************/

- (void)setCellReadingStatus:(Mail *)mail isMyVoice:(BOOL)isMyVoice
{
//    _ivRedPoint.hidden = YES;//bug907
    if (_timer) {
        [_timer destroy];
        [_timer dispatchRelease];
        _timer = nil;
    }
    __block  int statusType = 1;
    
    _timer = [[GCDTimer alloc] initInQueue:[GCDQueue mainQueue]];
    [_timer event:^{
        if (self.mail) {
            if (![mail.mail_id isEqual:self.mail.mail_id]) {
                //录音播放完之后
                if (_timer) {
                    [_timer destroy];
                    [_timer dispatchRelease];
                    _timer = nil;
                }
                
                if (isMyVoice) {
                    [_ivMyVoice setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_myvoice3"]]];
                }else{
                    [_ivOtherVoice setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_othervoice3"]]];
                }

            }else{
                // 每1秒执行一次你的event
                if (isMyVoice) {
                    [_ivMyVoice setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_myvoice%d",statusType]]];
                    statusType++;
                    if (statusType == 4) {
                        statusType = 1;
                    }
                }else{
                    [_ivOtherVoice setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_othervoice%d",statusType]]];
                    statusType++;
                    if (statusType == 4) {
                        statusType = 1;
                    }
                }
            }
        }
        
    } timeInterval:0.3 * NSEC_PER_SEC];
    [_timer start];
    
}

/************** 获取用户信息 **************/


- (User *)loadUserFromList:(NSNumber *)user_id {
    NSMutableArray *userList = [[NSMutableArray alloc]init];
    if ([ShareValue sharedShareValue].groupDetail) {
        userList = [User searchWithWhere:nil orderBy:nil offset:0 count:0];
        //userList = [ShareValue sharedShareValue].groupDetail.user_list;
    }
    
    if (userList && [userList count] != 0) {
    
        for (User *user in userList) {
            if ([user.user_id isEqualToNumber:user_id]) {
                return user;
                break;
            }
        }
        NSLog(@"没有这个User");
        return nil;
    }else{
        NSLog(@"没有这个User");
        return nil;
    }
    
}

/************** 获取玩具信息 **************/

- (Toy *)loadToyFromList:(NSNumber *)toy_id{
    NSMutableArray *toyList = [[NSMutableArray alloc]init];
    if ([ShareValue sharedShareValue].groupDetail) {
        toyList = [Toy searchWithWhere:nil orderBy:nil offset:0 count:0];
        //toyList = [ShareValue sharedShareValue].groupDetail.toy_list;
    }
    if (toyList && [toyList count]!= 0 ) {
        for (Toy *toy in toyList) {
            if ([toy.toy_id isEqualToNumber:toy_id]) {
                return toy;
                break;
            }
        }
        NSLog(@"没有这个Toy");
        return nil;
    }else{
        NSLog(@"没有这个Toy");
        return nil;
    }
}

@end
