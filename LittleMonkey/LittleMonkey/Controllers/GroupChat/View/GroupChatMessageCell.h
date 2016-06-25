//
//  GroupChatMessageCell.h
//  HelloToy
//
//  Created by apple on 15/10/20.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mail.h"

@protocol GroupChatMessageCellDelegate;

@interface GroupChatMessageCell : UITableViewCell

@property (nonatomic,strong) Mail *mail;
@property (weak, nonatomic) id<GroupChatMessageCellDelegate> delegate;


- (void)setToyIcon:(NSString *)icon withNickName:(NSString *)nickName;

/*************** 用于是否显示时间 ***************/

- (void)setCellWithData:(Mail *)mail andPioneerMail:(Mail *)pioneerMail andSendTimeArray:(NSMutableArray *)arySendTime;

- (void)setCellToyWithData:(Mail *)mail andPioneerMail:(Mail *)pioneerMail andSendTimeArray:(NSMutableArray *)arySendTime;

+ (CGFloat)setHeightWithData:(Mail *)mail andPioneerMail:(Mail *)pioneerMail andSendTimeArray:(NSMutableArray *)arySendTime;


/*************** 音频读取状态 ***************/

- (void)setCellReadingStatus:(Mail *)mail isMyVoice:(BOOL)isMyVoice;

@end


@protocol GroupChatMessageCellDelegate <NSObject>

/*************** 单击读语音 ***************/

- (void)onCellPlayVoiceDidClicked:(GroupChatMessageCell *)cell;


@end