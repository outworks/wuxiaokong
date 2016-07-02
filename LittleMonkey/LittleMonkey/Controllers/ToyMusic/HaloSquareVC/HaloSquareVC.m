//
//  HaloSquareVC.m
//  HelloToy
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "HaloSquareVC.h"
#import "HaloSquareCell.h"
#import "HaloSquareRecommendCell.h"
#import "AlbumInfo.h"
#import "Fm.h"

#import "AlbumListVC.h"
#import "TranceiverDetailVC.h"
#import "NoNetWorkView.h"
#import "ChildMusicVC.h"
#import "ChildAlbumDetailVC.h"

#import "UIScrollView+PullTORefresh.h"
#import "NDFmAPI.h"

#import "KDCycleBannerView.h"


@interface HaloSquareVC ()<UITableViewDataSource,UITableViewDelegate,HaloSquareCellDelegate, KDCycleBannerViewDataource, KDCycleBannerViewDelegate, HaloSquareRecommendCellDelegate,DataNetWorkSuperViewDelegate>
{
    NSArray *_typeNameArray;
    NSDictionary *_typeDictionary;
    NSMutableArray *_showScrollMuarray;
    NSMutableArray *_hotAlbumMuArray;
    NSMutableArray *_recommendFMMuArray;
    MBProgressHUD *_hud;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) KDCycleBannerView *cycleBannerView;
@property (strong, nonatomic) IBOutlet UIView *vTableSectionHeader;
@property (strong, nonatomic) NoNetWorkView *noNetWorkView;

@end

@implementation HaloSquareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
    [self initView];
}

- (void)initView
{
    __weak typeof(self) weakself = self;
    [self.tableView addPullScrollingWithActionHandler:^{
        [weakself loadDatasInView];
    }];
    [self loadDatasInView];
}

- (void)initData
{
    _hotAlbumMuArray = [NSMutableArray array];
    _recommendFMMuArray = [NSMutableArray array];
    _typeNameArray = @[NSLocalizedString(@"成长", nil),NSLocalizedString(@"学本领", nil),NSLocalizedString(@"场景", nil),NSLocalizedString(@"主题", nil),NSLocalizedString(@"风格", nil)];
    _typeDictionary = @{
                        NSLocalizedString(@"成长", nil):@[NSLocalizedString(@"0-2岁", nil),NSLocalizedString(@"3-4岁", nil),NSLocalizedString(@"5-6岁", nil),NSLocalizedString(@"习惯", nil),NSLocalizedString(@"行为", nil),NSLocalizedString(@"道德", nil)],
                        NSLocalizedString(@"学本领",nil):@[NSLocalizedString(@"学成语", nil),NSLocalizedString(@"学拼音", nil),NSLocalizedString(@"学数数", nil),NSLocalizedString(@"学古诗", nil),NSLocalizedString(@"三字经", nil),NSLocalizedString(@"学英语", nil)],
                        NSLocalizedString(@"场景", nil):@[NSLocalizedString(@"睡前", nil),NSLocalizedString(@"学习", nil),NSLocalizedString(@"跳舞", nil),NSLocalizedString(@"运动", nil),NSLocalizedString(@"玩耍", nil),NSLocalizedString(@"朗诵", nil)],
                        NSLocalizedString(@"主题", nil):@[NSLocalizedString(@"寓言", nil),NSLocalizedString(@"童话", nil),NSLocalizedString(@"民间", nil),NSLocalizedString(@"成语", nil),NSLocalizedString(@"读物", nil),NSLocalizedString(@"笑话", nil)],
                        NSLocalizedString(@"风格", nil):@[NSLocalizedString(@"经典", nil),NSLocalizedString(@"影视", nil),NSLocalizedString(@"时节", nil),NSLocalizedString(@"欢快", nil),NSLocalizedString(@"抒情", nil),NSLocalizedString(@"放松", nil)]

};
//    //请求数据
//    [self loadDatasInView];
}

#pragma mark - APIS

- (void)loadDatasInView
{
    __weak typeof(self) weakSelf = self;
    
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = NSLocalizedString(@"请求中...", nil);
    [self.view addSubview:_hud];
    [_hud show:YES];
    [weakSelf.tableView setHidden:YES];
    GCDGroup *group = [GCDGroup new];
    
    [[GCDQueue globalQueue] execute:^{
        
        [weakSelf getRecommendAlbumRequest];
        
    } inGroup:group];
    
    [[GCDQueue globalQueue] execute:^{
        
        [weakSelf getHotAlbumRequest];
        
    } inGroup:group];
    
//    [[GCDQueue globalQueue] execute:^{
//        
//        [weakSelf getRecommendRequest];
//        
//    } inGroup:group];
    
    [[GCDQueue mainQueue] notify:^{
        [weakSelf.tableView setHidden:NO];
        [weakSelf.tableView.pullScrollingView stopAnimating];
        [weakSelf reloadBtnState];
        
    } inGroup:group];

}

//热门专辑
- (void)getHotAlbumRequest
{
    GCDSemaphore *semaphore = [GCDSemaphore new];
    __weak typeof(self) weakself = self;
    NDFmHotAlbumParams *params = [[NDFmHotAlbumParams alloc]init];
    [NDFmAPI fmHotAlbumWithParams:params CompletionBlockWithSuccess:^(NDFmHotAlbumResult *data) {
        
        [weakself removeNoNetWorkView];
        
        [_hotAlbumMuArray removeAllObjects];
        [_hotAlbumMuArray addObjectsFromArray:data.albums];
        [semaphore signal];
        
    } Fail:^(int code, NSString *failDescript) {
        
        [self addNoNetWorkView:failDescript];
        
        [semaphore signal];
    }];
    [semaphore wait];
}

//推荐电台
- (void)getRecommendRequest
{
    GCDSemaphore *semaphore = [GCDSemaphore new];
    __weak typeof(self) weakself = self;
    NDFmRecommendParams *params = [[NDFmRecommendParams alloc]init];
    [NDFmAPI fmRecommendWithParams:params CompletionBlockWithSuccess:^(NDFmRecommendResult *data) {
        
        [weakself removeNoNetWorkView];
        [_recommendFMMuArray removeAllObjects];
        
        [_recommendFMMuArray addObjectsFromArray:data.fms];
        [semaphore signal];
        
    } Fail:^(int code, NSString *failDescript) {
        
        [self addNoNetWorkView:failDescript];
        [semaphore signal];
    }];
    [semaphore wait];
}


/********* 推荐专辑[轮播图] **************/

- (void)getRecommendAlbumRequest
{
    GCDSemaphore *semaphore = [GCDSemaphore new];
    __weak typeof(self) weakself = self;
    NDFmRecommendAlbumParams *params = [[NDFmRecommendAlbumParams alloc]init];
    [NDFmAPI fmRecommendAlbumWithParams:params CompletionBlockWithSuccess:^(NDFmRecommendAlbumResult *data) {
        
        [weakself removeNoNetWorkView];
        [weakself resetBannerDatas:data.albums];
        [semaphore signal];
        
    } Fail:^(int code, NSString *failDescript) {
        
        [weakself addNoNetWorkView:failDescript];
        [semaphore signal];
    }];
    [semaphore wait];
}

#pragma mark - Functions

//请求完数据更新UI
- (void)reloadBtnState
{
    [_hud removeFromSuperview];
    _hud = nil;
    [self.tableView reloadData];
    
}

//设置轮播图
- (void)resetBannerDatas:(NSArray *)datas{
    if (datas.count == 0) {
        self.tableView.tableHeaderView = nil;
        [self.tableView reloadData];
        return;
    }
    _showScrollMuarray = [[NSMutableArray alloc]initWithCapacity:3];
    if ([datas count] > 0) {
        if ([datas[0] isKindOfClass:[AlbumInfo class]]) {
            [_showScrollMuarray addObjectsFromArray:datas];
        }
    }
    if (self.cycleBannerView != nil) {
        [self.cycleBannerView removeFromSuperview];
    }
    
    self.cycleBannerView = [[KDCycleBannerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
    CGRect frame = self.cycleBannerView.pageControl.frame ;
    frame.origin.x = ([UIScreen mainScreen].bounds.size.width - (datas.count * 25))/2.0;
    self.cycleBannerView.pageControl.frame = frame;
    self.cycleBannerView.delegate = (id<KDCycleBannerViewDelegate>)self;
    self.cycleBannerView.datasource = (id<KDCycleBannerViewDataource>)self;
    self.cycleBannerView.continuous = YES;
    self.cycleBannerView.autoPlayTimeInterval = 3.f;
    self.tableView.tableHeaderView = self.self.cycleBannerView;
    
    [self.tableView reloadData];
}

- (void)addNoNetWorkView:(NSString *)tipsString
{
    if (_noNetWorkView) {
        return;
    }
    _noNetWorkView = [[[NSBundle mainBundle] loadNibNamed:@"DataNetWorkSuperView" owner:nil options:nil] lastObject];
    _noNetWorkView.frame = CGRectMake(0, 64, ViewWidth(self.view), ViewHeight(self.view) - 64);
    _noNetWorkView.btnReload.hidden = NO;
    _noNetWorkView.delegate = self;
    _noNetWorkView.imageView.image = [UIImage imageNamed:@"icon_wifi"];
    _noNetWorkView.lbTitle.text = tipsString;
    [self.view addSubview:_noNetWorkView];
    
}

- (void)removeNoNetWorkView
{
    for(UIView *view in self.view.subviews){
        if ([view isKindOfClass:[DataNetWorkSuperView class]]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - cycleBannerViewDataource

- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView{
    NSMutableArray *t_arr = [NSMutableArray array];
    for (int i= 0 ; i < _showScrollMuarray.count; i++) {
        AlbumInfo *albumInfo = _showScrollMuarray[i];
        if (NSStringIsValid(albumInfo.icon)) {
            [t_arr addObject:[NSURL URLWithString:albumInfo.icon]];
        }
    }
    if ([t_arr count] == 1) {
        bannerView.continuous = NO;
    }
    
    return t_arr;
}

- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index{
    return UIViewContentModeScaleToFill;
}

- (UIImage *)placeHolderImageOfZeroBannerView{
    return [UIImage imageNamed:@"scrollViewplaceholder"];
}

- (UIImage *)placeHolderImageOfBannerView:(KDCycleBannerView *)bannerView atIndex:(NSUInteger)index
{
    return [UIImage imageNamed:@"scrollViewplaceholder"];
}

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didScrollToIndex:(NSUInteger)index{
}

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index
{
    AlbumInfo *albumInfo = _showScrollMuarray[index];

    ChildAlbumDetailVC *t_childAlbumDetail = [[ChildAlbumDetailVC alloc] init];
    t_childAlbumDetail.albumInfo = albumInfo;
    
    id target = self.view;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[ChildMusicVC class]]) {
            break;
        }
    }
    
    ChildMusicVC *vc_target = (ChildMusicVC *)target;
    
    [vc_target.navigationController pushViewController:t_childAlbumDetail animated:YES];
    
    //[self.navigationController pushViewController:albumDetailVC animated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return _typeNameArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        HaloSquareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HALOSQUARECELL"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"HaloSquareCell" bundle:nil] forCellReuseIdentifier:@"HALOSQUARECELL"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"HALOSQUARECELL"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.vLine.hidden = (indexPath.row == _typeNameArray.count - 1) ? YES : NO;
        [cell resetCellData:_typeNameArray andIndexPath:(int)indexPath.row andData:_typeDictionary];
        
        return cell;

    } else if (indexPath.section == 0){
        
        HaloSquareRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HALOSQUARERECOMMENDCELL"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"HaloSquareRecommendCell" bundle:nil] forCellReuseIdentifier:@"HALOSQUARERECOMMENDCELL"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"HALOSQUARERECOMMENDCELL"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        if (indexPath.row == 0) {
            if (_hotAlbumMuArray.count > 0) {
                [cell resetAlbumCellData:_hotAlbumMuArray];
            }
        }
        return cell;

    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return [HaloSquareCell resetCellHeight];
    } else {
        return [HaloSquareRecommendCell resetCellHeight:_hotAlbumMuArray.count];
//        return [HaloCell resetCellHeight];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return _vTableSectionHeader;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return _vTableSectionHeader.frame.size.height;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - HaloSquareCellDelegate

- (void)buttonClickAction:(UIButton *)button andHaloSquareCell:(HaloSquareCell *)cell andIndexPath:(NSInteger)indexPath
{
    int tag = (int)button.tag - 100;
    NSString *typeString = _typeNameArray[indexPath];
    NSArray *contentArray = [_typeDictionary valueForKey:typeString];
    NSString *contentString = contentArray[tag];
    AlbumListVC *albumListVC = [[AlbumListVC alloc]init];
    albumListVC.tagName = contentString;
    albumListVC.typeList = 1;
    id target = self.view;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[ChildMusicVC class]]) {
            break;
        }
    }
    
    ChildMusicVC *vc_target = (ChildMusicVC *)target;
    
    [vc_target.navigationController pushViewController:albumListVC animated:YES];
    
    //[self.navigationController pushViewController:albumListVC animated:YES];
}

#pragma mark - HaloSquareRecommendCellDelegate

- (void)buttonClickActionByFm:(int )tag  andHaloSquareRecommendCell:(HaloSquareRecommendCell *)cell
{

    FM *fm = _recommendFMMuArray[tag];
    TranceiverDetailVC *detailVC = [[TranceiverDetailVC alloc] init];
    detailVC.fm = fm;
    
    id target = self.view;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[ChildMusicVC class]]) {
            break;
        }
    }
    
    ChildMusicVC *vc_target = (ChildMusicVC *)target;
    
    [vc_target.navigationController pushViewController:detailVC animated:YES];
    //[self.navigationController pushViewController:detailVC animated:YES];
}

- (void)buttonClickActionByHot:(int )tag andHaloSquareRecommendCell:(HaloSquareRecommendCell *)cell
{
    
    AlbumInfo *albumInfo = _hotAlbumMuArray[tag];
   
    ChildAlbumDetailVC *t_childAlbumDetail = [[ChildAlbumDetailVC alloc] init];
    t_childAlbumDetail.albumInfo = albumInfo;
    
    id target = self.view;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[ChildMusicVC class]]) {
            break;
        }
    }
    
    ChildMusicVC *vc_target = (ChildMusicVC *)target;
    
    [vc_target.navigationController pushViewController:t_childAlbumDetail animated:YES];
    //[self.navigationController pushViewController:albumDetailVC animated:YES];
}

- (void)buttonMoreClickAction:(HaloSquareRecommendCell *)cell
{
    AlbumListVC *albumListVC = [[AlbumListVC alloc]init];
    albumListVC.typeList = cell.type;
    
    id target = self.view;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[ChildMusicVC class]]) {
            break;
        }
    }
    
    ChildMusicVC *vc_target = (ChildMusicVC *)target;
    
    [vc_target.navigationController pushViewController:albumListVC animated:YES];
    
    //[self.navigationController pushViewController:albumListVC animated:YES];
}

#pragma mark - DataNetWorkSuperViewDelegate

- (void)onViewReloadDidClicked:(DataNetWorkSuperView *)view
{
    //请求数据
    [self loadDatasInView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
