//
//  ChildSearchMoreVC.m
//  HelloToy
//
//  Created by huanglurong on 16/4/28.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildSearchMoreVC.h"

#import "XMSDK.h"
#import "ChildAlbumListCell.h"
#import "ChildAlbumDetailVC.h"
#import "ChildCommonCell.h"
#import "UIScrollView+SVInfiniteScrolling.h"

#import "PureLayout.h"

#import "NDAlbumAPI.h"
#import "NDToyAPI.h"
#import "ND3rdMediaAPI.h"
#import "NDMediaAPI.h"
#import "UIActionSheet+BlocksKit.h"

@interface ChildSearchMoreVC (){
    ShowHUD *_hud;
}


@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (nonatomic,strong) NSMutableArray *mArr_data;
@property (assign,nonatomic) NSInteger      page;
@property (assign,nonatomic) BOOL           isLastPage;
@property (nonatomic,strong) NSNumber *playMediaId;


@end

@implementation ChildSearchMoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPlayDown:) name:@"播放完刷新" object:nil];
    
    _mArr_data = [NSMutableArray array];
    _isLastPage = NO;
    _page = 1;
    
    __weak typeof(self) weakSelf = self;
    
    
    if (self.isAlbum) {
        self.navigationItem.title = @"更多专辑";
        [self searchAlbum:self.str_search];
        
    }else if(!self.isNdMedia){
        
        self.navigationItem.title = @"更多音乐";
        [self searchMedia:self.str_search];
        
    }else{
        self.navigationItem.title = @"推荐音乐";
        [self searchNDMeida:self.str_search];
    }
    

    [_tb_content addInfiniteScrollingWithActionHandler:^{
        
        if (weakSelf.isAlbum) {
            
            [weakSelf searchAlbum:weakSelf.str_search];
            
        }else if(!weakSelf.isNdMedia){
            
            [weakSelf searchMedia:weakSelf.str_search];
            
        }else{
            [weakSelf searchNDMeida:weakSelf.str_search];
        }
    
    }];
    
}

#pragma mark - private 

- (void)searchAlbum:(NSString *)albumName{
    
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
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@6 forKey:@"category_id"];
    [params setObject:@20 forKey:@"count"];
    [params setObject:[NSNumber numberWithInteger:_page] forKey:@"page"];
    [params setObject:albumName forKey:@"q"];
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_SearchAlbums params:params withCompletionHander:^(id result, XMErrorModel *error) {
        
        if (!error) {
            
            NSArray *data = [self showReceivedData:result className:@"XMAlbum" valuePath:@"albums"];
            
            if (_hud) [_hud hide];
            [weakSelf.tb_content.infiniteScrollingView stopAnimating];
            
            if ([data count] < 20) {
                
                weakSelf.isLastPage = YES;
                
            }
            [weakSelf.mArr_data addObjectsFromArray:data];
            
            weakSelf.tb_content.showsInfiniteScrolling = !weakSelf.isLastPage;
            [weakSelf.tb_content reloadData];
            
            weakSelf.page ++;
            
            
        }else{
            
            NSLog(@"%@   %@",error.description,result);
            if (_hud) [_hud hide];
            
            [weakSelf.tb_content.infiniteScrollingView stopAnimating];
            [weakSelf.tb_content reloadData];
            
            [ShowHUD showError:error.description configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:ApplicationDelegate.window];
            
        }
        
    }];
    
    
}

- (void)searchMedia:(NSString *)mediaName{
    
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
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@6 forKey:@"category_id"];
    [params setObject:@20 forKey:@"count"];
    [params setObject:[NSNumber numberWithInteger:_page] forKey:@"page"];
    [params setObject:mediaName forKey:@"q"];
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_SearchTracks params:params withCompletionHander:^(id result, XMErrorModel *error) {
        
        if (!error) {
            
            if (_hud) [_hud hide];
            [weakSelf.tb_content.infiniteScrollingView stopAnimating];
            
            NSArray *data = [self showReceivedData:result className:@"XMTrack" valuePath:@"tracks"];
            
            for (int i = 0; i < [data count]; i++) {
                XMTrack *track = data[i];
                NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
                [t_dic setObject:track forKey:@"Track"];
                [weakSelf.mArr_data addObject:t_dic];
            }
        
            if ([data count] < 20) {
                
                weakSelf.isLastPage = YES;
                
            }
            if (![ShareValue sharedShareValue].toyDetail) {
                [weakSelf loadAlbumStatus:data];
            }
            [_tb_content.infiniteScrollingView stopAnimating];
            weakSelf.tb_content.showsInfiniteScrolling = !weakSelf.isLastPage;
            [weakSelf.tb_content reloadData];
            weakSelf.page ++;
            
        }else{
            
            NSLog(@"%@   %@",error.description,result);
            if (_hud) [_hud hide];
            
            [weakSelf.tb_content.infiniteScrollingView stopAnimating];
            [weakSelf.tb_content reloadData];
            
            [ShowHUD showError:error.description configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:ApplicationDelegate.window];
        }
        
    }];
    
}


-(void)searchNDMeida:(NSString *)name{
    __weak typeof(self) weakself = self;
    if (_page == 1) {
        _tb_content.showsInfiniteScrolling = NO;
    }else{
        _tb_content.showsInfiniteScrolling = !_isLastPage;
    }
    
    if (_page == 1) {
        _hud = [ShowHUD showText:NSLocalizedString(@"Requesting", nil) configParameter:^(ShowHUD *config) {
        } inView:self.view];
    }

    NDMediaQueryParams *params = [[NDMediaQueryParams alloc]init];
    params.name = name;
    params.page = @(_page);
    [NDMediaAPI mediaQueryWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        if ([data count] <20 ) {
            weakself.isLastPage = YES;
        }
        for (AlbumMedia *albumMedia in data) {
            NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
            [t_dic setObject:albumMedia forKey:@"media"];
            [_mArr_data addObject:t_dic];
        }
        if (![ShareValue sharedShareValue].toyDetail) {
            if (_hud) [_hud hide];
            [_tb_content reloadData];
        }else{
            [weakself loadNdMediaDownloadStatus:data];
        }
        _tb_content.showsInfiniteScrolling = !_isLastPage;
        [_tb_content.infiniteScrollingView stopAnimating];
        weakself.page ++;
    } Fail:^(int code, NSString *failDescript) {
        [_tb_content.infiniteScrollingView stopAnimating];
        if (_hud) [_hud hide];
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        [_tb_content reloadData];
    }];
}

-(void)loadNdMediaDownloadStatus:(NSArray *)data{
    if (data.count > 0) {
        __weak typeof(self ) weakSelf = self;
        NDQueryMediaStatusParams *params = [[NDQueryMediaStatusParams alloc]init];
        params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
        NSMutableArray *ids = [NSMutableArray array];
        for (AlbumMedia *albumMedia in data) {
            [ids addObject:albumMedia.media_id];
        }
        params.medialist = [ids componentsJoinedByString:@","];
        [NDAlbumAPI mediaStatusQueryWithParams:params completionBlockWithSuccess:^(NSArray *data) {
            for(MediaDownloadStatus *status in data){
                for (NSDictionary *dict in _mArr_data) {
                    AlbumMedia *albumMedia = [dict objectForKey:@"media"];
                    if ([albumMedia.media_id isEqualToNumber:status.media_id]) {
                        [dict setValue:status forKey:@"status"];
                        break;
                    }
                }
            }
            [weakSelf.tb_content reloadData];
           if (_hud) [_hud hide];
        } Fail:^(int code, NSString *failDescript) {
            if (_hud) [_hud hide];
        }];
    }
    
    
}


- (void)loadAlbumStatus:(NSArray *)data{
    
    __weak typeof(self) weakSelf = self;
    
    if (![ShareValue sharedShareValue].toyDetail.toy_id) {
        return;
    }
    
    NSMutableArray *ids = [NSMutableArray array];
    for (XMTrack *track in data) {
        [ids addObject:@(track.trackId)];
    }
    
    ND3rdMediaQeueryMediaParams *params = [[ND3rdMediaQeueryMediaParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.source = @100;
    params.third_mid_list = [ids componentsJoinedByString:@","];
    
    [ND3rdMediaAPI thirdMediaQeueryMediaWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        
        if (data && [data count] > 0 ) {
            for (MediaDownloadStatus *status in data) {
                for (NSMutableDictionary *t_dic in weakSelf.mArr_data) {
                    
                    XMTrack *track = [t_dic objectForKey:@"Track"];
                    
                    if ([@(track.trackId) isEqualToNumber:status.third_mid]) {
                        
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
        [weakSelf.tb_content reloadData];
        
    }];
    
}


- (NSMutableArray *)showReceivedData:(id)result className:(NSString*)className valuePath:(NSString *)path
{
    NSMutableArray *models = [NSMutableArray array];
    Class dataClass = NSClassFromString(className);
    if([result isKindOfClass:[NSArray class]]){
        for (NSDictionary *dic in result) {
            id model = [[dataClass alloc] initWithDictionary:dic];
            [models addObject:model];
        }
    }
    else if([result isKindOfClass:[NSDictionary class]]){
        if(path.length == 0)
        {
            id model = [[dataClass alloc] initWithDictionary:result];
            [models addObject:model];
        }
        else
        {
            for (NSDictionary *dic in result[path]) {
                id model = [[dataClass alloc] initWithDictionary:dic];
                [models addObject:model];
            }
        }
    }
    
    return models;
}



#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_mArr_data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isAlbum) {
        return 81.0;
    }else{
        return 65.0f;
    
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    if (_isAlbum) {
        
        ChildAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildAlbumListCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"ChildAlbumListCell" bundle:nil] forCellReuseIdentifier:@"ChildAlbumListCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChildAlbumListCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        XMAlbum * album = _mArr_data[indexPath.row];
        cell.album = album;
        
        return cell;
        
    }else if(!_isNdMedia){
    
        ChildCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCommonCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"ChildCommonCell" bundle:nil] forCellReuseIdentifier:@"ChildCommonCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCommonCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableDictionary *t_dic = _mArr_data[indexPath.row];
        XMTrack *track = [t_dic objectForKey:@"Track"];
        MediaDownloadStatus *downloadStatus = [t_dic objectForKey:@"MediaDownloadStatus"];
        
        if (![ShareValue sharedShareValue].toyDetail.toy_id) {
            cell.btn_status.hidden = YES;
        }
        
        if (track) {
            cell.album_xima = track;
        }
        
        if (downloadStatus) {
            
            cell.downloadStatus = downloadStatus;
        }
        
        cell.block_down = ^(ChildCommonCell *cell){
            
            [weakSelf handleDownBtnActionInCell:cell];
            
        };
        
        [cell setPlayMediaId:_playMediaId];
        
        return cell;
    
    }else{
        ChildCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCommonCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"ChildCommonCell" bundle:nil] forCellReuseIdentifier:@"ChildCommonCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCommonCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *t_dic = [_mArr_data objectAtIndex:indexPath.row];
        AlbumMedia *media = [t_dic objectForKey:@"media"];
        MediaDownloadStatus *stauts = [t_dic objectForKey:@"status"];
        
        if (![ShareValue sharedShareValue].toyDetail.toy_id) {
            cell.btn_status.hidden = YES;
        }
        if (media) {
            cell.albumMedia = media;
        }
        if (stauts) {
            cell.downloadStatus = stauts;
        }
        cell.block_down = ^(ChildCommonCell *cell){
            [weakSelf handleDownBtnActionInCell:cell];
        };
        [cell setPlayMediaId:_playMediaId];
        return cell;
    }
   
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChildCommonCell *cell = (ChildCommonCell *)[self.tb_content cellForRowAtIndexPath:indexPath];
    if (_isAlbum) {
        XMAlbum * album = _mArr_data[indexPath.row];
        ChildAlbumDetailVC *t_vc = [[ChildAlbumDetailVC alloc] init];
        t_vc.album_xima = album;
        [self.navigationController pushViewController:t_vc animated:YES];
        return;
    }else if(!_isNdMedia){
        NSMutableDictionary * t_dic = _mArr_data[indexPath.row];
        XMTrack *track = [t_dic objectForKey:@"Track"];
        if ([cell.playMediaId isEqual:@(track.trackId)] && cell.isPlay) {
            [cell btnTryListen:_playMediaId WithUrl:track.playUrl32];
            _playMediaId = nil;
            return;
        }
        if (![ShareValue sharedShareValue].toyDetail) {
            [cell btnTryListen:_playMediaId WithUrl:track.playUrl32];
            _playMediaId = @(track.trackId);
            return;
        }
    }else{
        NSMutableDictionary * t_dic = _mArr_data[indexPath.row];
        AlbumMedia *media = [t_dic objectForKey:@"media"];
        
        if ([cell.playMediaId isEqual:media.media_id] && cell.isPlay) {
            [cell btnTryListen:_playMediaId WithUrl:media.url];
            _playMediaId = nil;
            return;
        }
        if (![ShareValue sharedShareValue].toyDetail) {
            [cell btnTryListen:_playMediaId WithUrl:media.url];
            _playMediaId = media.media_id;
            return;
        }

    }
    
    if (cell.downloadStatus.download.integerValue == 1 || cell.downloadMediaInfo.download.integerValue == 1) {
        __weak typeof(self)weakself = self;
        UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:@"请选择"];
        [sheet bk_addButtonWithTitle:@"手机播放" handler:^{
            [weakself playMedia:cell atIndex:indexPath];
        }];
        [sheet bk_addButtonWithTitle:@"玩具播放" handler:^{
            NDToyPlayMediaParams *params = [[NDToyPlayMediaParams alloc]init];
            params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
            if (cell.downloadMediaInfo) {
                params.media_id = cell.downloadMediaInfo.media_id;
            }else if(cell.downloadStatus){
                params.media_id = cell.downloadStatus.media_id;
            }
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
            [weakself playMedia:cell atIndex:indexPath];
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

- (void)handleDownBtnActionInCell:(ChildCommonCell *)cell{
    if (_isNdMedia) {
        NDMediaDownloadParams *params = [[NDMediaDownloadParams alloc] init];
        params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
        params.media_id = cell.albumMedia.media_id;
        
        [NDAlbumAPI mediaDownloadWithParams:params completionBlockWithSuccess:^{
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

    }else{
        ND3rdMediaDownloadMediaParams *params = [[ND3rdMediaDownloadMediaParams alloc] init];
        params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
        params.third_aid = @(cell.album_xima.subordinatedAlbum.albumId);
        params.source = @100;
        params.album_icon = cell.album_xima.subordinatedAlbum.coverUrlSmall;
        params.album_title = cell.album_xima.subordinatedAlbum.albumTitle;
        params.third_mid = @(cell.album_xima.trackId);
        params.media_title = cell.album_xima.trackTitle;
        params.media_url = cell.album_xima.playUrl32;
        params.media_icon = cell.album_xima.coverUrlSmall;
        
        [ND3rdMediaAPI thirdMediaDownloadMediaWithParams:params completionBlockWithSuccess:^(MediaDownloadStatus *mediaDownloadStatus) {
            
            cell.downloadStatus.media_id = mediaDownloadStatus.media_id;
            cell.downloadStatus.third_mid = mediaDownloadStatus.third_mid;
            cell.downloadStatus.download = mediaDownloadStatus.download;
            [_tb_content reloadData];
            if ([ShareValue sharedShareValue].cur_toyState == ToyStateMusicState || [ShareValue sharedShareValue].cur_toyState == ToyStateStoryState) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:NSLocalizedString(@"AddDownloadQueue2", nil) delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"忽略", nil];
                alert.tag = 11;
                [alert show];
            }else{
                [ShowHUD showSuccess:NSLocalizedString(@"AddDownloadQueue", nil) configParameter:^(ShowHUD *config) {
                } duration:2.0f inView:ApplicationDelegate.window];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"媒体下载到玩具的通知" object:nil];
            
        } Fail:^(int code, NSString *failDescript) {
            
            [ShowHUD showError:@"下载失败" configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:ApplicationDelegate.window];
            
        }];
    }
    

}


- (void)reloadPlayDown:(NSNotification *)note{
    
    _playMediaId = nil;
    [self.tb_content reloadData];
    
    
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

    NSLog(@"ChildSearchMoreVC dealloc");
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
