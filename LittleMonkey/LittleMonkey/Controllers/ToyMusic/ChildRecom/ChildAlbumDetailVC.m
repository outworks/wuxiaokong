//
//  ChildAlbumDetailVC.m
//  HelloToy
//
//  Created by huanglurong on 16/4/24.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildAlbumDetailVC.h"
#import "NDAlbumAPI.h"
#import "NDToyAPI.h"
#import "ChildCommonCell.h"
#import "UIImageView+WebCache.h"
#import "FXBlurView.h"
#import <QuartzCore/QuartzCore.h>
#import "ChildMusicVC.h"
#import "ChildSelectView.h"
#import "PureLayout.h"
#import "DownloadedVC.h"

#import "ChooseView.h"

#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+PullTORefresh.h"

#import "ND3rdMediaAPI.h"

#import "ChildMediaBatVC.h"
#import "TranceiverDescriptVC.h"
#import "UIAlertView+BlocksKit.h"

@interface ChildAlbumDetailVC(){
    ShowHUD *_hud;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgv_background;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_icon;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_desc;
@property (weak, nonatomic) IBOutlet UILabel *lb_musicNumber;
@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (weak, nonatomic) IBOutlet UILabel * lb_info;
@property (weak, nonatomic) IBOutlet UIView *v_info;
@property (weak, nonatomic) IBOutlet UIView *v_top;


@property (weak, nonatomic) IBOutlet UIButton *btn_xuanji;
@property (weak, nonatomic) IBOutlet UIButton *btn_download;
@property (weak, nonatomic) IBOutlet UIButton *btn_batPlay;
@property (weak, nonatomic) IBOutlet UIButton *btn_batDownload;
@property (weak, nonatomic) IBOutlet UIImageView *imgV_separation;



@property (nonatomic, weak) IBOutlet FXBlurView *blurView;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_arrow;

@property (nonatomic,strong) ChildSelectView *childSelectView;

@property (nonatomic,strong) NSMutableArray *arr_currentData;
@property (nonatomic,strong) NSMutableArray *mArr_Collection;


@property (assign,nonatomic) int            page_album;
@property (assign,nonatomic) int            index_page;
@property (assign,nonatomic) BOOL           isAlbumLastPage;
@property (nonatomic,assign) BOOL           isReload;

@property (nonatomic,assign) BOOL           isDownloadData;
@property (nonatomic,strong) NSMutableArray *mArr_downloadData;

@property (nonatomic,strong) NSNumber *playMediaId;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_play;


@end

@implementation ChildAlbumDetailVC


#pragma mark -
#pragma mark init
- (instancetype)init{
    if ( self = [super init]) {
        [NotificationCenter addObserver:self selector:@selector(collectionNotication:) name:NOTIFCATION_COLLECTION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPlayDown:) name:@"播放完刷新" object:nil];
        [NotificationCenter addObserver:self selector:@selector(removeMedia:) name:@"移除媒体通知" object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if (![ShareValue sharedShareValue].mArr_collections) {
//        
//        [ChildMusicVC loadCollections];
//        
//    }else{
//        
//        _mArr_Collection = [ShareValue sharedShareValue].mArr_collections;
//        
//    }
    
    [_tb_content triggerPullScrolling];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
     _v_info.hidden = YES;
    self.arr_currentData = [NSMutableArray array];
    self.mArr_downloadData = [NSMutableArray array];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadStatusAction:) name:NOTIFCATION_DOWNLOADSTATUSARR object:nil];
    
    if (![ShareValue sharedShareValue].toyDetail.toy_id) {
        [_btn_batDownload setHidden:YES];
    }else{
        [self showRightBarButtonItemWithTitle:@"玩具下载" target:self action:@selector(btnDownloadListentAction:)];
    }
    
    self.blurView.blurRadius = 30.0;
    _page_album = 1;
    _index_page = _page_album;
    
    
    
    if (_albumInfo && _albumInfo.source.intValue != 100) {
        
        [self.btn_batPlay setHidden:YES];
        self.navigationItem.title = _albumInfo.name;

        [_imgv_icon sd_setImageWithURL:[NSURL URLWithString:_albumInfo.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        [_imgv_background sd_setImageWithURL:[NSURL URLWithString:_albumInfo.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        _lb_title.text = _albumInfo.name;
        _lb_desc.text = _albumInfo.desc;
        if ([_albumInfo.desc length] == 0) {
            _imgv_arrow.hidden = YES;
        }
        _lb_musicNumber.text = [NSString stringWithFormat:@"共%d条声音",[_albumInfo.number integerValue]];
        
        __weak typeof(self) weakSelf = self;
        
        [_tb_content addPullScrollingWithActionHandler:^{
            weakSelf.isReload = YES;
            weakSelf.page_album = weakSelf.index_page;
            
            [weakSelf loadAblumDetail];
        }];
        
        [_tb_content addInfiniteScrollingWithActionHandler:^{
             weakSelf.isReload = NO;
            [weakSelf loadAblumDetail];
            
        }];
        
        
    
    }else if(_album_xima|| _albumInfo.source.intValue == 100){
        
        __weak typeof(self) weakSelf = self;
        
        [self.btn_batPlay setHidden:YES];
       
        if (_albumInfo.source.intValue == 100) {
            self.navigationItem.title = _albumInfo.name;
            [_imgv_icon sd_setImageWithURL:[NSURL URLWithString:_albumInfo.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
            [_imgv_background sd_setImageWithURL:[NSURL URLWithString:_albumInfo.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
            _lb_title.text = _albumInfo.name;
            _lb_desc.text = _albumInfo.desc;
        }else{
            self.navigationItem.title = _album_xima.albumTitle;
            [_imgv_icon sd_setImageWithURL:[NSURL URLWithString:_album_xima.coverUrlMiddle] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
            [_imgv_background sd_setImageWithURL:[NSURL URLWithString:_album_xima.coverUrlMiddle] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
            _lb_title.text = _album_xima.albumTitle;
            _lb_desc.text = _album_xima.albumIntro;
        }

        if ([_album_xima.albumIntro length] == 0) {
            _imgv_arrow.hidden = YES;
        }
        _lb_musicNumber.text = [NSString stringWithFormat:@"共%d条声音",_album_xima.includeTrackCount];
        
        _isReload = YES;
        _isAlbumLastPage = NO;
        
        [_tb_content addPullScrollingWithActionHandler:^{
            weakSelf.isReload = YES;
            weakSelf.page_album = weakSelf.index_page;
            
            [weakSelf loadXimalayaAlbum];
        }];
        
        [_tb_content addInfiniteScrollingWithActionHandler:^{
            weakSelf.isReload = NO;
            [weakSelf loadXimalayaAlbum];
            
        }];
        
    }else if(_downloadAlbumInfo){
        
        __weak typeof(self) weakSelf = self;
        
        self.layout_play.constant = 10;
        [self.btn_batDownload setHidden:YES];
        
        self.navigationItem.title = _downloadAlbumInfo.name;
        
        [self showRightBarButtonItemWithTitle:@"添加" target:self action:@selector(btnBatchDownloadAction:)];
        
        [_imgv_icon sd_setImageWithURL:[NSURL URLWithString:_downloadAlbumInfo.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        [_imgv_background sd_setImageWithURL:[NSURL URLWithString:_downloadAlbumInfo.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        _lb_title.text = _downloadAlbumInfo.name;
        _lb_desc.text = _downloadAlbumInfo.desc;
        if ([_downloadAlbumInfo.desc length] == 0) {
            _imgv_arrow.hidden = YES;
        }
        
        _lb_musicNumber.text = [NSString stringWithFormat:@"%d条声音",[_downloadAlbumInfo.download_count integerValue]];
        
        [_tb_content addPullScrollingWithActionHandler:^{
            weakSelf.isReload = YES;
            weakSelf.page_album = weakSelf.index_page;
            
            [weakSelf loadDownloadAblumDatail];
        }];
        
        [_tb_content addInfiniteScrollingWithActionHandler:^{
            weakSelf.isReload = NO;
            [weakSelf loadDownloadAblumDatail];
        }];
        
    }
    
}

-(void)queryToyDownloadInfo{
    
    NDToyDownloadInfoParams *params = [[NDToyDownloadInfoParams alloc]init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    [NDToyAPI toyQueryDownloadInfoWithParams:params completionBlockWithSuccess:^(ToyDownloadInfo *info) {
        //_downloadMediaCount = info.downloading;
    } Fail:^(int code, NSString *failDescript) {
        
    }];
}

#pragma mark - private

-(void)toyMediaDeleteRequest:(NSNumber *)media_id;{

    NDToyMediaDeleteParams *params = [[NDToyMediaDeleteParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.media_ids = @[media_id];
    [NDToyAPI toyMediaDeleteWithParams:params completionBlockWithSuccess:^{
        
        [ShowHUD showSuccess:@"从玩具中删除成功" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];

        [_tb_content triggerPullScrolling];
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        
    }];
    

}


-(void)loadDownloadAblumDatail{
    
    if (_downloadAlbumInfo) {
        
        __weak __typeof(*&self) weakSelf = self;
        
        if (_page_album == 1) {
            
            _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
            } inView:self.view];
            
        }
        
        NDToyAlbumDetailParams *params = [[NDToyAlbumDetailParams alloc] init];
        params.album_id = _downloadAlbumInfo.album_id;
        params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
        params.page = _page_album;
        params.rows = 20;
        
        [NDToyAPI toyAlbumDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
            if (_hud) [_hud hide];
            [weakSelf.tb_content.infiniteScrollingView stopAnimating];
            [weakSelf.tb_content.pullScrollingView stopAnimating];
            
            if ([data count] < 20) {
                
                weakSelf.isAlbumLastPage = YES;
                
            }else{
                
                weakSelf.isAlbumLastPage = NO;
            }
            
            if (_isReload) {
                [weakSelf.arr_currentData removeAllObjects];
                [self reloadWhenDownloaded];
            }

            [weakSelf.arr_currentData addObjectsFromArray:data];
            weakSelf.tb_content.showsInfiniteScrolling = !weakSelf.isAlbumLastPage;
            [weakSelf.tb_content reloadData];
            
            weakSelf.page_album ++;
            
        } Fail:^(int code, NSString *failDescript) {
            if (_hud) [_hud hide];
            
            [weakSelf.tb_content.infiniteScrollingView stopAnimating];
            [weakSelf.tb_content.pullScrollingView stopAnimating];
            
            [weakSelf.tb_content reloadData];
            
            
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:weakSelf.view];
        }];
        
    }
}

/***    请求专辑详情数据    ***/

- (void)loadAblumDetail{
    
    if (_albumInfo) {
        
        __weak __typeof(*&self) weakSelf = self;
        
        if (_page_album == 1) {
            
            _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
            } inView:self.view];
            
        }
        
        NDAlbumDetailParams *params = [[NDAlbumDetailParams alloc] init];
        params.album_id = _albumInfo.album_id;
        params.page = @(_page_album);
        params.rows = @20;
        
        [NDAlbumAPI albumDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
            
            if (_hud) [_hud hide];
            [weakSelf.tb_content.pullScrollingView stopAnimating];
            [weakSelf.tb_content.infiniteScrollingView stopAnimating];
            
            if ([data count] < 20) {
                
                weakSelf.isAlbumLastPage = YES;
                
            }else{
                
                weakSelf.isAlbumLastPage = NO;
            }

            if (_isReload) {
                [weakSelf.arr_currentData removeAllObjects];
            }
            
            
            for (int i = 0; i < [data count]; i++) {
                AlbumMedia *albumMedia = data[i];
                NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
                [t_dic setObject:albumMedia forKey:@"AlbumMedia"];
                [weakSelf.arr_currentData addObject:t_dic];
            }
            
            [weakSelf queryMediaStatus:data];
            
            weakSelf.tb_content.showsInfiniteScrolling = !weakSelf.isAlbumLastPage;
            [weakSelf.tb_content reloadData];
            
            weakSelf.page_album ++;
            
        } Fail:^(int code, NSString *failDescript) {
            
            if (_hud) [_hud hide];
            
            [weakSelf.tb_content.infiniteScrollingView stopAnimating];
            [weakSelf.tb_content.pullScrollingView stopAnimating];
            [weakSelf.tb_content reloadData];

            
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:weakSelf.view];
            
            weakSelf.page_album ++;
            
        }];
        
    }
    
}

- (void)loadXimalayaAlbum{

     __weak typeof(self) weakSelf = self;
    
    if (_page_album == 1) {
        
        _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
        } inView:self.view];
        
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!_album_xima && _albumInfo.source.intValue == 100) {
        [params setObject:_albumInfo.third_id forKey:@"album_id"];
    }else{
        [params setObject:@(_album_xima.albumId) forKey:@"album_id"];
    }

    [params setObject:@20 forKey:@"count"];
    [params setObject:[NSNumber numberWithInteger:_page_album] forKey:@"page"];
    [params setObject:@"desc" forKey:@"sort"];
    
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_AlbumsBrowse params:params withCompletionHander:^(id result, XMErrorModel *error) {
        
        if(!error){
            
            if (!_album_xima && _albumInfo.source.intValue == 100) {
                NSDictionary *dict = result;
                _album_xima = [[XMAlbum alloc] initWithDictionary:result];
                _album_xima.albumId = _albumInfo.third_id.intValue;
                self.navigationItem.title = _album_xima.albumTitle;
                [_imgv_icon sd_setImageWithURL:[NSURL URLWithString:_album_xima.coverUrlMiddle] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
                [_imgv_background sd_setImageWithURL:[NSURL URLWithString:_album_xima.coverUrlMiddle] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
                _lb_title.text = _album_xima.albumTitle;
                _lb_desc.text = _album_xima.albumIntro;
                if ([_album_xima.albumIntro length] == 0) {
                    _imgv_arrow.hidden = YES;
                }
                NSNumber *total = [dict objectForKey:@"total_count"];
                _album_xima.includeTrackCount = total.intValue;
                _lb_musicNumber.text = [NSString stringWithFormat:@"共%ld条声音",_album_xima.includeTrackCount];
            }
            NSArray *data = [self showReceivedData:result className:@"XMTrack" valuePath:@"tracks"];

            if (_hud) [_hud hide];
            [weakSelf.tb_content.infiniteScrollingView stopAnimating];
            [weakSelf.tb_content.pullScrollingView stopAnimating];
            if ([data count] < 20) {
                
                weakSelf.isAlbumLastPage = YES;
                
            }else{
            
                weakSelf.isAlbumLastPage = NO;
            }
            
            if (weakSelf.isReload) {
                [weakSelf.arr_currentData removeAllObjects];
            }
            
            
            for (int i = 0; i < [data count]; i++) {
                XMTrack *track = data[i];
                NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
                [t_dic setObject:track forKey:@"Track"];
                [weakSelf.arr_currentData addObject:t_dic];
            }
            
            [weakSelf loadAlbumStatus:data];
           
            weakSelf.tb_content.showsInfiniteScrolling = !weakSelf.isAlbumLastPage;
            [weakSelf.tb_content reloadData];
            
            weakSelf.page_album ++;
            
        }else{
            
            NSLog(@"%@   %@",error.description,result);
            if (_hud) [_hud hide];
            
            [weakSelf.tb_content.infiniteScrollingView stopAnimating];
            [weakSelf.tb_content.pullScrollingView stopAnimating];
            
            [weakSelf.tb_content reloadData];
            
            [ShowHUD showError:error.description configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:weakSelf.view];
            
        }
        
    }];

}

- (void)loadAlbumStatus:(NSArray *)data{

    __weak typeof(self) weakSelf = self;
    
    NSMutableArray *ids = [NSMutableArray array];
    for (XMTrack *track in data) {
        [ids addObject:@(track.trackId)];
    }
    
    if (![ShareValue sharedShareValue].toyDetail.toy_id) {
        return;
    }
    
    
    ND3rdMediaQeueryMediaParams *params = [[ND3rdMediaQeueryMediaParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.source = @100;
    params.third_mid_list = [ids componentsJoinedByString:@","];
    
    [ND3rdMediaAPI thirdMediaQeueryMediaWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        
        if (data && [data count] > 0 ) {
            
            for (MediaDownloadStatus *status in data) {
                
                for (NSMutableDictionary *t_dic in weakSelf.arr_currentData) {
                    
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
    params.album_id  = _albumInfo.album_id;
    
    [NDAlbumAPI mediaStatusQueryWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        
        if (data && [data count] > 0 ) {
            for (MediaDownloadStatus *status in data) {
                
                for (NSMutableDictionary *t_dic in weakSelf.arr_currentData) {
                    
                    AlbumMedia *albumMedia = [t_dic objectForKey:@"AlbumMedia"];
                    
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

- (NSString *)gainMediaList:(NSMutableArray *)mediaMuArray
{
    NSMutableString *mediaListString = [@"" mutableCopy];
    if (mediaMuArray.count > 0) {
        for (int i = 0; i < mediaMuArray.count; i++) {
            
            AlbumMedia *albumMedia = (AlbumMedia *)mediaMuArray[i];
            
            if (i == 0) {
                
                [mediaListString appendFormat:@"%d",[albumMedia.media_id intValue]];
                
            } else {
                
                [mediaListString appendFormat:@",%d",[albumMedia.media_id intValue]];
            }
        }
        
    }
    return mediaListString;
}

- (void)reloadWhenDownloaded{

    __weak typeof(self) weakSelf = self;
    
    NDToyQueryDownloadAlbumParams *params = [[NDToyQueryDownloadAlbumParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.album_id = _downloadAlbumInfo.album_id;
    [NDToyAPI toyQueryDownloadAlbumWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        
        if (data && [data count] > 0) {
            
            DownloadAlbumInfo *downloadAlbumInfo = data[0];
            weakSelf.downloadAlbumInfo.number =downloadAlbumInfo.number;
            weakSelf.downloadAlbumInfo.download_count = downloadAlbumInfo.download_count;
            weakSelf.lb_musicNumber.text = [NSString stringWithFormat:@"%d条声音",[weakSelf.downloadAlbumInfo.download_count integerValue]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"刷新下载SB列表" object:nil userInfo:nil];
            
        }
        
    } Fail:^(int code, NSString *failDescript) {
        
        
    }];
    

}


#pragma mark - buttonAction

- (IBAction)btnDescAction:(id)sender {
    
    if (_album_xima){
        if(!_album_xima.albumIntro)
            return;
    }else if (_downloadAlbumInfo){
        if(!_downloadAlbumInfo.desc)
            return;
    }else if (_albumInfo) {
        if(!_albumInfo.desc)
            return;
    }
    TranceiverDescriptVC *vc = [[TranceiverDescriptVC alloc]init];
    if (_album_xima){
        vc.desc = _album_xima.albumIntro;
    }else if (_downloadAlbumInfo){
        vc.desc = _downloadAlbumInfo.desc;
    }else if (_albumInfo) {
        vc.desc = _albumInfo.desc;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (IBAction)btnSelectedAciton:(id)sender {
    
    
    for(UIView *t_view in self.view.subviews){
        
        if([t_view isKindOfClass:[ChildSelectView class]]){
            
            [t_view removeFromSuperview];
            _childSelectView = nil;
            
            return;
            
        }
    }
    __weak typeof(self) weakSelf = self;
    
    _childSelectView = [ChildSelectView initCustomView];
    
    [self.view addSubview:_childSelectView];
     [self.childSelectView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.v_top withOffset:0.0f];
    [self.childSelectView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.childSelectView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.childSelectView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.childSelectView layoutIfNeeded];
    
    if(_album_xima){
        [self.childSelectView setUpLabels:_album_xima.includeTrackCount WithIndex:_index_page];
    }else if(_downloadAlbumInfo){
        [self.childSelectView setUpLabels:[_downloadAlbumInfo.download_count integerValue]WithIndex:_index_page];
    }else if (_albumInfo && _albumInfo.source.intValue != 100) {
        [self.childSelectView setUpLabels:[_albumInfo.number integerValue] WithIndex:_index_page];
    }
    

    self.childSelectView.block_tag = ^(NSInteger index){
        
        weakSelf.isReload = YES;
        weakSelf.index_page = (int)index;
        
        weakSelf.page_album = weakSelf.index_page;
        
        if(weakSelf.album_xima){
            
            [weakSelf loadXimalayaAlbum];
            
        }else if(weakSelf.downloadAlbumInfo){
            
            [weakSelf loadDownloadAblumDatail];
        }else if (weakSelf.albumInfo) {
            
            [weakSelf loadAblumDetail];
            
        }

        
        
        [weakSelf.childSelectView hide];
        
    };
    
    [self.childSelectView show];
    
}

- (IBAction)btnDownloadedAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    btn.selected = !btn.selected;
    
    _isDownloadData = btn.selected;
    
    if ([_mArr_downloadData count] > 0) {
        [_mArr_downloadData removeAllObjects];
    }
    
    for (NSMutableDictionary *t_dic in self.arr_currentData) {
        
        MediaDownloadStatus *status = [t_dic objectForKey:@"MediaDownloadStatus"];
        
        if (![status.download isEqualToNumber:@0]) {
            [_mArr_downloadData addObject:t_dic];
        }
    }
    
    if (_isDownloadData) {
        self.tb_content.showsInfiniteScrolling = NO;
    }else{
        self.tb_content.showsInfiniteScrolling = !self.isAlbumLastPage;
    }

    [self.tb_content reloadData];
    
}

- (IBAction)btnBatchPlayAction:(id)sender {
    
    ChildMediaBatVC *t_vc = [[ChildMediaBatVC alloc] init];
    t_vc.type = 1;
    
    if (_albumInfo) {
        
    }else if(_album_xima){
    
    }else if (_downloadAlbumInfo){
        t_vc.downloadAlbumInfo = _downloadAlbumInfo;
    
    }
    
    t_vc.album_xima = self.album_xima;
    [self.navigationController pushViewController:t_vc animated:YES];
    
    
    
}

- (IBAction)btnBatchDownloadAction:(id)sender {
    
    ChildMediaBatVC *t_vc = [[ChildMediaBatVC alloc] init];
    t_vc.type = 0;
    if (_downloadAlbumInfo) {
        
        t_vc.downloadAlbumInfo = self.downloadAlbumInfo;
        
    }else if (_album_xima){
        
        t_vc.album_xima = self.album_xima;
        
    }else if (_albumInfo){
        
        t_vc.albumInfo = self.albumInfo;
        
    }
    
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

- (IBAction)btnDownloadListentAction:(id)sender{
    
    DownloadedVC *t_vc = [[DownloadedVC alloc] init];
    [self.navigationController pushViewController:t_vc animated:YES];
    

}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (_isDownloadData) {
        
        return [_mArr_downloadData count];
        
    }else{
        
        if (_arr_currentData) {
            
            if ([_arr_currentData count] == 0) {
                
                _v_info.hidden = NO;
                
                _lb_info.text = NSLocalizedString(@"当前专辑暂无歌曲", nil);
                
            }else{
                _v_info.hidden = YES;
            }
            
            return [_arr_currentData count];
            
        }else{
            
            return 0;
            
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    ChildCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCommonCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ChildCommonCell" bundle:nil] forCellReuseIdentifier:@"ChildCommonCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCommonCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (![ShareValue sharedShareValue].toyDetail.toy_id) {
        cell.btn_status.hidden = YES;
    }
    
    if (_albumInfo && _albumInfo.source.intValue != 100) {
       
        NSMutableDictionary *t_dic = _arr_currentData[indexPath.row];
        AlbumMedia *albumMedia = [t_dic objectForKey:@"AlbumMedia"];
        MediaDownloadStatus *downloadStatus = [t_dic objectForKey:@"MediaDownloadStatus"];
        cell.albumMedia = albumMedia;
        if ([_albumInfo.source isEqualToNumber:@1]) {
            cell.albumInfo = _albumInfo;
        }
        
        
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
        
        
    }else if(_album_xima || _albumInfo.source.intValue == 100){
        
        NSMutableDictionary *t_dic;
        if (_isDownloadData) {
            t_dic = _mArr_downloadData[indexPath.row];
        }else{
            t_dic = _arr_currentData[indexPath.row];
        }
        XMTrack *track = [t_dic objectForKey:@"Track"];
        MediaDownloadStatus *downloadStatus = [t_dic objectForKey:@"MediaDownloadStatus"];
        
        if (track) {
            cell.album_xima = track;
        }
        
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
        
    }else if(_downloadAlbumInfo){
        
        cell.downloadMediaInfo = _arr_currentData[indexPath.row];
        
        cell.block_more = ^(ChildCommonCell *cell){
            [weakSelf handleDownBtnActionInCell:cell];
        };
    }
    
    [cell setPlayMediaId:_playMediaId];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChildCommonCell *cell = (ChildCommonCell *)[self.tb_content cellForRowAtIndexPath:indexPath];
    
    if(_album_xima){
        
        NSMutableDictionary *t_dic;
        if (_isDownloadData) {
            t_dic = _mArr_downloadData[indexPath.row];
        }else{
            t_dic = _arr_currentData[indexPath.row];
        }
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
        
    }else if(_downloadAlbumInfo){
        
        cell.downloadMediaInfo = _arr_currentData[indexPath.row];
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
    }else if (_albumInfo) {
        NSMutableDictionary *t_dic = _arr_currentData[indexPath.row];
        AlbumMedia *albumMedia = [t_dic objectForKey:@"AlbumMedia"];
        
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChildCommonCell *cell = (ChildCommonCell *)[self.tb_content cellForRowAtIndexPath:indexPath];
    
    if (cell.downloadStatus) {
        
        if ([cell.downloadStatus.download isEqualToNumber:@0]) {
            
            return NO;
            
            
        }else{
            
            return YES;
            
        }
    }else if (cell.downloadMediaInfo){
        
        if ([cell.downloadMediaInfo.status isEqualToNumber:@0]) {
            
            return NO;
            
            
        }else{
            
            return YES;
            
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
    return NSLocalizedString(@"删除", nil);
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setEditing:NO animated:YES];
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        __weak typeof(self) weakSelf = self;
        
        ChildCommonCell *cell = (ChildCommonCell *)[self.tb_content cellForRowAtIndexPath:indexPath];
        
        
        [ChooseView showChooseViewInMiddleWithTitle:PROGRAMNAME andPrimitiveText:nil andChooseList:@[[NSString stringWithFormat:NSLocalizedString(@"从玩具中删除", nil)]] andCancelButtonTitle:NSLocalizedString(@"取消", nil) andConfirmButtonTitle:NSLocalizedString(@"确定", nil) andChooseCompleteBlock:^(NSInteger row) {
            if (cell.downloadStatus) {
                
                [weakSelf toyMediaDeleteRequest:cell.downloadStatus.media_id];
            }else if (cell.downloadMediaInfo){
                [weakSelf toyMediaDeleteRequest:cell.downloadMediaInfo.media_id];
            }

            
            
        } andChooseCancleBlock:^(NSInteger row) {
        }];

        
        
        
    }
}


#pragma mark -
#pragma mark ChildCommonCellDelegate

- (void)handleDownBtnActionInCell:(ChildCommonCell *)cell{

    __weak typeof(self) weakself = self;
    if (_album_xima) {
        
        ND3rdMediaDownloadMediaParams *params = [[ND3rdMediaDownloadMediaParams alloc] init];
        params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
        params.third_aid = @(self.album_xima.albumId);
        params.source = @100;
        params.album_icon = self.album_xima.coverUrlSmall;
        params.album_title = self.album_xima.albumTitle;
        params.third_mid = @(cell.album_xima.trackId);
        params.media_title = cell.album_xima.trackTitle;
        params.media_url = cell.album_xima.playUrl32;
        params.media_icon = cell.album_xima.coverUrlSmall;
        
        [ND3rdMediaAPI thirdMediaDownloadMediaWithParams:params completionBlockWithSuccess:^(MediaDownloadStatus *mediaDownloadStatus) {
            [weakself showRightBarButtonItemToSelected];
            cell.downloadStatus.media_id = mediaDownloadStatus.media_id;
            cell.downloadStatus.third_mid = mediaDownloadStatus.third_mid;
            cell.downloadStatus.download = mediaDownloadStatus.download;
            [_tb_content reloadData];
            if (([ShareValue sharedShareValue].cur_toyState == ToyStateUnKnowState) || ([ShareValue sharedShareValue].cur_toyState == ToyStateUnOnlineState) || ([ShareValue sharedShareValue].cur_toyState == ToyStateDormancyState)) {
                [ShowHUD showSuccess:NSLocalizedString(@"玩具不在线，唤醒后切换至对讲模式开始下载", nil) configParameter:^(ShowHUD *config) {
                } duration:3.0f inView:ApplicationDelegate.window];
            }else{
                if ([ShareValue sharedShareValue].cur_toyState == ToyStateMusicState || [ShareValue sharedShareValue].cur_toyState == ToyStateStoryState) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:NSLocalizedString(@"已添加到下载队列，切换至对讲模式开始下载，是否马上切换？", nil) delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"忽略", nil];
                    alert.tag = 11;
                    [alert show];
                }else{
                    [ShowHUD showSuccess:NSLocalizedString(@"已添加到下载队列", nil) configParameter:^(ShowHUD *config) {
                    } duration:2.0f inView:ApplicationDelegate.window];
                }
            }

        } Fail:^(int code, NSString *failDescript) {
            [ShowHUD showSuccess:failDescript configParameter:^(ShowHUD *config) {
            } duration:2.0f inView:ApplicationDelegate.window];
        }];

    }else if (_albumInfo){
    
        NDMediaDownloadParams *params = [[NDMediaDownloadParams alloc] init];
        params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
        params.media_id = cell.albumMedia.media_id;
        params.album_id = _albumInfo.album_id;
        
        [NDAlbumAPI mediaDownloadWithParams:params completionBlockWithSuccess:^{
             [weakself showRightBarButtonItemToSelected];
            cell.downloadStatus.download = @2;
            [_tb_content reloadData];
            if (([ShareValue sharedShareValue].cur_toyState == ToyStateUnKnowState) || ([ShareValue sharedShareValue].cur_toyState == ToyStateUnOnlineState) || ([ShareValue sharedShareValue].cur_toyState == ToyStateDormancyState)) {
                [ShowHUD showSuccess:NSLocalizedString(@"玩具不在线，唤醒后切换至对讲模式开始下载", nil) configParameter:^(ShowHUD *config) {
                } duration:3.0f inView:ApplicationDelegate.window];
            }else{
                if ([ShareValue sharedShareValue].cur_toyState == ToyStateMusicState || [ShareValue sharedShareValue].cur_toyState == ToyStateStoryState) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:NSLocalizedString(@"已添加到下载队列，切换至对讲模式开始下载，是否马上切换？", nil) delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"忽略", nil];
                    alert.tag = 11;
                    [alert show];
                }else{
                    [ShowHUD showSuccess:NSLocalizedString(@"已添加到下载队列", nil) configParameter:^(ShowHUD *config) {
                    } duration:2.0f inView:ApplicationDelegate.window];
                }
            }
        } Fail:^(int code, NSString *failDescript) {
            [ShowHUD showSuccess:failDescript configParameter:^(ShowHUD *config) {
            } duration:2.0f inView:ApplicationDelegate.window];
        }];

    
    }

}

#pragma mark - scrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    if (scrollView == self.tb_content )
//    {
//        if (scrollView.contentOffset.y < 0) {
//            CGPoint position = CGPointMake(0, 0);
//            [scrollView setContentOffset:position animated:NO];
//            return;
//        }
//    }
//}

#pragma mark -
#pragma mark 通知事件

- (void)collectionNotication:(NSNotification *)note{
    
 
    
    
}

- (void)reloadPlayDown:(NSNotification *)note{
    
    _playMediaId = nil;
    [self.tb_content reloadData];


}

/**************** 批量下载通知 *****************/

- (void)downloadStatusAction:(NSNotification *)note{
    
    NSDictionary *t_dic = [note userInfo];
    
    if (t_dic) {
        
        NSArray *t_arr = [t_dic objectForKey:@"downloadStatusArr"];
        
        for (NSMutableDictionary *t_dic in _arr_currentData) {
            
            MediaDownloadStatus *t_downloadStatus = [t_dic objectForKey:@"MediaDownloadStatus"];
            for(MediaDownloadStatus *downloadStatus in t_arr){
                
                if ([downloadStatus.third_mid isEqualToNumber:t_downloadStatus.third_mid]) {
                    [t_dic setObject:downloadStatus forKey:@"MediaDownloadStatus"];
                    break;
                }
                
            }
        }
        
        [self.tb_content reloadData];
        
    }else{
    
        [self.tb_content triggerPullScrolling];
        
    }
    
}

- (void)removeMedia:(NSNotification *)note{
    
    [self.tb_content triggerPullScrolling];
}



#pragma mark - dealloc

- (void)dealloc{

    NSLog(@"ChildAlbumDetailVC dealloc");
    
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

@end
