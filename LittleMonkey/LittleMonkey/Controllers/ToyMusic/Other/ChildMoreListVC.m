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
        _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
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
        
        [weakSelf.mArr_current addObjectsFromArray:data];
        [weakSelf.tb_content reloadData];
        
    } Fail:^(int code, NSString *failDescript) {
        
        [self.tb_content.pullScrollingView stopAnimating];
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
        
    }];
    
    
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
    
        [cell setToyPlay:_mArr_current[indexPath.row]];
    
    }
    
    [cell setPlayMediaId:_playMediaId];
    
    return cell;
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
        
        ToyPlay *toyPlay = _mArr_current[indexPath.row];
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



- (void)updataCollectionNotication:(NSNotification *)note{
    
    if (_moreType == 1) {
        
        _mArr_current = [ShareValue sharedShareValue].mArr_collections;
        
        [_tb_content reloadData];
        
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
