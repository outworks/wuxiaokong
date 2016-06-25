//
//  MessageListVC.m
//  HelloToy
//
//  Created by ilikeido on 15/12/11.
//  Copyright (c) 2015年 NetDragon. All rights reserved.
//

#import "MessageListVC.h"
#import "MsgText.h"
#import "ApplyCell.h"
#import "NDUserAPI.h"
#import "UIScrollView+PullTORefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIButton+Block.h"
#import "ApplyInfo.h"
#import "LK_NSDictionary2Object.h"
#import "NDGroupAPI.h"

static NSString *ApplyCellIdentifier = @"ApplyCell";

#define PAGEROW 15

@interface MessageListVC ()<UITableViewDataSource,UITableViewDelegate,ApplyCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property(assign,nonatomic) NSInteger page;

@property(nonatomic,strong) NSMutableArray *datas;
@property(nonatomic,strong) MsgText *waitDelete;

@property(nonatomic,strong) MsgText *waitApply;

@end

@implementation MessageListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    [self readPushLog];
}



-(void)initData{
    _datas = [[NSMutableArray alloc]init];
    
    [self loadPageData];
}

-(void)initView{
    
    [_tableView setTableFooterView:nil];
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullScrollingWithActionHandler:^{
        [weakSelf loadPageData];
    }];
}

-(void)reloadDatas{
    _page = 0;
    [self.datas removeAllObjects];
    [self loadPageData];
    [self readPushLog];
}

-(void)readPushLog{
    NDUserReadPushLogParams *param = [[NDUserReadPushLogParams alloc]init];
    param.msg_from = _msg_from.integerValue;
    [NDUserAPI userReadPushLogWithParams:param completionBlockWithSuccess:^{
        
    } Fail:^(int code, NSString *failDescript) {
        
    }];
}

-(void)loadPageData{
   
    _page ++;
    NDUserPageSubPushLogParams *params = [[NDUserPageSubPushLogParams alloc]init];
    params.msg_from = [_msg_from integerValue];
    params.page = _page;
    params.rows = PAGEROW;
    __weak typeof(self) weakself = self;
    
    [NDUserAPI userPageSubPushLogWithParams:params completionBlockWithSuccess:^(PushLogPageSubData *result) {
        
        for (MsgText *msg in result.msgs) {
            if ([msg.msg_title isEqualToString:@"申请加群"]) {
                [self.datas addObject:msg];
            }
        }
        
        //[self.datas addObjectsFromArray:result.msgs];
        [weakself.tableView.pullScrollingView stopAnimating];
        [weakself.tableView.infiniteScrollingView stopAnimating];
        if (result.msgs.count < PAGEROW) {
           weakself.tableView.showsPullScrolling = NO;
        }else{
            weakself.tableView.showsPullScrolling = YES;
        }
        if (self.datas.count == 0) {
            [_emptyView setHidden:NO];
        }else {
            [_emptyView setHidden:YES];
        }
        [_tableView reloadData];
        if (_page == 1) {
            if (self.datas.count>0) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.datas.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }else{
            if (self.datas.count > 0) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:result.msgs.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
    } Fail:^(int code, NSString *failDescript) {
        _page --;
        [weakself.tableView.pullScrollingView stopAnimating];
        [weakself.tableView.infiniteScrollingView stopAnimating];
    }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

// 注意：除非行高极端变化并且你已经明显的觉察到了滚动时滚动条的“跳跃”现象，你才需要实现此方法；否则，直接用tableView的estimatedRowHeight属性即可。
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 50.0f;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_msg_from.integerValue == 1) {
        return 142.0;
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [[_datas reverseObjectEnumerator]allObjects];
    
    if (_msg_from.integerValue == 1) {
        
        ApplyCell *applyCell = [tableView dequeueReusableCellWithIdentifier:ApplyCellIdentifier];
        if (!applyCell) {
            UINib *cellNib = [UINib nibWithNibName:ApplyCellIdentifier bundle:nil];
            [self.tableView registerNib:cellNib forCellReuseIdentifier:ApplyCellIdentifier];
            applyCell = [tableView dequeueReusableCellWithIdentifier:ApplyCellIdentifier];
        }
        applyCell.delegate = self;
        
        applyCell.msgText = array[indexPath.row];
        applyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return applyCell;
        
    }else{
    
        return nil;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;{

    
}

#pragma mark - Function

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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return  (_msg_from.integerValue == 1 );
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (_msg_from.integerValue == 1) {
            
            NSArray *array = [[_datas reverseObjectEnumerator]allObjects];
            _waitDelete = [array objectAtIndex:indexPath.row];
            UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:PROGRAMNAME message:NSLocalizedString(@"确定删除申请?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"否", nil) otherButtonTitles:NSLocalizedString(@"是", nil), nil];
            t_alertView.tag = 11;
            [t_alertView show];
            
        }else{
            
            NSArray *array = [[_datas reverseObjectEnumerator]allObjects];
            _waitDelete = [array objectAtIndex:indexPath.row];
            
            NDUserDelPUshLogParams *params = [[NDUserDelPUshLogParams alloc] init];
            params.msg_id = _waitDelete.msg_id;
            
            [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
            
            __weak typeof(self) weakSelf = self;
            
            [NDUserAPI delPushLogWithParams:params completionBlockWithSuccess:^{
                
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                
                [_tableView beginUpdates];
                NSArray *array = [[_datas reverseObjectEnumerator]allObjects];
                NSUInteger row = [array indexOfObject:_waitDelete];
                NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
                [_datas removeObject:_waitDelete];
                _waitDelete = nil;
                [_tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
                [_tableView endUpdates];
                
            } Fail:^(int code, NSString *failDescript) {
                
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                
                [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:weakSelf.view];
                
            }];
            
            
        
        }
      
    }
    
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return NSLocalizedString(@"删除", nil);
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 11) {
        
        if (buttonIndex == 1) {
            
            if (_waitDelete) {
                
                if ([_waitDelete.msg_type isEqual:@"apply"] ) {
                    
                    NSDictionary *apply =  _waitDelete.msg_obj;
                    NSDictionary *dict = [apply objectForKey:@"apply"];
                    ApplyInfo *applyInfo = [dict objectByClass:[ApplyInfo class]];
                    NDGroupProcessApplyParams *params = [[NDGroupProcessApplyParams alloc] init];
                    params.apply_id = applyInfo.apply_id;
                    params.msg_id = _waitDelete.msg_id;
                    params.agree = @0;
                    [NDGroupAPI groupProcessApplyWithParams:params completionBlockWithSuccess:^{
                        
                        NSDictionary *remoteInfo = @{@"isAgree":@0};
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFCATION_APPLY_ACTION object:nil userInfo:remoteInfo];
                        [_tableView beginUpdates];
                        NSArray *array = [[_datas reverseObjectEnumerator]allObjects];
                        NSUInteger row = [array indexOfObject:_waitDelete];
                        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
                        [_datas removeObject:_waitDelete];
                        _waitDelete = nil;
                        [_tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
                        [_tableView endUpdates];
                        
                    } Fail:^(int code, NSString *failDescript) {
                        
                        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
                        } duration:1.5f inView:[ApplicationDelegate window]];
                        
                    }];
                    
                }
            
            }
        }
    }
}

#pragma mark - ApplyCellDelegate

-(void)applyCellClickApply:(ApplyCell *)cell{
    NSLog(@"%@",cell.msgText);
    
    if ([cell.msgText.msg_type isEqual:@"apply"] ) {
        
        [self applyAction:cell.msgText];
        
    }
}

#pragma mark -

-(void)applyAction:(MsgText *)msg{
    
    NSDictionary *apply =  msg.msg_obj;
    if (apply != nil) {
        NSDictionary *dict = [apply objectForKey:@"apply"];
        ApplyInfo *applyInfo = [dict objectByClass:[ApplyInfo class]];
        NDGroupProcessApplyParams *params = [[NDGroupProcessApplyParams alloc] init];
        params.apply_id = applyInfo.apply_id;
        params.agree = @1;
        params.msg_id = msg.msg_id;
        [NDGroupAPI groupProcessApplyWithParams:params completionBlockWithSuccess:^{
            NSDictionary *remoteInfo = @{@"isAgree":@1};
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFCATION_APPLY_ACTION object:nil userInfo:remoteInfo];
            [ShowHUD showSuccess:NSLocalizedString(@"添加成功", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:[ApplicationDelegate window]];
            [_tableView beginUpdates];
            NSArray *array = [[_datas reverseObjectEnumerator]allObjects];
            NSUInteger row = [array indexOfObject:msg];
            NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
            [_datas removeObject:msg];
            _waitDelete = nil;
            [_tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView endUpdates];
            
        } Fail:^(int code, NSString *failDescript) {
            
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:[ApplicationDelegate window]];
            if (code == 2109) {
                [_tableView beginUpdates];
                NSArray *array = [[_datas reverseObjectEnumerator]allObjects];
                NSUInteger row = [array indexOfObject:msg];
                NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
                [_datas removeObject:msg];
                _waitDelete = nil;
                [_tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
                [_tableView endUpdates];
            }
        }];
        
        //邀请申请弹出框对聊天界面的影响
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_ALERTVIEWSHOW object:nil];
    }
    
}

#pragma mark - dealloc

-(void)dealloc{
   
    NSLog(@"MessageListVC dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
