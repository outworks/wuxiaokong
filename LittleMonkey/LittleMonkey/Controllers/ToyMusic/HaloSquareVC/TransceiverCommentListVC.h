//
//  TransceiverCommentList.h
//  HelloToy
//
//  Created by yull on 15/12/30.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "FMDetail.h"

@interface TransceiverCommentListVC : HideTabSuperVC

@property (strong, nonatomic) IBOutlet UIImageView *iconIV;
@property (strong, nonatomic) IBOutlet UIButton *playB;
@property (strong, nonatomic) IBOutlet UILabel *recordNameL;
@property (strong, nonatomic) IBOutlet UILabel *recordByL;
@property (strong, nonatomic) IBOutlet UILabel *commentCountL;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn_zhan;


@property (nonatomic, strong) FMDetail *fmDetail;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, copy) void (^favCompleteHandler)(void);
@property (nonatomic, copy) void (^RefreshCommentHandler)(void);

@end
