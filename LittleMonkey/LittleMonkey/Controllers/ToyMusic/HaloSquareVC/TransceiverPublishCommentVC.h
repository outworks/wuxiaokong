//
//  TransceiverPublishCommentVC.h
//  HelloToy
//
//  Created by yull on 15/12/30.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "FMDetail.h"

@interface TransceiverPublishCommentVC : HideTabSuperVC

@property (strong, nonatomic) IBOutlet UIView *commentView;
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;

@property (nonatomic, strong) FMDetail *fmDetail;

@property (nonatomic, copy) void (^saveCompleteHandler)(void);

@end
