//
//  AlbumListVC.m
//  HelloToy
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "AlbumListVC.h"
#import "NoneInfoView.h"
#import "AlbumInfo.h"

#import "NDFmAPI.h"

#import "ChildAlbumListCell.h"
#import "ChildAlbumDetailVC.h"
#import "TranceiverDetailVC.h"

#import "UIScrollView+SVInfiniteScrolling.h"

@interface AlbumListVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_albumListMuArray;
    MBProgressHUD *_hud;
}

@property (nonatomic, assign) unsigned long page;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NoneInfoView *noneInfoView;
@property (assign,nonatomic) BOOL           isAlbumLastPage;

@end

@implementation AlbumListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
    [self initView];
}

- (void)initData
{
    _albumListMuArray = [NSMutableArray array];
    _isAlbumLastPage = NO;
    _page = 1;
    //请求数据
    
    if (_typeList == 0) {
        [self getRecommendRequest];
    }else{
        
        if (NSStringIsValid(_tagName)) {
            [self getTagAlbumRequest:_tagName];
        } else {
            [self getHotAlbumRequest];
        }
    
    }
    
   
}

- (void)initView
{
    if (_typeList == 0) {
        self.title = @"电台";
    }else{
        
        self.title = NSStringIsValid(_tagName) ? _tagName : NSLocalizedString(@"热门专辑", nil);
    }

    
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        if (_typeList == 0) {
            [weakSelf getRecommendRequest];
        }else{
            
            if (NSStringIsValid(_tagName)) {
                [weakSelf getTagAlbumRequest:_tagName];
            } else {
                [weakSelf getHotAlbumRequest];
            }
            
        }
    }];

}

#pragma mark - APIS


//推荐电台
- (void)getRecommendRequest
{
    __weak typeof(self) weakself = self;
    
    if (_page == 1) {
        _tableView.showsInfiniteScrolling = NO;
    }else{
        _tableView.showsInfiniteScrolling = !_isAlbumLastPage;
    }

    NDFmRecommendParams *params = [[NDFmRecommendParams alloc]init];
    params.page = @(self.page);
    params.rows = @20;
    [NDFmAPI fmRecommendWithParams:params CompletionBlockWithSuccess:^(NDFmRecommendResult *data) {
        int count = data.count.intValue;
        [weakself reloadDataByUI:data.fms andCount:count];
        
        
    } Fail:^(int code, NSString *failDescript) {
        
        [_hud removeFromSuperview];
        _hud = nil;
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.0f inView:self.view];
        
    }];
    
}


//根据标签查询专辑
- (void)getTagAlbumRequest:(NSString *)tagString
{
    if (_page == 1) {
        _tableView.showsInfiniteScrolling = NO;
    }else{
        _tableView.showsInfiniteScrolling = !_isAlbumLastPage;
    }
    
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = NSLocalizedString(@"请求中...", nil);
    [self.view addSubview:_hud];
    [_hud show:YES];
    
    NDFmTagAlbumParams *params = [[NDFmTagAlbumParams alloc]init];
    params.tag = tagString;
    params.page = @(self.page);
    params.rows = @20;
    [NDFmAPI fmTagAlbumWithParams:params CompletionBlockWithSuccess:^(NDFmTagAlbumResult *data) {
        int count = data.count.intValue;
        [self reloadDataByUI:data.albums andCount:count];
    } Fail:^(int code, NSString *failDescript) {
        [_hud removeFromSuperview];
        _hud = nil;
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.0f inView:self.view];
    }];
}

//更多专辑
- (void)getHotAlbumRequest
{
    if (_page == 1) {
        _tableView.showsInfiniteScrolling = NO;
    }else{
        _tableView.showsInfiniteScrolling = !_isAlbumLastPage;
    }
    
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = NSLocalizedString(@"请求中...", nil);
    [self.view addSubview:_hud];
    [_hud show:YES];
    
    NDFmHotAlbumParams *params = [[NDFmHotAlbumParams alloc]init];
    params.page = @(self.page);
    params.rows = @20;
    [NDFmAPI fmHotAlbumWithParams:params CompletionBlockWithSuccess:^(NDFmHotAlbumResult *data) {
        int count = data.count.intValue;
        
        [self reloadDataByUI:data.albums andCount:count];
        
        
    } Fail:^(int code, NSString *failDescript) {
        [_hud removeFromSuperview];
        _hud = nil;
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.0f inView:self.view];
    }];
}

#pragma mark - Fuctions

//添加数据并刷新UI
- (void)reloadDataByUI:(NSArray *)dataArray andCount:(int)count
{
    [_hud removeFromSuperview];
    _hud = nil;
    [self.tableView.infiniteScrollingView stopAnimating];
    
    if (self.page == 1) {
        [_albumListMuArray removeAllObjects];
    }
    
    
    [_albumListMuArray addObjectsFromArray:dataArray];
    
    if (count < 20) {
        
        self.isAlbumLastPage = YES;
        
    }
    
    self.tableView.showsInfiniteScrolling = !self.isAlbumLastPage;
    
    [self.tableView reloadData];
    
    self.page++;
    
}

- (void)addNonInfoView
{
    _noneInfoView = [[[NSBundle mainBundle] loadNibNamed:@"DataNetWorkSuperView" owner:nil options:nil] lastObject];
    _noneInfoView.frame = CGRectMake(0, 0, ViewWidth(self.view), ViewHeight(self.view));
    _noneInfoView.btnReload.hidden = YES;
    _noneInfoView.lbTitle.text = NSLocalizedString(@"没有找到相关内容~", nil);
    [self.view addSubview:_noneInfoView];
    
}

- (void)removeNonInfoView
{
    for(UIView *view in self.view.subviews){
        if ([view isKindOfClass:[DataNetWorkSuperView class]]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_albumListMuArray.count > 0) {
        
        [self removeNonInfoView];
        
    }else{
    
        [self addNonInfoView];
    }
    
    return _albumListMuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChildAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildAlbumListCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ChildAlbumListCell" bundle:nil] forCellReuseIdentifier:@"ChildAlbumListCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChildAlbumListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_typeList == 0) {
        
        FM *fm = _albumListMuArray[indexPath.row];
        
        [cell setFm:fm];
        
    }else{
        AlbumInfo *t_albumInfo = _albumListMuArray[indexPath.row];
        [cell setAlbumInfo:t_albumInfo];

    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 75.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_typeList == 0) {
        
        FM *fm = _albumListMuArray[indexPath.row];
        
        TranceiverDetailVC *detailVC = [[TranceiverDetailVC alloc] init];
        detailVC.fm = fm;
        
        [self.navigationController pushViewController:detailVC animated:YES];

        
    }else{
        
        ChildAlbumDetailVC *t_childAlbumDetail = [[ChildAlbumDetailVC alloc] init];
        t_childAlbumDetail.albumInfo = _albumListMuArray[indexPath.row];
        
        [self.navigationController pushViewController:t_childAlbumDetail animated:YES];
    }

    
   
}


#pragma mark

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
