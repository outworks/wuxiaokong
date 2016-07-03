//
//  DownloadedVC.m
//  HelloToy
//
//  Created by ilikeido on 16/4/29.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "PortDownloadedVC.h"
#import "UIScrollView+PullTORefresh.h"
#import "NDToyAPI.h"
#import "NDMediaAPI.h"
#import "ChildAlbumListCell.h"
#import "ChildCommonCell.h"
#import "DownloadAlbumVC.h"
#import "DownloadMedioVC.h"
#import "DownloadingVC.h"
#import "ChildAlbumDetailVC.h"
#import "ChildMusicVC.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ShowHUD.h"
#import "BlocksKit+UIKit.h"
#import "DownloadedVC.h"

@interface PortDownloadedVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,strong) NSMutableArray *ablumDatas;
@property(nonatomic,strong) NSMutableArray *downloadedDatas;
@property(nonatomic,strong) NSMutableArray *downloadingDatas;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *head_ablum;

@property (strong, nonatomic) IBOutlet UIView *headDownloaded;
@property (strong, nonatomic) IBOutlet UIView *head_downing;
@property(nonatomic,strong) ShowHUD *hud;
@property (nonatomic,strong) NSNumber *playMediaId;

@end

@implementation PortDownloadedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"玩具下载";
    [self initData];
    [self initUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(toyChange:) name:NOTIFICATION_TOYRELOAD object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView triggerPullScrolling];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)initUI{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPlayDown:) name:@"播放完刷新" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPlayDown:) name:@"刷新下载SB列表" object:nil];
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];

    __weak typeof(self) weakself = self;
    [self.tableView addPullScrollingWithActionHandler:^{
        [weakself reloadData];
    }];
    
}

-(void)initData{
    _ablumDatas = [[NSMutableArray alloc]init];
    _downloadedDatas = [[NSMutableArray alloc]init];
    _downloadingDatas = [[NSMutableArray alloc]init];
}

-(void)toyChange:(NSNotification *)notification{
    [self reloadData];
}

-(void)reloadData{
    __weak typeof(self) weakSelf = self;
    
    GCDGroup *group = [GCDGroup new];
    
    [[GCDQueue globalQueue] execute:^{
        
        [weakSelf requestDownloadedAblum];
        
    } inGroup:group];
    
    [[GCDQueue globalQueue] execute:^{
        
        [weakSelf requestDownloadMedia];
    } inGroup:group];
    
    [[GCDQueue globalQueue] execute:^{
        
        [weakSelf requestDownloadingMedia];
    } inGroup:group];
    
    [[GCDQueue mainQueue] notify:^{
        weakSelf.tableView.emptyDataSetSource = self;
        weakSelf.tableView.emptyDataSetDelegate = self;
        [weakSelf.tableView.pullScrollingView stopAnimating];
        if (_hud) {
            [_hud hide];
        }
        [weakSelf.tableView reloadData];
    } inGroup:group];
    
}


- (void)requestDownloadedAblum{
    __weak typeof(self) weakSelf = self;
    GCDSemaphore *semaphore = [GCDSemaphore new];
    NDToyQueryDownloadAlbumParams *params = [[NDToyQueryDownloadAlbumParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    [NDToyAPI toyQueryDownloadAlbumWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        [semaphore signal];
        if (_ablumDatas.count > 0) {
            [_ablumDatas removeAllObjects];
        }
        NSInteger count = MIN(data.count, 5) ;
        [_ablumDatas addObjectsFromArray:[data subarrayWithRange:NSMakeRange(0, count)]];
        NSIndexSet  *set = [[NSIndexSet alloc]initWithIndex:0];
        [weakSelf.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];

    } Fail:^(int code, NSString *failDescript) {
        [semaphore signal];
    }];
    [semaphore wait];
}

- (void)requestDownloadMedia{
    __weak typeof(self) weakSelf = self;
    GCDSemaphore *semaphore = [GCDSemaphore new];
    NDMediaQueryDownloadParams *params = [[NDMediaQueryDownloadParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.download = 1;
    params.rows = 3;
    [NDMediaAPI queryDownloadWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        [semaphore signal];
        if (_downloadedDatas.count > 0) {
            [_downloadedDatas removeAllObjects];
        }
        NSInteger count = MIN(data.count, 5) ;
        [_downloadedDatas addObjectsFromArray:[data subarrayWithRange:NSMakeRange(0, count)]];
        NSIndexSet  *set = [[NSIndexSet alloc]initWithIndex:1];
        [weakSelf.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    } Fail:^(int code, NSString *failDescript) {
        [semaphore signal];
    }];
    [semaphore wait];
}

- (void)requestDownloadingMedia{
    
    __weak typeof(self) weakSelf = self;
    GCDSemaphore *semaphore = [GCDSemaphore new];
    NDMediaQueryDownloadParams *params = [[NDMediaQueryDownloadParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.download = 2;
    params.rows = 3;
    [NDMediaAPI queryDownloadWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        [semaphore signal];
        if (_downloadingDatas.count > 0) {
            [_downloadingDatas removeAllObjects];
        }
        NSInteger count = MIN(data.count, 5) ;
        [_downloadingDatas addObjectsFromArray:[data subarrayWithRange:NSMakeRange(0, count)]];
        NSIndexSet  *set = [[NSIndexSet alloc]initWithIndex:2];
        [weakSelf.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];

    } Fail:^(int code, NSString *failDescript) {
        [semaphore signal];
    }];
    [semaphore wait];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loadMoreAblums:(id)sender {
    
    DownloadedVC *vc = [[DownloadedVC alloc]init];
//    vc.title = @"专辑";
    id target = self.view;
    
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[ChildMusicVC class]]) {
            break;
        }
    }
    
    vc.index = 0;
    ChildMusicVC *vc_target = (ChildMusicVC *)target;
    
    [vc_target.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)loadMoreDownloaded:(id)sender {
    
    DownloadedVC *vc = [[DownloadedVC alloc]init];
//    vc.title = @"声音";
    id target = self.view;
    
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[ChildMusicVC class]]) {
            break;
        }
    }
    vc.index = 1;
    ChildMusicVC *vc_target = (ChildMusicVC *)target;
    
    [vc_target.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loadMoreDownloading:(id)sender {
    
//    DownloadingVC *vc = [[DownloadingVC alloc]init];
    DownloadedVC *vc = [[DownloadedVC alloc]init];
    vc.title = @"下载中...";
    id target = self.view;
    
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[ChildMusicVC class]]) {
            break;
        }
    }
    vc.index = 2;
    ChildMusicVC *vc_target = (ChildMusicVC *)target;
    
    [vc_target.navigationController pushViewController:vc animated:YES];
}




#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if(_ablumDatas.count > 0){
            return 40.0;
        }
    }else if(section == 1){
        if(_downloadedDatas.count > 0){
            return 40.0;
        }
    }else if ( section == 2){
        if(_downloadingDatas.count > 0){
            return 40.0;
        }
    }
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     ChildCommonCell *cell = (ChildCommonCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        DownloadAlbumInfo *album = _ablumDatas[indexPath.row];
        ChildAlbumDetailVC *t_vc = [[ChildAlbumDetailVC alloc] init];
        t_vc.downloadAlbumInfo = album;
        
        id target = self.view;
        
        while (target) {
            target = ((UIResponder *)target).nextResponder;
            if ([target isKindOfClass:[ChildMusicVC class]]) {
                break;
            }
        }
        
        ChildMusicVC *vc_target = (ChildMusicVC *)target;
        
        [vc_target.navigationController pushViewController:t_vc animated:YES];
    
    }else{
        AlbumMedia *albumMedia;
        
        if (indexPath.section == 1){
            albumMedia = _downloadedDatas[indexPath.row];
            
            if ([cell.playMediaId isEqual:albumMedia.media_id] && cell.isPlay) {
                [cell btnTryListen:_playMediaId WithUrl:albumMedia.url];
                _playMediaId = nil;
                return;
            }
            if (![ShareValue sharedShareValue].toyDetail) {
                [cell btnTryListen:_playMediaId WithUrl:albumMedia.url];
                _playMediaId = albumMedia.media_id;
                return;
            }
            
            
            UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:@"请选择"];
            [sheet bk_addButtonWithTitle:@"手机播放" handler:^{
                
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
                
                
            }];
            
            [sheet bk_addButtonWithTitle:@"玩具播放" handler:^{
                NDToyPlayMediaParams *params = [[NDToyPlayMediaParams alloc]init];
                params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
                params.media_id = albumMedia.media_id;
                
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
            
        }else{
            
            albumMedia = _downloadingDatas[indexPath.row];
            
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return _head_ablum;
    } else if (section == 1) {
        return _headDownloaded;
    }else{
        return _head_downing;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _ablumDatas.count;
    } else if (section == 1) {
        return _downloadedDatas.count;
    }else{
        return _downloadingDatas.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 75.0;
    }
    return 60.0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        ChildAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildAlbumListCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"ChildAlbumListCell" bundle:nil] forCellReuseIdentifier:@"ChildAlbumListCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChildAlbumListCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        DownloadAlbumInfo *album = _ablumDatas[indexPath.row];
        cell.downloadAlbumInfo = album;
        return cell;
    }else{
        
        ChildCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCommonCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"ChildCommonCell" bundle:nil] forCellReuseIdentifier:@"ChildCommonCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCommonCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
       if (indexPath.section == 1){
           cell.albumMedia = _downloadedDatas[indexPath.row];
       }else{
           cell.albumMedia = _downloadingDatas[indexPath.row];
       }
        
        
        [cell setPlayMediaId:_playMediaId];
        
        return cell;
        
        
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


#pragma mark -
#pragma mark 通知事件

- (void)reloadPlayDown:(NSNotification *)note{
    
    _playMediaId = nil;
    [self.tableView reloadData];
}



#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"未找到数据";
    
    if (![ShareValue sharedShareValue].toyDetail.toy_id) {
        text = @"请先绑定玩具";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
//
//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
//{
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
//                                 NSForegroundColorAttributeName: [UIColor blueColor]};
//    
//    return [[NSAttributedString alloc] initWithString:@"点击重新加载" attributes:attributes];
//}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    _hud = [ShowHUD showText:@"加载中..." configParameter:^(ShowHUD *config) {
        
    } inView:self.view];
    [_tableView reloadData];
    [self reloadData];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
//{
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
//    
//    return [[NSAttributedString alloc] initWithString:@"重试" attributes:attributes];
//}

@end
