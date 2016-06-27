//
//  ChildMediaBatVC.m
//  HelloToy
//
//  Created by huanglurong on 16/4/29.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildMediaBatVC.h"
#import "ChildMediaBatCell.h"
#import "ChildSelectView.h"
#import "ND3rdMediaAPI.h"
#import "PureLayout.h"
#import "ND3RDMedia.h"
#import "ND3rdAlbumInfo.h"
#import "NDAlbumAPI.h"
#import "NDToyAPI.h"
#import "DownloadMediaInfo.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIAlertView+BlocksKit.h"

@interface ChildMediaBatVC (){
    ShowHUD *_hud;
}

@property(nonatomic,strong) NSMutableArray *arr_currentData;
@property(nonatomic,strong) NSMutableArray *arr_selectedData;


@property (weak, nonatomic) IBOutlet UIView *v_top;
@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (weak, nonatomic) IBOutlet UILabel * lb_info;
@property (weak, nonatomic) IBOutlet UIView *v_info;
@property (weak, nonatomic) IBOutlet UIButton *btn_selected;
@property (weak, nonatomic) IBOutlet UIButton *btn_selectedAll;
@property (weak, nonatomic) IBOutlet UIButton *btn_down;
@property (weak, nonatomic) IBOutlet UILabel *lb_musicNumber;


@property (nonatomic,strong) ChildSelectView *childSelectView;

@property (nonatomic,strong) ND3rdAlbumInfo  *thirdAlbumInfo;

@property (nonatomic,assign) BOOL           isReload;
@property (nonatomic,assign) BOOL           isXimaAlbum;
@property (assign,nonatomic) NSInteger      page_album;
@property (assign,nonatomic) BOOL           isAlbumLastPage;
@property (assign,nonatomic) NSInteger      mediaCount;
@property(nonatomic,assign)  NSInteger       downloadMediaCount;

@end

@implementation ChildMediaBatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
#pragma mark - private 

- (void)initUI{
    
    _v_info.hidden = YES;
    _btn_down.layer.cornerRadius = _btn_down.frame.size.height/2;
    _btn_down.userInteractionEnabled = NO;
    self.arr_currentData = [NSMutableArray array];
    self.arr_selectedData = [NSMutableArray array];
    _page_album = 1;
    _isAlbumLastPage = NO;
    _isReload = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDownloadAction) name:@"NOTIFCATION_SHOWDOWNLOAD" object:nil];
    [self queryToyDownloadInfo];

    if (_type == 0) {
        
        self.navigationItem.title = @"下载到玩具";
        [_btn_down setTitle:@"立即下载" forState:UIControlStateNormal];
        if (_album_xima) {
            _mediaCount = _album_xima.includeTrackCount;
        }else if(_downloadAlbumInfo){
            _mediaCount = [_downloadAlbumInfo.number integerValue];
        }else if(_albumInfo){
            _mediaCount = [_albumInfo.number integerValue];
        }
        
        _lb_musicNumber.text = [NSString stringWithFormat:@"总共%ld首",_mediaCount];
        [self.btn_selected setTitle:[NSString stringWithFormat:@"选集(%ld~%ld)",(_page_album-1)*20+1,_page_album*20 > _mediaCount ? _mediaCount : _page_album*20] forState:UIControlStateNormal];
        
        if (_album_xima) {
            
            _isXimaAlbum = YES;
            [self loadXimalayaAlbum];
            
        }else if (_downloadAlbumInfo){
            
            if (_downloadAlbumInfo.source == 100) {
                
                _isXimaAlbum = YES;
                [self loadXimalayaAlbum];
                
            }else{
                
                _isXimaAlbum = NO;
                [self loadAlbumMedia];
                
            }
        
        }else if(_albumInfo){
            
            _isXimaAlbum = NO;
            [self loadAlbumMedia];
        }
    
    }else{
        
        self.navigationItem.title = @"切换玩具专辑";
        [_btn_down setTitle:@"立即发送" forState:UIControlStateNormal];
        
        if (_albumInfo) {
            self.mediaCount = [_albumInfo.number integerValue];
            _lb_musicNumber.text = [NSString stringWithFormat:@"总共%ld首",_mediaCount];
            [self.btn_selected setTitle:[NSString stringWithFormat:@"选集(%ld~%ld)",(_page_album-1)*20+1,_page_album*20 > _mediaCount ? _mediaCount : _page_album*20] forState:UIControlStateNormal];
            [self loadAlbumMedia];
            
        }else if(_downloadAlbumInfo){
            
            self.mediaCount = [_downloadAlbumInfo.download_count integerValue];
            _lb_musicNumber.text = [NSString stringWithFormat:@"总共%ld首",_mediaCount];
            [self.btn_selected setTitle:[NSString stringWithFormat:@"选集(%ld~%ld)",(_page_album-1)*20+1,_page_album*20 > _mediaCount ? _mediaCount : _page_album*20] forState:UIControlStateNormal];
            
            [self loadDownloadAlbumInfo];
            
            __weak typeof(self) weakSelf = self;
            
            [_tb_content addInfiniteScrollingWithActionHandler:^{
                
                weakSelf.isReload = NO;
                [weakSelf loadDownloadAlbumInfo];
                
            }];
            
        }else{
            
            [self loadAlbumInfo]; //请求与第三方专辑相关的本地媒体信息
            
        }
        
    }

}

-(void)queryToyDownloadInfo{
    NDToyDownloadInfoParams *params = [[NDToyDownloadInfoParams alloc]init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    [NDToyAPI toyQueryDownloadInfoWithParams:params completionBlockWithSuccess:^(ToyDownloadInfo *info) {
        _downloadMediaCount = info.downloading;
    } Fail:^(int code, NSString *failDescript) {
        
    }];
}

- (void)showDownloadAction{
    
    if ([_arr_selectedData count] > 0) {
        
        [_btn_down setBackgroundColor:[UIColor colorWithRed:220/255.f green:90.f/255.f blue:55.f/255.f alpha:1.0f]];
        _btn_down.userInteractionEnabled = YES;
        
    }else{
        
        [_btn_down setBackgroundColor:[UIColor colorWithRed:204/255.f green:204.f/255.f blue:204.f/255.f alpha:1.0f]];
        _btn_down.userInteractionEnabled = NO;
        
    }
    
}

#pragma mark - loadData

- (void)loadDownloadAlbumInfo{


    if (_downloadAlbumInfo) {
        
        __weak __typeof(*&self) weakSelf = self;
        
        if (_page_album == 1) {
            
            _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
            } inView:self.view];
            
        }
        
        NDToyAlbumDetailParams *params = [[NDToyAlbumDetailParams alloc] init];
        params.album_id = _downloadAlbumInfo.album_id;
        params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
        params.page = (int)_page_album;
        params.rows = 20;
        
        [NDToyAPI toyAlbumDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
            if (_hud) [_hud hide];
            [weakSelf.tb_content.infiniteScrollingView stopAnimating];
            
            if (weakSelf.isReload) {
                [weakSelf.arr_currentData removeAllObjects];
            }

            
            if ([data count] < 20) {
                weakSelf.isAlbumLastPage = YES;
            }else{
                
                weakSelf.isAlbumLastPage = NO;
            }
            
            [weakSelf.arr_currentData addObjectsFromArray:data];
            weakSelf.tb_content.showsInfiniteScrolling = !weakSelf.isAlbumLastPage;
            [weakSelf.tb_content reloadData];
            
            if (weakSelf.isReload) {
                
                weakSelf.btn_selectedAll.selected = NO;
                [weakSelf btnSelectAllAction:weakSelf.btn_selectedAll];
                
            }
            
            weakSelf.page_album ++;
            
        } Fail:^(int code, NSString *failDescript) {
            if (_hud) [_hud hide];
            
            [weakSelf.tb_content.infiniteScrollingView stopAnimating];
            [weakSelf.tb_content reloadData];
        
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:weakSelf.view];
        }];
        
    }
}


- (void)loadXimalayaAlbum{
    
    __weak typeof(self) weakSelf = self;
    
    _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
    } inView:self.view];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_downloadAlbumInfo) {
        [params setObject:_downloadAlbumInfo.third_aid forKey:@"album_id"];
    }else if (_album_xima){
        [params setObject:@(_album_xima.albumId) forKey:@"album_id"];
    }
    
    [params setObject:@20 forKey:@"count"];
    [params setObject:[NSNumber numberWithInteger:_page_album] forKey:@"page"];
    [params setObject:@"desc" forKey:@"sort"];
    
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_AlbumsBrowse params:params withCompletionHander:^(id result, XMErrorModel *error) {
        
        if(!error){
            
            NSArray *data = [self showReceivedData:result className:@"XMTrack" valuePath:@"tracks"];
            weakSelf.mediaCount  = [(NSNumber *)[(NSDictionary *)result objectForKey:@"total_count"] integerValue];
            weakSelf.lb_musicNumber.text = [NSString stringWithFormat:@"总共%ld首",_mediaCount];
            [weakSelf.btn_selected setTitle:[NSString stringWithFormat:@"选集(%ld~%ld)",(_page_album-1)*20+1,_page_album*20 > _mediaCount ? _mediaCount : _page_album*20] forState:UIControlStateNormal];
            
            if (_hud) [_hud hide];
            
            if ([weakSelf.arr_currentData count] > 0) {
                [weakSelf.arr_currentData removeAllObjects];
            }
            
            
            for (int i = 0; i < [data count]; i++) {
                XMTrack *track = data[i];
                NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
                [t_dic setObject:track forKey:@"Track"];
                [weakSelf.arr_currentData addObject:t_dic];
            }
            
            [weakSelf loadAlbumStatus:data];
            
            [weakSelf.tb_content reloadData];
            
        }else{
            
            NSLog(@"%@   %@",error.description,result);
            if (_hud) [_hud hide];
            
            [weakSelf.tb_content reloadData];
            
            [ShowHUD showError:error.description configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:weakSelf.view];
            
        }
        
    }];
    
}

- (void)loadAlbumInfo{

    __weak typeof(self) weakSelf = self;
    
    ND3rdMediaAlbumDetialParams *params = [[ND3rdMediaAlbumDetialParams alloc] init];
    params.third_aid = @(_album_xima.albumId);
    params.source = @100;
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    
    [ND3rdMediaAPI thirdMediaAlbumDetialWithParams:params completionBlockWithSuccess:^(ND3rdAlbumInfo *data){
        
        if(data){
        
            weakSelf.thirdAlbumInfo = data;
            weakSelf.albumInfo = [[AlbumInfo alloc] init];
            weakSelf.albumInfo.album_id = weakSelf.thirdAlbumInfo.album_id;
            weakSelf.albumInfo.name = weakSelf.thirdAlbumInfo.name;
            weakSelf.albumInfo.icon = weakSelf.thirdAlbumInfo.icon;
            weakSelf.albumInfo.number = weakSelf.thirdAlbumInfo.number;
            weakSelf.mediaCount = [weakSelf.albumInfo.number integerValue];
            weakSelf.lb_musicNumber.text = [NSString stringWithFormat:@"总共%ld首",_mediaCount];
            [weakSelf.btn_selected setTitle:[NSString stringWithFormat:@"选集(%ld~%ld)",(_page_album-1)*20+1,_page_album*20 > _mediaCount ? _mediaCount : _page_album*20] forState:UIControlStateNormal];
            [weakSelf loadAlbumMedia];
        }
    
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:@"请求本地专辑详情失败" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
        
    }];


}

- (void)loadAlbumMedia{

    if (_albumInfo) {
        
        __weak __typeof(*&self) weakSelf = self;
        
        if (_type == 0) {
            
            _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
            } inView:self.view];
            
        }else{
            if (_page_album == 1) {
                
                _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
                } inView:self.view];
                
            }
        }
        
        NDAlbumDetailParams *params = [[NDAlbumDetailParams alloc] init];
        params.album_id = _albumInfo.album_id;
        params.page = @(_page_album);
        params.rows = @20;
        
        [NDAlbumAPI albumDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
            
            if (_hud) [_hud hide];
            
            if (_type != 0) {
                [weakSelf.tb_content.infiniteScrollingView stopAnimating];
                if ([data count] < 20) {
                    
                    weakSelf.isAlbumLastPage = YES;
                    
                }else{
                    
                    weakSelf.isAlbumLastPage = NO;
                }
                
                weakSelf.tb_content.showsInfiniteScrolling = !weakSelf.isAlbumLastPage;
                
                [weakSelf.arr_currentData addObjectsFromArray:data];
                
                [weakSelf.tb_content reloadData];
                
                weakSelf.page_album ++;
                
                [weakSelf btnSelectAllAction:nil];
            
            }else{
                
                if ([weakSelf.arr_currentData count] > 0) {
                    [weakSelf.arr_currentData removeAllObjects];
                }
                
                for (int i = 0; i < [data count]; i++) {
                    
                    AlbumMedia *albumMedia = data[i];
                    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
                    [t_dic setObject:albumMedia forKey:@"AlbumMedia"];
                    [weakSelf.arr_currentData addObject:t_dic];
                    
                }
                
                [weakSelf queryMediaStatus:data];
                
                [weakSelf.tb_content reloadData];
                [weakSelf btnSelectAllAction:nil];
            }
        
        } Fail:^(int code, NSString *failDescript) {
            
            if (_hud) [_hud hide];
            
            [weakSelf.tb_content.infiniteScrollingView stopAnimating];
            [weakSelf.tb_content reloadData];
            
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:weakSelf.view];
            
        }];
        
    }else if (_downloadAlbumInfo){
        
        __weak typeof(self) weakSelf = self;
        
        _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
        } inView:self.view];
        
        NDAlbumDetailParams *params = [[NDAlbumDetailParams alloc] init];
        params.album_id = _downloadAlbumInfo.album_id;
        params.page = @(_page_album);
        params.rows = @20;
        
        [NDAlbumAPI albumDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
            
            if (_hud) [_hud hide];
            
            if ([weakSelf.arr_currentData count] > 0) {
                [weakSelf.arr_currentData removeAllObjects];
            }
            
            for (int i = 0; i < [data count]; i++) {
                AlbumMedia *albumMedia = data[i];
                NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
                [t_dic setObject:albumMedia forKey:@"AlbumMedia"];
                [weakSelf.arr_currentData addObject:t_dic];
            }
        
            [weakSelf queryMediaStatus:data];
            
            [weakSelf.tb_content reloadData];
            [weakSelf btnSelectAllAction:nil];
        
        } Fail:^(int code, NSString *failDescript) {
            
            if (_hud) [_hud hide];
        
            [weakSelf.tb_content reloadData];
            
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:weakSelf.view];
            
        }];
    
        
    }

}

- (void)loadAlbumStatus:(NSArray *)data{
    
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
                for (NSMutableDictionary *t_dic in weakSelf.arr_currentData) {
                    
                    XMTrack *track = [t_dic objectForKey:@"Track"];
                    
                    if ([@(track.trackId) isEqualToNumber:status.third_mid]) {
                        
                        [t_dic setObject:status forKey:@"MediaDownloadStatus"];
                        break;
                    }
                }
            }
            
            [weakSelf.tb_content reloadData];
            [weakSelf btnSelectAllAction:nil];
        }
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:@"请求下载状态失败" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
        
    }];
    
}

- (void)queryMediaStatus:(NSArray *)data{
    
    __weak __typeof(self) weakSelf = self;
    
    NDQueryMediaStatusParams *params = [[NDQueryMediaStatusParams alloc]init];
    
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.medialist = [self gainMediaList:data];
    if (_albumInfo) {
        params.album_id  = _albumInfo.album_id;
    }else if(_downloadAlbumInfo){
        params.album_id  = _downloadAlbumInfo.album_id;
    }
   
    
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
            
            [weakSelf btnSelectAllAction:nil];
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

#pragma mark - buttonAction

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
    
    if (weakSelf.type == 0) {
        
       [self.childSelectView setUpLabels:_mediaCount WithIndex:_page_album];
        
    }else{
        
        if (_albumInfo) {
            
            [self.childSelectView setUpLabels:[_albumInfo.number integerValue] WithIndex:_page_album-1];
            
        }else if (_downloadAlbumInfo){
            
            [self.childSelectView setUpLabels:[_downloadAlbumInfo.download_count integerValue] WithIndex:_page_album-1];
        }
        
    }
    
    self.childSelectView.block_tag = ^(NSInteger index){
        
        weakSelf.page_album = index;
        [weakSelf.btn_selected setTitle:[NSString stringWithFormat:@"选集(%ld~%ld)",(weakSelf.page_album-1)*20+1,_page_album*20 > weakSelf.mediaCount ? weakSelf.mediaCount: weakSelf.page_album*20] forState:UIControlStateNormal];
        
        [weakSelf.arr_selectedData removeAllObjects];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFCATION_SHOWDOWNLOAD" object:nil userInfo:nil];
        
        if (weakSelf.type == 0) {
            
            if (weakSelf.downloadAlbumInfo) {
                
                if (_downloadAlbumInfo.source == 100) {
                    
                    _isXimaAlbum = YES;
                    [weakSelf loadXimalayaAlbum];
                    
                }else{
                    
                    _isXimaAlbum = NO;
                    [weakSelf loadAlbumMedia];
                    
                }
                
            }else if(weakSelf.album_xima){
                
                 _isXimaAlbum = YES;
                 [weakSelf loadXimalayaAlbum];
                
            }else{
                
                _isXimaAlbum = NO;
                [weakSelf loadAlbumMedia];
            }
            
        }else{
            
            if (weakSelf.albumInfo) {
                
                [weakSelf loadAlbumMedia];
                
            }else if (weakSelf.downloadAlbumInfo){
                
                weakSelf.isReload = YES;
                [weakSelf loadDownloadAlbumInfo];
                
            }
            
        }
        
        [weakSelf.childSelectView hide];
        
    };
    
    [self.childSelectView show];
    
}

- (IBAction)btnSelectAllAction:(id)sender {
    UIButton *t_btn = (UIButton *)sender;

    if (!sender) {
        t_btn = _btn_selectedAll;
        t_btn.selected = NO;
    }
    t_btn.selected = !t_btn.selected;
    
    if (t_btn.selected) {
        
        if ([_arr_selectedData count] > 0) {
            [_arr_selectedData removeAllObjects];
            [_tb_content reloadData];
        }
        
        if (_arr_currentData) {
            
            if (_type == 0) {
                
                for (int i = 0; i < [_arr_currentData count]; i++) {
                    
                    NSMutableDictionary *t_dic = _arr_currentData[i];
                    MediaDownloadStatus *downloadStatus = [t_dic objectForKey:@"MediaDownloadStatus"];
                    if ([downloadStatus.download isEqualToNumber:@0]) {
                        
                        [_arr_selectedData addObject:t_dic];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFCATION_SHOWDOWNLOAD" object:nil userInfo:nil];
                    }
                    
                }
                
            }else{
                
                for (int i = 0; i < [_arr_currentData count]; i++) {
                   
                    if (_downloadAlbumInfo) {
                        
                        DownloadMediaInfo *downloadMediaInfo = _arr_currentData[i];
                        
                        if ([downloadMediaInfo.download isEqualToNumber:@1]) {
                            
                            AlbumMedia *albumMedia = [[AlbumMedia alloc] init];
                            albumMedia.media_id = downloadMediaInfo.media_id;
                            albumMedia.media_type = downloadMediaInfo.media_type;
                            albumMedia.download = downloadMediaInfo.download;
                            albumMedia.duration = downloadMediaInfo.duration;
                            albumMedia.url = downloadMediaInfo.url;
                            albumMedia.icon = downloadMediaInfo.icon;
                            albumMedia.name = downloadMediaInfo.name;
                            [_arr_selectedData addObject:albumMedia];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFCATION_SHOWDOWNLOAD" object:nil userInfo:nil];
                        }
                        
                    }else{
                        
                        AlbumMedia *albumMedia = _arr_currentData[i];
                        [_arr_selectedData addObject:albumMedia];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFCATION_SHOWDOWNLOAD" object:nil userInfo:nil];
                        
                    }
                    
                }
                
            }
            
            [_tb_content reloadData];
        }
        
    }else{
    
        if ([_arr_selectedData count] > 0) {
            [_arr_selectedData removeAllObjects];
            [_tb_content reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFCATION_SHOWDOWNLOAD" object:nil userInfo:nil];
        }
        
        
    }
    
}

- (IBAction)btnDownAction:(id)sender {
    __weak typeof(self) weakself = self;
    if (_downloadMediaCount > 10 && _type == 0) {
        [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"玩具正在下载的资源过多，全部完成需要一定的时间，是否确定继续添加资源？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex) {
                [weakself downloadMedias];
            }
        }];
    }else{
        [weakself downloadMedias];
    }
}

-(void)downloadMedias{
    NSMutableArray *t_arr = [NSMutableArray array];
    if (_type == 0) {
        if (_isXimaAlbum) {
            for (NSMutableDictionary *t_dic in _arr_selectedData) {
                
                XMTrack *track = [t_dic objectForKey:@"Track"];
                ND3RDMedia *t_3rdMedia = [[ND3RDMedia alloc] init];
                t_3rdMedia.third_mid = @(track.trackId);
                t_3rdMedia.media_title = track.trackTitle;
                t_3rdMedia.media_icon  = track.coverUrlSmall;
                t_3rdMedia.media_url   = track.playUrl32;
                [t_arr addObject:t_3rdMedia];
                
            }
            
            __weak typeof(self) weakSelf = self;
            
            ND3rdMediaDownloadAlbumParams *params = [[ND3rdMediaDownloadAlbumParams alloc] init];
            params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
            params.source = @100;
            if (_album_xima) {
                params.third_aid = @(_album_xima.albumId);
                params.album_icon = _album_xima.coverUrlSmall;
                params.album_title = _album_xima.albumTitle;
            }else if (_downloadAlbumInfo){
                params.third_aid = _downloadAlbumInfo.third_aid;
                params.album_icon = _downloadAlbumInfo.icon;
                params.album_title = _downloadAlbumInfo.name;
                
            }
            params.media_list = t_arr;
            
            [ND3rdMediaAPI thirdMediaDownloadAlbumWithParams:params completionBlockWithSuccess:^(NSArray *data){
                _downloadMediaCount += t_arr.count;
                if (data) {
                    
                    for (NSMutableDictionary *t_dic in _arr_currentData) {
                        
                        MediaDownloadStatus *t_downloadStatus = [t_dic objectForKey:@"MediaDownloadStatus"];
                        for(MediaDownloadStatus *downloadStatus in data){
                            
                            if ([downloadStatus.third_mid isEqualToNumber:t_downloadStatus.third_mid]) {
                                [t_dic setObject:downloadStatus forKey:@"MediaDownloadStatus"];
                                break;
                            }
                            
                        }
                    }
                    
                    if ([_arr_selectedData count] > 0) {
                        [_arr_selectedData removeAllObjects];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFCATION_SHOWDOWNLOAD" object:nil userInfo:nil];
                    }
                    
                    [weakSelf.tb_content reloadData];
                    
                    if (_album_xima) {
                        NSMutableDictionary *dictMail = [NSMutableDictionary dictionary];
                        [dictMail setValue:data forKey:@"downloadStatusArr"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFCATION_DOWNLOADSTATUSARR object:nil userInfo:dictMail];
                    }else if (_downloadAlbumInfo){
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFCATION_DOWNLOADSTATUSARR object:nil userInfo:nil];
                    }
                    
                    if ([ShareValue sharedShareValue].cur_toyState == ToyStateMusicState || [ShareValue sharedShareValue].cur_toyState == ToyStateStoryState) {
                        NSString *desc = [ShareValue sharedShareValue].cur_toyState == ToyStateMusicState?@"悟小空唱歌哦，是否让马上下载？":@"悟小空讲故事哦，是否马上下载？";
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"忽略", nil];
                        alert.tag = 11;
                        [alert show];
                    }else{
                        [ShowHUD showSuccess:NSLocalizedString(@"已添加到玩具下载队列", nil) configParameter:^(ShowHUD *config) {
                        } duration:2.0f inView:ApplicationDelegate.window];
                    }
                    
                    
                }
                
            } Fail:^(int code, NSString *failDescript) {
                
                [ShowHUD showError:@"下载失败" configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:weakSelf.view];
                
            }];
            
        }else{
            
            __weak __typeof(self) weakSelf = self;
            
            NSMutableArray *ids = [NSMutableArray array];
            for (NSMutableDictionary *t_dic in _arr_selectedData) {
                
                AlbumMedia *albumMedia = [t_dic objectForKey:@"AlbumMedia"];
                [ids addObject:albumMedia.media_id];
                
            }
            
            NDToyAlbumDownloadParams *params = [[NDToyAlbumDownloadParams alloc]init];
            
            params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
            params.medialist = [ids componentsJoinedByString:@","];
            
            if (_albumInfo) {
                params.album_id  = _albumInfo.album_id;
            }else if (_downloadAlbumInfo){
                params.album_id  = _downloadAlbumInfo.album_id;
            }
            
            [NDToyAPI toyAlbumDownloadWithParams:params completionBlockWithSuccess:^{
                _downloadMediaCount += ids.count;
                [weakSelf loadAlbumMedia];
                
                if ([_arr_selectedData count] > 0) {
                    [_arr_selectedData removeAllObjects];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFCATION_SHOWDOWNLOAD" object:nil userInfo:nil];
                }
                
                [weakSelf.tb_content reloadData];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFCATION_DOWNLOADSTATUSARR object:nil userInfo:nil];
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
                } duration:1.5f inView:weakSelf.view];
                
                
            }];
            
        }
        
    }else{
        
        
        NDToyChangeAlbumParams *params = [[NDToyChangeAlbumParams alloc] init];
        params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
        if (_downloadAlbumInfo) {
            params.album_id = self.downloadAlbumInfo.album_id;
            params.album_type = self.downloadAlbumInfo.album_type;
        }else{
            params.album_id = self.albumInfo.album_id;
            params.album_type = self.albumInfo.album_type;
        }

        
        //params.album_type =@0;
        params.medialist = [self gainMediaList:_arr_selectedData];
        
        _hud = [ShowHUD showText:NSLocalizedString(@"切换中...", nil) configParameter:^(ShowHUD *config) {
        } inView:self.view];
        
        [NDToyAPI toyChangeAlbumWithParams:params completionBlockWithSuccess:^{
            
            if (_hud)  [_hud hide];
            
            [ShowHUD showSuccess:NSLocalizedString(@"切换成功", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
            
        } Fail:^(int code, NSString *failDescript) {
            
            if (_hud)  [_hud hide];
            
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
            
        }];
        
        
    }
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


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    ChildMediaBatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildMediaBatCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ChildMediaBatCell" bundle:nil] forCellReuseIdentifier:@"ChildMediaBatCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChildMediaBatCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_type == 0) {
        
        
        NSMutableDictionary *t_dic = _arr_currentData[indexPath.row];
        XMTrack *track = [t_dic objectForKey:@"Track"];
        AlbumMedia *albumMedia = [t_dic objectForKey:@"AlbumMedia"];
        MediaDownloadStatus *downloadStatus = [t_dic objectForKey:@"MediaDownloadStatus"];
        
        
        if (track) {
            cell.album_xima = track;
        }
        
        if (albumMedia) {
            cell.albumMedia =  albumMedia;
        }
        
        if (downloadStatus) {
            
            cell.downloadStatus = downloadStatus;
        }
        
        cell.block_bat = ^(ChildMediaBatCell *cell,BOOL isSelected){
            
            if (isSelected) {
                
                 NSMutableDictionary *t_dic = [NSMutableDictionary new];
                if (weakSelf.isXimaAlbum) {
                    [t_dic setObject:cell.album_xima forKey:@"Track"];
                }else{
                    [t_dic setObject:cell.albumMedia forKey:@"AlbumMedia"];
                }
                [t_dic setObject:cell.downloadStatus forKey:@"MediaDownloadStatus"];
               
                [weakSelf.arr_selectedData addObject:t_dic];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFCATION_SHOWDOWNLOAD" object:nil userInfo:nil];
                
            }else{
                
                for (NSMutableDictionary *t_dic in weakSelf.arr_selectedData) {
                    
                    if (weakSelf.isXimaAlbum) {
                        
                        XMTrack *track = [t_dic objectForKey:@"Track"];
                        
                        if (track.trackId == cell.album_xima.trackId) {
                            
                            [weakSelf.arr_selectedData removeObject:t_dic];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFCATION_SHOWDOWNLOAD" object:nil userInfo:nil];
                            break;
                        }

                    }else{
                        
                        AlbumMedia *albumMedia = [t_dic objectForKey:@"AlbumMedia"];
                        if (albumMedia.media_id == cell.albumMedia.media_id) {
                            
                            [_arr_selectedData removeObject:t_dic];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFCATION_SHOWDOWNLOAD" object:nil userInfo:nil];
                            break;
                        }

                    }
                }
                
            }
        };

        for(int i = 0; i < [_arr_selectedData count] ; i++){
            
            NSMutableDictionary *t_diction = _arr_selectedData[i];
            if (_isXimaAlbum) {
                
                XMTrack *track_t = [t_diction objectForKey:@"Track"];
                
                if (track_t.trackId == track.trackId) {
                    
                    cell.isSelected = YES;
                    
                    break;
                }
                
                if (i == [_arr_selectedData count]-1) {
                    
                    cell.isSelected = NO;
                    
                }
                
            }else{
                
                AlbumMedia *albumMedia_t = [t_diction objectForKey:@"AlbumMedia"];
                if (albumMedia_t.media_id == albumMedia.media_id) {
                    cell.isSelected = YES;
                    break;
                }
                
                if (i == [_arr_selectedData count]-1) {
                    cell.isSelected = NO;
                }
            
            }
            
        }
        
        if ([_arr_selectedData count] == 0) {
            cell.isSelected = NO;
        }
    
    }else{
        
        AlbumMedia *t_albumMedia;
        
        if (_downloadAlbumInfo) {
            
            DownloadMediaInfo *downloadMediaInfo = _arr_currentData[indexPath.row];
            
            AlbumMedia *albumMedia = [[AlbumMedia alloc] init];
            albumMedia.media_id = downloadMediaInfo.media_id;
            albumMedia.media_type = downloadMediaInfo.media_type;
            albumMedia.download = downloadMediaInfo.download;
            albumMedia.duration = downloadMediaInfo.duration;
            albumMedia.url = downloadMediaInfo.url;
            albumMedia.icon = downloadMediaInfo.icon;
            albumMedia.name = downloadMediaInfo.name;
            
            t_albumMedia = albumMedia;
            
        }else{
            t_albumMedia = _arr_currentData[indexPath.row];
        }
        
        
        cell.albumMedia = t_albumMedia;
    
        
        
        cell.block_bat = ^(ChildMediaBatCell *cell,BOOL isSelected){
            
            if (isSelected) {
                
                [weakSelf.arr_selectedData addObject:cell.albumMedia];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFCATION_SHOWDOWNLOAD" object:nil userInfo:nil];
                
            }else{
                
                for (AlbumMedia *albumMedia in _arr_selectedData) {
                    
                    if (albumMedia.media_id == cell.albumMedia.media_id) {
                        [weakSelf.arr_selectedData removeObject:albumMedia];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFCATION_SHOWDOWNLOAD" object:nil userInfo:nil];
                        break;
                    }
                    
                }
                
            }
        };

        for(int i = 0; i < [_arr_selectedData count] ; i++){
            
            AlbumMedia *t_albumMedia = _arr_selectedData[i];
            if (t_albumMedia.media_id == cell.albumMedia.media_id) {
                cell.isSelected = YES;
                break;
            }
            
            if (i == [_arr_selectedData count]-1) {
                cell.isSelected = NO;
            }
            
        }
        
        if ([_arr_selectedData count] == 0) {
            cell.isSelected = NO;
        }

        
        
    }
    

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
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

    NSLog(@"ChildMediaBatVC dealloc");
     [[NSNotificationCenter defaultCenter] removeObserver:self];

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
