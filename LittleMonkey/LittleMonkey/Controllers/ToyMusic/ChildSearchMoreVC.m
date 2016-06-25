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
        
    }else{
        
        self.navigationItem.title = @"更多音乐";
        [self searchMedia:self.str_search];
        
    }
    

    [_tb_content addInfiniteScrollingWithActionHandler:^{
        
        if (weakSelf.isAlbum) {
            
            [weakSelf searchAlbum:weakSelf.str_search];
            
        }else{
        
            [weakSelf searchMedia:weakSelf.str_search];
        
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
        _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
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
        _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
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
            [weakSelf loadAlbumStatus:data];
            
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
        
    }else{
    
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
    
    }
   
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_isAlbum) {
        
        XMAlbum * album = _mArr_data[indexPath.row];
        
        ChildAlbumDetailVC *t_vc = [[ChildAlbumDetailVC alloc] init];
        t_vc.album_xima = album;
        
        [self.navigationController pushViewController:t_vc animated:YES];
    }else{
    
        ChildCommonCell *cell = (ChildCommonCell *)[self.tb_content cellForRowAtIndexPath:indexPath];
        
        
        NSMutableDictionary * t_dic = _mArr_data[indexPath.row];
        XMTrack *track = [t_dic objectForKey:@"Track"];
        
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
    
    }
    
}

#pragma mark -
#pragma mark ChildCommonCellDelegate

- (void)handleDownBtnActionInCell:(ChildCommonCell *)cell{
    
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
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:NSLocalizedString(@"已添加到下载队列，切换至对讲模式开始下载，是否马上切换？", nil) delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"忽略", nil];
            alert.tag = 11;
            [alert show];
        }else{
            [ShowHUD showSuccess:NSLocalizedString(@"已添加到下载队列", nil) configParameter:^(ShowHUD *config) {
            } duration:2.0f inView:ApplicationDelegate.window];
        }

    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:@"下载失败" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
    }];

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
                    [ShowHUD showSuccess:NSLocalizedString(@"切换成功", nil) configParameter:^(ShowHUD *config) {
                    } duration:1.5f inView:self.view];
                }else{
                    [ShowHUD showSuccess:NSLocalizedString(@"设备不在线，五分钟内生效", nil)
                         configParameter:^(ShowHUD *config) {
                         } duration:1.5f inView:self.view];
                }
                return ;
            }
            [ShowHUD showSuccess:NSLocalizedString(@"切换成功", nil) configParameter:^(ShowHUD *config) {
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
