//
//  TransceiverCommentList.m
//  HelloToy
//
//  Created by yull on 15/12/30.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "TransceiverCommentListVC.h"
#import "TransceiverCommentCell.h"
#import "TransceiverPublishCommentVC.h"

#import "UIImageView+WebCache.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "LK_NSDictionary2Object.h"
#import "AFSoundManager.h"

#import "NDFmAPI.h"
#import "FMComment.h"

@interface TransceiverCommentListVC ()

@property (nonatomic, strong) NSMutableArray *commentList;

@property (nonatomic, assign) unsigned long page;

@property (nonatomic, assign) BOOL isPaused;

@end

@implementation TransceiverCommentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = NSLocalizedString(@"电台", nil);
    
    self.iconIV.layer.cornerRadius = CGRectGetHeight(self.iconIV.frame)/2;
    self.iconIV.layer.masksToBounds = YES;
    
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:self.fmDetail.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
    self.recordNameL.text = self.fmDetail.name;
    
    self.page = 1;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TransceiverCommentCell" bundle:nil] forCellReuseIdentifier:@"TransceiverCommentCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self loadData];
    if (self.fmDetail.is_like.integerValue == 1) {
        self.isPaused = YES;
        [_btn_zhan setSelected:YES];
    }
    __weak typeof(self) wself = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [wself loadData];
    }];
}

- (void)loadData {
    
    NDFmCommentListParams *params = [[NDFmCommentListParams alloc] init];
    params.media_id = self.fmDetail.media_id;
    params.page = @(self.page);
    [NDFmAPI fmCommentListWithParams:params CompletionBlockWithSuccess:^(id data) {
        
        if (self.page == 1) {
            [self.commentList removeAllObjects];
        }
        
        self.page ++;
        
        unsigned long count = [[data objectForKey:@"count"] integerValue];
        self.commentCountL.text = [NSString stringWithFormat:NSLocalizedString(@"评论 %ld", nil), count];
        
        NSArray *array = [data objectForKey:@"replys"];
        self.commentList = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.commentList addObject:[obj objectByClass:[FMComment class]]];
        }];
        
        [self.tableView reloadData];
        
        if (self.commentList.count >= count) {
            self.tableView.showsInfiniteScrolling = NO;
        }
        
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
    }];
}

- (IBAction)button_play:(id)sender {
    
    if (self.isPlaying) {
        if (self.isPaused) {
            [[AFSoundManager sharedManager] resume];
        } else {
            [[AFSoundManager sharedManager] pause];
        }
        self.isPaused = !self.isPaused;
    } else {
        [[AFSoundManager sharedManager] startStreamingRemoteAudioFromURL:self.fmDetail.url andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
            if (!error) {
                self.isPlaying = YES;
                self.isPaused = NO;
            } else {
                [ShowHUD showSuccess:error.description configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:ApplicationDelegate.window];
            }
            
            if (finished) {
                self.isPlaying = NO;
                self.isPaused = NO;
            }
            
        }];
    }
}

- (void)setIsPaused:(BOOL)isPaused {
    
    _isPaused = isPaused;
    if (!isPaused) {
        [self.playB setImage:[UIImage imageNamed:@"btn_musicPause_n"] forState:UIControlStateNormal];
        [self.playB setImage:[UIImage imageNamed:@"btn_musicPause_h"] forState:UIControlStateHighlighted];
    } else {
        [self.playB setImage:[UIImage imageNamed:@"btn_musicPlay_n"] forState:UIControlStateNormal];
        [self.playB setImage:[UIImage imageNamed:@"btn_musicPlay_h"] forState:UIControlStateHighlighted];
    }
}

- (IBAction)button_comment:(id)sender {
    
    TransceiverPublishCommentVC *controller = [[TransceiverPublishCommentVC alloc] init];
    controller.fmDetail = self.fmDetail;
    controller.saveCompleteHandler = ^{
        self.page = 1;
        [self loadData];
        self.fmDetail.reply_cnt = [NSNumber numberWithLong:self.fmDetail.reply_cnt.longValue + 1];
        if (self.RefreshCommentHandler) {
            self.RefreshCommentHandler();
        }
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)button_save:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NDFmFavParams *params = [[NDFmFavParams alloc] init];
    params.media_id = self.fmDetail.media_id;
    [NDFmAPI fmFavWithParams:params CompletionBlockWithSuccess:^(id data) {
        
        NSString *hud = nil;
        if (self.fmDetail.is_like.longLongValue == 1) {
            self.fmDetail.is_like = @(0);
            self.fmDetail.like_cnt = [NSNumber numberWithLong:self.fmDetail.like_cnt.longValue - 1];
            hud = NSLocalizedString(@"取消喜欢成功", nil);
            button.selected = NO;
        } else {
            self.fmDetail.is_like = @(1);
            self.fmDetail.like_cnt = [NSNumber numberWithLong:self.fmDetail.like_cnt.longValue + 1];
            hud = NSLocalizedString(@"喜欢成功", nil);
            button.selected = YES;
        }
        
        [ShowHUD showSuccess:hud configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
        if (self.favCompleteHandler) {
            self.favCompleteHandler();
        }
        
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
    }];
}

- (void)loadCellContent:(TransceiverCommentCell *)cell indexPath:(NSIndexPath*)indexPath
{
    //这里把数据设置给Cell
    FMComment *fmComment = self.commentList[indexPath.row];
    cell.commentDateL.text = fmComment.add_time;
    cell.userNameL.text = fmComment.nickname;
    cell.commentL.text = fmComment.content;
    [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:fmComment.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static TransceiverCommentCell *cell = nil;
    
    if (!cell) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"TransceiverCommentCell"];
    }
    
//    cell.translatesAutoresizingMaskIntoConstraints = NO;
//    cell.commentL.translatesAutoresizingMaskIntoConstraints = NO;
//    cell.iconIV.translatesAutoresizingMaskIntoConstraints = NO;
    [self loadCellContent:cell indexPath:indexPath];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TransceiverCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransceiverCommentCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self loadCellContent:cell indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
