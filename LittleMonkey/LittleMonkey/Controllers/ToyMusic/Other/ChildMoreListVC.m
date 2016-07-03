//
//  ChildMoreListVC.m
//  HelloToy
//
//  Created by huanglurong on 16/4/25.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildMoreListVC.h"
#import "ChildMusicVC.h"
#import "ChildCommonCell.h"
#import "NDToyAPI.h"

#import "PureLayout.h"
#import "UIScrollView+PullTORefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIAlertView+BlocksKit.h"
#import "UIActionSheet+BlocksKit.h"

#import "NDMediaAPI.h"
#import "NDAlbumAPI.h"
#import "ChooseView.h"

@interface ChildMoreListVC (){
    ShowHUD *_hud;
}

@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (nonatomic,strong) NSMutableArray *mArr_current;            //儿歌数组
@property (assign,nonatomic) NSInteger      page;
@property (assign,nonatomic) BOOL           isLastPage;

@property (nonatomic,strong) NSNumber *playMediaId;

@end

@implementation ChildMoreListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NotificationCenter addObserver:self selector:@selector(collectionNotication:) name:NOTIFCATION_COLLECTION object:nil];
    [NotificationCenter addObserver:self selector:@selector(updataCollectionNotication:) name:NOTIFCATION_UPDATACOLLECTION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPlayDown:) name:@"播放完刷新" object:nil];
    self.mArr_current = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    
    [_tb_content addPullScrollingWithActionHandler:^{
        [weakSelf reloadDatas];
    }];
    
    if (_moreType == 2){
        
        [_tb_content addInfiniteScrollingWithActionHandler:^{
            [weakSelf loadData];
        }];
        
    }
    
    
    [_tb_content triggerPullScrolling];
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - privateMethods

- (void)reloadDatas{
    
    _page = 1;
    _isLastPage = NO;
    if (_moreType != 1) {
        [_mArr_current removeAllObjects];
    }
    
    [_tb_content reloadData];
    [self loadData];
    
}

- (void)loadData{

    if (_moreType == 1) {
        self.title = @"喜欢";
        [self requestDataForCollected];
       
    }else if (_moreType == 2){
        
        self.title = @"下载";
        [self requestDataForDownload];
    
    }else if (_moreType == 3){
        
        self.title = @"最近播放";
        [self requestDataForRecentlyPlay];
        
    }
    

}

- (void)requestDataForCollected{
    
    if (![ShareValue sharedShareValue].mArr_collections) {
        
        [ChildMusicVC loadCollections];
        
    }else{
        
        [self.tb_content.pullScrollingView stopAnimating];
        
        _mArr_current = [ShareValue sharedShareValue].mArr_collections;

        [_tb_content reloadData];
        
        
    }
    
}


- (void)requestDataForDownload{
    
    __weak typeof(self) weakSelf = self;
    
    if (_page == 1) {
        _tb_content.showsInfiniteScrolling = NO;
    }else{
        _tb_content.showsInfiniteScrolling = !_isLastPage;
    }
    
    if (_page == 1) {
        _hud = [ShowHUD showText:NSLocalizedString(@"Requesting", nil) configParameter:^(ShowHUD *config) {
        } inView:self.view];
    }
}

- (void)requestDataForRecentlyPlay{
    
    __weak __typeof(*&self) weakSelf = self;
    
    NDToyPlayRecentlyParams *params = [[NDToyPlayRecentlyParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    [NDToyAPI toyPlayRecentlyWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        
        [self.tb_content.pullScrollingView stopAnimating];
        
        if (weakSelf.mArr_current && [weakSelf.mArr_current count] > 0) {
            [weakSelf.mArr_current removeAllObjects];
        }
        
        
//        
//        [weakSelf.mArr_current addObjectsFromArray:data];
//        [weakSelf.tb_content reloadData];
        
        
        for (int i = 0; i < [data count]; i++) {
            ToyPlay *albumMedia = data[i];
            NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
            [t_dic setObject:albumMedia forKey:@"AlbumMedia"];
            [weakSelf.mArr_current addObject:t_dic];
        }
        
        [weakSelf queryMediaStatus:data];
        
        [weakSelf.tb_content reloadData];
        
        
    } Fail:^(int code, NSString *failDescript) {
        
        [self.tb_content.pullScrollingView stopAnimating];
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
        
    }];

}

- (void)queryMediaStatus:(NSArray *)data{
    
    __weak __typeof(self) weakSelf = self;
    
    if (![ShareValue sharedShareValue].toyDetail.toy_id) {
        return;
    }
    
    NDQueryMediaStatusParams *params = [[NDQueryMediaStatusParams alloc]init];
    
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.medialist = [self gainMediaList:(NSMutableArray *)data];

    [NDAlbumAPI mediaStatusQueryWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        
        if (data && [data count] > 0 ) {
            for (MediaDownloadStatus *status in data) {
                
                for (NSMutableDictionary *t_dic in weakSelf.mArr_current) {
                    
                    ToyPlay *albumMedia = [t_dic objectForKey:@"AlbumMedia"];
                    
                    if ([albumMedia.media_id isEqualToNumber:status.media_id]) {
                        
                        [t_dic setObject:status forKey:@"MediaDownloadStatus"];
                        break;
                    }
                }
            }
            
            [weakSelf.tb_content reloadData];
        }
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:@"请求下载状态失败" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
    }];
    
}

- (NSString *)gainMediaList:(NSMutableArray *)mediaMuArray
{
    NSMutableString *mediaListString = [@"" mutableCopy];
    if (mediaMuArray.count > 0) {
        for (int i = 0; i < mediaMuArray.count; i++) {
            
            ToyPlay *albumMedia = (ToyPlay *)mediaMuArray[i];
            
            if (i == 0) {
                
                [mediaListString appendFormat:@"%d",[albumMedia.media_id intValue]];
                
            } else {
                
                [mediaListString appendFormat:@",%d",[albumMedia.media_id intValue]];
            }
        }
        
    }
    return mediaListString;
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_mArr_current count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    ChildCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCommonCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ChildCommonCell" bundle:nil] forCellReuseIdentifier:@"ChildCommonCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCommonCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_moreType == 1) {
        
        [cell setAlbumMedia:_mArr_current[indexPath.row]];
    
    }else if (_moreType == 2){
    
        [cell setDownloadMediaInfo:_mArr_current[indexPath.row]];
        
    }else if (_moreType == 3){
    
        
        NSMutableDictionary *t_dic = _mArr_current[indexPath.row];
        ToyPlay *albumMedia = [t_dic objectForKey:@"AlbumMedia"];
        MediaDownloadStatus *downloadStatus = [t_dic objectForKey:@"MediaDownloadStatus"];
        [cell setToyPlay:albumMedia];
        if (downloadStatus) {
            
            cell.downloadStatus = downloadStatus;
        }
        
        cell.block_down = ^(ChildCommonCell *cell){
            
            [weakSelf handleDownBtnActionInCell:cell];
            
            //            [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"玩具正在下载的资源过多，全部完成需要一定的时间，是否确定继续添加资源？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            //                if (buttonIndex == 1) {
            //
            //                }
            //            }];
        };

    }
    
    [cell setPlayMediaId:_playMediaId];
    
    return cell;
}

- (void)handleDownBtnActionInCell:(ChildCommonCell *)cell{
    
    __weak typeof(self) weakself = self;
    NDMediaDownloadParams *params = [[NDMediaDownloadParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.media_id = cell.toyPlay.media_id;
    
    [NDAlbumAPI mediaDownloadWithParams:params completionBlockWithSuccess:^{
        [weakself showRightBarButtonItemToSelected];
        cell.downloadStatus.download = @2;
        [_tb_content reloadData];
        if (([ShareValue sharedShareValue].cur_toyState == ToyStateUnKnowState) || ([ShareValue sharedShareValue].cur_toyState == ToyStateUnOnlineState) || ([ShareValue sharedShareValue].cur_toyState == ToyStateDormancyState)) {
            [ShowHUD showSuccess:NSLocalizedString(@"AddDownloadQueue1", nil) configParameter:^(ShowHUD *config) {
            } duration:3.0f inView:ApplicationDelegate.window];
        }else{
            if ([ShareValue sharedShareValue].cur_toyState == ToyStateMusicState || [ShareValue sharedShareValue].cur_toyState == ToyStateStoryState) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:NSLocalizedString(@"AddDownloadQueue2", nil) delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"忽略", nil];
                alert.tag = 11;
                [alert show];
            }else{
                [ShowHUD showSuccess:NSLocalizedString(@"AddDownloadQueue", nil) configParameter:^(ShowHUD *config) {
                } duration:2.0f inView:ApplicationDelegate.window];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"媒体下载到玩具的通知" object:nil];
        
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showSuccess:failDescript configParameter:^(ShowHUD *config) {
        } duration:2.0f inView:ApplicationDelegate.window];
    }];

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChildCommonCell *cell = (ChildCommonCell *)[self.tb_content cellForRowAtIndexPath:indexPath];

    if (_moreType == 1) {
        
        AlbumMedia *albumMedia = _mArr_current[indexPath.row];
        
        if (!_playMediaId) {
            
            
            [cell btnTryListen:_playMediaId WithUrl:albumMedia.url];
            _playMediaId = albumMedia.media_id;
            
        }else{
            
            [cell btnTryListen:_playMediaId WithUrl:albumMedia.url];
            
            if ([_playMediaId isEqualToNumber:albumMedia.media_id]) {
                
                _playMediaId = nil;
                
            }else{
                
                _playMediaId = albumMedia.media_id;
                
            }
            
        }
        
    }else if(_moreType == 2){
        
        DownloadMediaInfo *downloadMediaInfo = _mArr_current[indexPath.row];
        
        if (!_playMediaId) {
            
            [cell btnTryListen:_playMediaId WithUrl:downloadMediaInfo.url];
            _playMediaId = downloadMediaInfo.media_id;
            
        }else{
            
            [cell btnTryListen:_playMediaId WithUrl:downloadMediaInfo.url];
            
            if ([_playMediaId isEqualToNumber:downloadMediaInfo.media_id]) {
                
                _playMediaId = nil;
                
            }else{
                
                _playMediaId = downloadMediaInfo.media_id;
                
            }
        }
    }else if(_moreType == 3){
        NSMutableDictionary *t_dic = _mArr_current[indexPath.row];
        ToyPlay *toyPlay = [t_dic objectForKey:@"AlbumMedia"];
        MediaDownloadStatus *downloadStatus = [t_dic objectForKey:@"MediaDownloadStatus"];
        if ([cell.playMediaId isEqual:toyPlay.media_id] && cell.isPlay) {
            [cell btnTryListen:_playMediaId WithUrl:toyPlay.url];
            _playMediaId = nil;
            return;
        }
        if (![ShareValue sharedShareValue].toyDetail) {
            [cell btnTryListen:_playMediaId WithUrl:toyPlay.url];
            _playMediaId = toyPlay.media_id;
            return;
        }
        

        if (cell.downloadStatus.download.integerValue == 1 || cell.downloadMediaInfo.download.integerValue == 1) {
            UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:@"请选择"];
            [sheet bk_addButtonWithTitle:@"手机播放" handler:^{
                
                if (!_playMediaId) {
                    
                    [cell btnTryListen:_playMediaId WithUrl:toyPlay.url];
                    _playMediaId = toyPlay.media_id;
                    
                }else{
                    
                    [cell btnTryListen:_playMediaId WithUrl:toyPlay.url];
                    
                    if ([_playMediaId isEqualToNumber:toyPlay.media_id]) {
                        
                        _playMediaId = nil;
                        
                    }else{
                        
                        _playMediaId = toyPlay.media_id;
                        
                    }
                    
                }
                
                
            }];
            
            [sheet bk_addButtonWithTitle:@"玩具播放" handler:^{
                NDToyPlayMediaParams *params = [[NDToyPlayMediaParams alloc]init];
                params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
                params.media_id = toyPlay.media_id;
                
                [NDToyAPI toyPlayMediaWithParams:params completionBlockWithSuccess:^{
                    [ShowHUD showSuccess:NSLocalizedString(@"玩具点播成功", nil) configParameter:^(ShowHUD *config) {
                    } duration:2.0f inView:ApplicationDelegate.window];
                } Fail:^(int code, NSString *failDescript) {
                    [ShowHUD showSuccess:failDescript configParameter:^(ShowHUD *config) {
                    } duration:2.0f inView:ApplicationDelegate.window];
                }];
            }];
            [sheet bk_setCancelButtonWithTitle:@"取消" handler:^{
                
            }];
            [sheet showInView:self.view];
            return;
        }else if (cell.downloadStatus.download.integerValue == 2 ||cell.downloadMediaInfo.download.integerValue == 2){
            [self playMedia:cell atIndex:indexPath];
        }else if (cell.downloadStatus.download.integerValue == 0 ||cell.downloadMediaInfo.download.integerValue == 0){
            __weak typeof(self)weakself = self;
            UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:@"请选择"];
            [sheet bk_addButtonWithTitle:@"手机播放" handler:^{
                
                if (!_playMediaId) {
                    
                    [cell btnTryListen:_playMediaId WithUrl:toyPlay.url];
                    _playMediaId = toyPlay.media_id;
                    
                }else{
                    
                    [cell btnTryListen:_playMediaId WithUrl:toyPlay.url];
                    
                    if ([_playMediaId isEqualToNumber:toyPlay.media_id]) {
                        
                        _playMediaId = nil;
                        
                    }else{
                        
                        _playMediaId = toyPlay.media_id;
                        
                    }
                    
                }
                
                
            }];

            [sheet bk_addButtonWithTitle:@"下载到玩具" handler:^{
                
                if([ShareValue sharedShareValue].toyDetail == nil){
                    
                    [ShowHUD showError:@"当前无玩具" configParameter:^(ShowHUD *config) {
                    } duration:1.5f inView:self.view];
                    
                }else{
                    
                    [weakself handleDownBtnActionInCell:cell];
                    
                }
                
                //            [weakself handleDownBtnActionInCell:cell];
            }];
            [sheet bk_setCancelButtonWithTitle:@"取消" handler:^{
                
            }];
            [sheet showInView:self.view];
            return;
            
        }
    }
    

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChildCommonCell *cell = (ChildCommonCell *)[self.tb_content cellForRowAtIndexPath:indexPath];
    
    if (cell.downloadStatus) {
        
        if ([cell.downloadStatus.download isEqualToNumber:@1]) {
            
            return YES;
            
            
        }else{
            
            return NO;
            
        }
    }else if (cell.downloadMediaInfo){
        
        if ([cell.downloadMediaInfo.download isEqualToNumber:@1]) {
            
            return YES;
            
            
        }else{
            
            return NO;
            
        }
        
    }
    
    
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //[tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"Delete", nil);
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setEditing:NO animated:YES];
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        __weak typeof(self) weakSelf = self;
        
        ChildCommonCell *cell = (ChildCommonCell *)[self.tb_content cellForRowAtIndexPath:indexPath];
        
        
        [ChooseView showChooseViewInMiddleWithTitle:PROGRAMNAME andPrimitiveText:nil andChooseList:@[[NSString stringWithFormat:NSLocalizedString(@"从玩具中删除", nil)]] andCancelButtonTitle:NSLocalizedString(@"Cancle", nil) andConfirmButtonTitle:NSLocalizedString(@"Sure", nil) andChooseCompleteBlock:^(NSInteger row) {
            if (cell.downloadStatus) {
                [weakSelf toyMediaDeleteRequest:cell.downloadStatus.media_id];
            }else if (cell.downloadMediaInfo){
                [weakSelf toyMediaDeleteRequest:cell.downloadMediaInfo.media_id];
            }
            
            
            
        } andChooseCancleBlock:^(NSInteger row) {
        }];
    }
}


-(void)toyMediaDeleteRequest:(NSNumber *)media_id;{
    
    NDToyMediaDeleteParams *params = [[NDToyMediaDeleteParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.media_ids = @[media_id];
    [NDToyAPI toyMediaDeleteWithParams:params completionBlockWithSuccess:^{
        
        [ShowHUD showSuccess:@"从玩具中删除成功" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        [_tb_content triggerPullScrolling];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"删除玩具媒体之后的通知" object:nil];
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        
    }];
    
    
}


-(void)playMedia:(ChildCommonCell *)cell atIndex:(NSIndexPath *)indexPath {
    if(cell.album_xima){
        XMTrack *track = cell.album_xima;
        if (!_playMediaId) {
            
            [cell btnTryListen:_playMediaId WithUrl:track.playUrl32];
            _playMediaId = @(track.trackId);
            
        }else{
            
            [cell btnTryListen:_playMediaId WithUrl:track.playUrl32];
            
            if ([_playMediaId isEqualToNumber:@(track.trackId)]) {
                
                _playMediaId = nil;
                
            }else{
                
                _playMediaId = @(track.trackId);
                
            }
            
        }
        
    }else if(cell.downloadMediaInfo){
        if (!_playMediaId) {
            
            [cell btnTryListen:_playMediaId WithUrl:cell.downloadMediaInfo.url];
            _playMediaId = cell.downloadMediaInfo.media_id;
            
        }else{
            
            [cell btnTryListen:_playMediaId WithUrl:cell.downloadMediaInfo.url];
            
            if ([_playMediaId isEqualToNumber:cell.downloadMediaInfo.media_id]) {
                
                _playMediaId = nil;
                
            }else{
                
                _playMediaId = cell.downloadMediaInfo.media_id;
                
            }
        }
    }else if(cell.toyPlay){
        if (!_playMediaId) {
            
            [cell btnTryListen:_playMediaId WithUrl:cell.toyPlay.url];
            _playMediaId = cell.toyPlay.media_id;
            
        }else{
            
            [cell btnTryListen:_playMediaId WithUrl:cell.toyPlay.url];
            
            if ([_playMediaId isEqualToNumber:cell.toyPlay.media_id]) {
                
                _playMediaId = nil;
                
            }else{
                
                _playMediaId = cell.toyPlay.media_id;
                
            }
        }
    }else if (cell.albumMedia) {
        AlbumMedia *albumMedia = cell.albumMedia;
        
        if (!_playMediaId) {
            
            [cell btnTryListen:_playMediaId WithUrl:albumMedia.url];
            
            _playMediaId = albumMedia.media_id;
        }else{
            
            [cell btnTryListen:_playMediaId WithUrl:albumMedia.url];
            
            if ([_playMediaId isEqualToNumber:albumMedia.media_id]) {
                
                _playMediaId = nil;
                
            }else{
                
                _playMediaId = albumMedia.media_id;
                
            }
            
        }
        
    }
    
}

#pragma mark -
#pragma mark ChildCommonCellDelegate

#pragma mark -
#pragma mark notication

/*----------------- 获取收藏数据通知 ----------------*/

- (void)collectionNotication:(NSNotification *)note{
    
    if (_moreType == 1) {
        [self.tb_content.pullScrollingView stopAnimating];
        
        _mArr_current = [ShareValue sharedShareValue].mArr_collections;
        
        [_tb_content reloadData];

    }
    
}

- (void)reloadPlayDown:(NSNotification *)note{
    
    _playMediaId = nil;
    [self.tb_content reloadData];
    
    
}

- (void)removeMedia:(NSNotification *)note{
    
    _playMediaId = nil;
    [self.tb_content triggerPullScrolling];
    
}


- (void)updataCollectionNotication:(NSNotification *)note{
    
    if (_moreType == 1) {
        
        _mArr_current = [ShareValue sharedShareValue].mArr_collections;
        
        [_tb_content reloadData];
        
    }
    
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 11 && buttonIndex == 0) {
        NDToyChangeModeParams *params = [[NDToyChangeModeParams alloc]init];
        params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
        params.mode = @(TOYMODE_TALK);
        [NDToyAPI toyChangeModeWithParams:params completionBlockWithSuccess:^(NDToyChangeModeResult *result) {
            if (result.isonline) {
                if ([result.isonline boolValue]) {
                    [ShowHUD showSuccess:NSLocalizedString(@"ChangeSuccessful", nil) configParameter:^(ShowHUD *config) {
                    } duration:1.5f inView:self.view];
                }else{
                    [ShowHUD showSuccess:NSLocalizedString(@"EquipmentNotOnlineFiveMinuteEffect", nil)
                         configParameter:^(ShowHUD *config) {
                         } duration:1.5f inView:self.view];
                }
                return ;
            }
            [ShowHUD showSuccess:NSLocalizedString(@"ChangeSuccessful", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
        } Fail:^(int code, NSString *failDescript) {
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
        }];
    }
}

#pragma mark - dealloc 

- (void)dealloc{

    NSLog(@"ChildMoreListVC dealloc");

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
