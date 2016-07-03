//
//  ChildSearchVC.m
//  HelloToy
//
//  Created by huanglurong on 16/4/28.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildSearchVC.h"
#import "UIButton+Block.h"
#import "XMSDK.h"
#import "ChildAlbumListCell.h"
#import "ChildCommonCell.h"
#import "PureLayout.h"
#import "NDAlbumAPI.h"
#import "NDToyAPI.h"
#import "ND3rdMediaAPI.h"
#import "ChildSearchMoreVC.h"
#import "ChildAlbumDetailVC.h"
#import "UIActionSheet+BlocksKit.h"
#import "NDMediaAPI.h"
#import "NDAlbumAPI.h"
#import "MediaDownloadStatus.h"

@interface ChildSearchVC (){
    ShowHUD *_hud;
}


@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *v_noData;

@property (strong, nonatomic) IBOutlet UIView *v_album;
@property (strong, nonatomic) IBOutlet UIView *v_media;
@property (strong, nonatomic) IBOutlet UIView *v_ndmedia;

@property (strong, nonatomic) IBOutlet UIButton *btn_album;
@property (strong, nonatomic) IBOutlet UIButton *btn_media;

@property (assign, nonatomic) NSInteger albumNumber;
@property (assign, nonatomic) NSInteger mediaNumber;
@property (nonatomic,strong) NSString *str_search;

@property (nonatomic,strong) NSMutableArray *mArr_album;
@property (nonatomic,strong) NSMutableArray *mArr_media;
@property (nonatomic,strong) NSMutableArray *mArr_ndmeida;
@property (nonatomic,strong) NSNumber *playMediaId;


@end

@implementation ChildSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private

-(void)initUI{
    
    __weak __typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPlayDown:) name:@"播放完刷新" object:nil];
    
    [_btn_cancel handleClickEvent:UIControlEventTouchUpInside withClickBlick:^{
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    _v_noData.hidden = YES;
    [self.navigationController setDelegate:(id<UINavigationControllerDelegate>)self];
    
    UIImage *image = [UIImage imageNamed:@"child_search"];
    CGRect frame = CGRectMake(0, 0, image.size.width+5, image.size.height);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImage:image];
    [imageView setContentMode:UIViewContentModeRight];
    _tf_search.leftView = imageView;
    [_tf_search setLeftViewMode:UITextFieldViewModeUnlessEditing];
    
}

-(void)initData{
    _mArr_album = [NSMutableArray array];
    _mArr_media = [NSMutableArray array];
    _mArr_ndmeida = [NSMutableArray array];
}

-(void)searchNDMeida:(NSString *)name{
    __weak typeof(self) weakself = self;
    NDMediaQueryParams *params = [[NDMediaQueryParams alloc]init];
    params.name = name;
//    params.page = @1;
    [NDMediaAPI mediaQueryWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        if ([_mArr_ndmeida count] > 0 ) {
            [_mArr_ndmeida removeAllObjects];
        }
        for (AlbumMedia *albumMedia in data) {
            NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
            [t_dic setObject:albumMedia forKey:@"media"];
            [_mArr_ndmeida addObject:t_dic];
        }
        [weakself loadNdMediaDownloadStatus:data];
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        [_tableView reloadData];
    }];
}

- (void)searchAlbum:(NSString *)albumName{

    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@6 forKey:@"category_id"];
    [params setObject:@3 forKey:@"count"];
    [params setObject:@1 forKey:@"page"];
    [params setObject:albumName forKey:@"q"];
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_SearchAlbums params:params withCompletionHander:^(id result, XMErrorModel *error) {
        
        if (!error) {
            
            weakSelf.albumNumber = [(NSNumber *)[(NSDictionary *)result objectForKey:@"total_count"] integerValue];
            [weakSelf.btn_album setTitle:[NSString stringWithFormat:@"全部%ld张专辑 》",weakSelf.albumNumber] forState:UIControlStateNormal];
            
            if (weakSelf.albumNumber > 3) {
                weakSelf.btn_album.hidden = NO;
            }else{
                weakSelf.btn_album.hidden = YES;
            }
            
            NSArray *data = [self showReceivedData:result className:@"XMAlbum" valuePath:@"albums"];
            
            if ([_mArr_album count] > 0 ) {
                [_mArr_album removeAllObjects];
            }
            
            [_mArr_album addObjectsFromArray:data];
            
           [_tableView reloadData];
          
        
        }else{
            
            [ShowHUD showError:error.description configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:ApplicationDelegate.window];
            [weakSelf.tableView reloadData];

            
        }
        
    }];
    

}

- (void)searchMedia:(NSString *)mediaName{
    
    __weak typeof(self) weakSelf = self;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@6 forKey:@"category_id"];
    [params setObject:@3 forKey:@"count"];
    [params setObject:@1 forKey:@"page"];
    [params setObject:mediaName forKey:@"q"];
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_SearchTracks params:params withCompletionHander:^(id result, XMErrorModel *error) {
        
        if (!error) {
            
            weakSelf.mediaNumber = [(NSNumber *)[(NSDictionary *)result objectForKey:@"total_count"] integerValue];
            
            NSArray *data = [self showReceivedData:result className:@"XMTrack" valuePath:@"tracks"];
           [weakSelf.btn_media setTitle:[NSString stringWithFormat:@"全部%ld首歌 》", weakSelf.mediaNumber ] forState:UIControlStateNormal];
            
            if (weakSelf.mediaNumber > 3) {
                weakSelf.btn_media.hidden = NO;
            }else{
                weakSelf.btn_media.hidden = YES;
            }
            
            if ([_mArr_media count] > 0 ) {
                [_mArr_media removeAllObjects];
            }
            
            for (int i = 0; i < [data count]; i++) {
                XMTrack *track = data[i];
                NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
                [t_dic setObject:track forKey:@"Track"];
                [weakSelf.mArr_media addObject:t_dic];
            }
            
            [weakSelf loadAlbumStatus:data];
            
            [weakSelf.tableView reloadData];

            
        }else{
            
            [ShowHUD showError:error.description configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:ApplicationDelegate.window];
            [weakSelf.tableView reloadData];
        }
        
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
                for (NSDictionary *dict in _mArr_ndmeida) {
                    AlbumMedia *albumMedia = [dict objectForKey:@"media"];
                    if ([albumMedia.media_id isEqualToNumber:status.media_id]) {
                        [dict setValue:status forKey:@"status"];
                        break;
                    }
                }
            }
            [weakSelf.tableView reloadData];
        } Fail:^(int code, NSString *failDescript) {
            
        }];
    }
}

- (void)loadAlbumStatus:(NSArray *)data{
    
    if (![ShareValue sharedShareValue].toyDetail.toy_id) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
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
                for (NSMutableDictionary *t_dic in weakSelf.mArr_media) {
                    
                    XMTrack *track = [t_dic objectForKey:@"Track"];
                    
                    if ([@(track.trackId) isEqualToNumber:status.third_mid]) {
                        
                        [t_dic setObject:status forKey:@"MediaDownloadStatus"];
                        break;
                    }
                }
            }
            
            [weakSelf.tableView reloadData];
            
        }
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:@"请求下载状态失败" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
        [weakSelf.tableView reloadData];
        
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

#pragma mark - buttonAction

- (IBAction)btnAlbumAction:(id)sender {
    
    ChildSearchMoreVC *t_vc = [[ChildSearchMoreVC alloc] init];
    t_vc.isAlbum = YES;
    t_vc.str_search = _str_search;
    [self.navigationController pushViewController:t_vc animated:YES];
}

- (IBAction)btnMediaAction:(id)sender {
    ChildSearchMoreVC *t_vc = [[ChildSearchMoreVC alloc] init];
    t_vc.isAlbum = NO;
    t_vc.str_search = _str_search;
    [self.navigationController pushViewController:t_vc animated:YES];
}

- (IBAction)btnNdMediaAction:(id)sender {
    ChildSearchMoreVC *t_vc = [[ChildSearchMoreVC alloc] init];
    t_vc.isAlbum = NO;
    t_vc.str_search = _str_search;
    t_vc.isNdMedia = YES;
    [self.navigationController pushViewController:t_vc animated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return 3;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( section == 0 && [_mArr_album count] > 0) {
        return _v_album;
    }else if (section == 1&& [_mArr_media count] > 0){
        return _v_media;
    }else if (section == 2 && [_mArr_ndmeida count] > 0){
        return _v_ndmedia;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 0 && [_mArr_album count] > 0) {
        return 40.f;
    }else if (section == 1 && [_mArr_media count] > 0){
        return 40.f;
    }else if (section == 2 && [_mArr_ndmeida count] > 0){
        return 40.f;
    }else{
        return 0.f;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 0;
    }else if(section == 0){
        return [_mArr_album count]? 10 : 0;
    }else  if(section == 1){
        return [_mArr_media count]? 10 : 0;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return [_mArr_album count];
    }else if (section == 1){
        return [_mArr_media count];
    }else if (section == 2){
        return MIN([_mArr_ndmeida count], 5) ;
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    if (indexPath.section == 0) {
        
        ChildAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildAlbumListCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"ChildAlbumListCell" bundle:nil] forCellReuseIdentifier:@"ChildAlbumListCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChildAlbumListCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        XMAlbum * album = _mArr_album[indexPath.row];
        cell.album = album;
        
        return cell;
        
        
    }else if (indexPath.section == 1) {
        
        ChildCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCommonCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"ChildCommonCell" bundle:nil] forCellReuseIdentifier:@"ChildCommonCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCommonCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([_mArr_media count] > 0) {
            NSMutableDictionary *t_dic = _mArr_media[indexPath.row];
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
            
            cell.albumMedia = nil;
            
            [cell setPlayMediaId:_playMediaId];
        }
        
        return cell;
        
    }else {
        
        ChildCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCommonCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"ChildCommonCell" bundle:nil] forCellReuseIdentifier:@"ChildCommonCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCommonCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *t_dic = [_mArr_ndmeida objectAtIndex:indexPath.row];
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
        
        cell.album_xima = nil;
        
        [cell setPlayMediaId:_playMediaId];
        return cell;
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChildCommonCell *cell = (ChildCommonCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        XMAlbum * album = _mArr_album[indexPath.row];
        
        ChildAlbumDetailVC *t_vc = [[ChildAlbumDetailVC alloc] init];
        t_vc.album_xima = album;
        
        [self.navigationController pushViewController:t_vc animated:YES];
        return;
        
    }else if (indexPath.section == 1){
        NSMutableDictionary * t_dic = _mArr_media[indexPath.row];
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
        
    }else if (indexPath.section == 2){
        
        NSMutableDictionary * t_dic = _mArr_ndmeida[indexPath.row];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 81.0f;
    }else{
        return 65.0f;
    }

}


#pragma mark -
#pragma mark ChildCommonCellDelegate

/*--------------- 点播 --------------*/

- (void) handlePlayBtnActionInCell:(ChildCommonCell *)cell{
    
    if (![ShareValue sharedShareValue].toyDetail) {
        
        [ShowHUD showWarning:NSLocalizedString(@"CurrentNoToy", nil) configParameter:^(ShowHUD *config) {
        } duration:1.0f inView:ApplicationDelegate.window];
        
        return;
    }
    
    NDToyPlayMediaParams *params = [[NDToyPlayMediaParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    
    params.media_id = cell.downloadStatus.media_id;
    params.media_type = @1;
    
    _hud = [ShowHUD showText:NSLocalizedString(@"Requesting", nil) configParameter:^(ShowHUD *config) {
    } inView:ApplicationDelegate.window];
    
    [NDToyAPI toyPlayMediaWithParams:params completionBlockWithSuccess:^{
        
        if (_hud) [_hud hide];
        
        [ShowHUD showSuccess:NSLocalizedString(@"OnDemandSuccessful", nil) configParameter:^(ShowHUD *config) {} duration:1.0f inView:ApplicationDelegate.window];
        
    } Fail:^(int code, NSString *failDescript) {
        
        if (_hud) [_hud hide];
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {} duration:1.0f inView:ApplicationDelegate.window];
        
    }];
    
}

- (void)handleDownBtnActionInCell:(ChildCommonCell *)cell{
    if (cell.albumMedia){
        
        NDMediaDownloadParams *params = [[NDMediaDownloadParams alloc] init];
        params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
        params.media_id = cell.albumMedia.media_id;
        
        [NDAlbumAPI mediaDownloadWithParams:params completionBlockWithSuccess:^{
            cell.downloadStatus.download = @2;
            [_tableView reloadData];
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
    }else if(cell.album_xima){
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
            [_tableView reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"媒体下载到玩具的通知" object:nil];
            
        } Fail:^(int code, NSString *failDescript) {
            
        }];

    }
    
    
}


#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView )
    {
        if (scrollView.contentOffset.y < 0) {
            CGPoint position = CGPointMake(0, 0);
            [scrollView setContentOffset:position animated:NO];
            return;
        }
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([_tf_search.text isEqualToString:@""]) {
        
        [ShowHUD showTextOnly:@"请输入歌曲名或故事名" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return NO;
    }else{
        _v_noData.hidden = YES;
        [_tf_search resignFirstResponder];
      
        _str_search = _tf_search.text;
        [self searchAlbum:_tf_search.text];
        [self searchMedia:_tf_search.text];
        [self searchNDMeida:_tf_search.text];
        return YES;
    }
    
}


#pragma mark - navigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[self class]]) {
        self.navigationController.navigationBarHidden = YES;
    }
    
}

- (void)reloadPlayDown:(NSNotification *)note{
    
    _playMediaId = nil;
    [self.tableView reloadData];
    
    
}


#pragma mark - dealloc 

- (void)dealloc{
    
    NSLog(@"ChildSearchVC dealloc");
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
