//
//  DownloadAlbumVC.m
//  HelloToy
//
//  Created by ilikeido on 16/4/29.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "DownloadAlbumVC.h"
#import "ChildAlbumListCell.h"
#import "IQKeyboardManager.h"
#import "UIScrollView+PullTORefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "NDAlarmAPI.h"
#import "NDToyAPI.h"
#import "DownloadAlbumInfo.h"
#import "ChildAlbumDetailVC.h"

@interface DownloadAlbumVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataList;

@property(nonatomic,assign) int page;
@property (weak, nonatomic) IBOutlet UIView *v_info;

@end

@implementation DownloadAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPlayDown:) name:@"刷新下载SB列表" object:nil];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    _page = 1;
    _dataList = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    
    [_tableView addPullScrollingWithActionHandler:^{
        [weakSelf reloadDatas];
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
       [weakSelf loadDownloadAlbum];
    }];
    [_tableView triggerPullScrolling];
    
}

-(void)reloadDatas{
    _page = 1;
    [self loadDownloadAlbum];
}

- (void)reloadPlayDown:(NSNotification *)note{
    
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


/***    请求儿歌专辑列表    ***/

- (void)loadDownloadAlbum{
    __weak DownloadAlbumVC * weakSelf = self;
    NDToyQueryDownloadAlbumParams *params = [[NDToyQueryDownloadAlbumParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.page = weakSelf.page;
    params.rows = 20;
    [NDToyAPI toyQueryDownloadAlbumWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        [weakSelf.tableView.pullScrollingView stopAnimating];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        if (weakSelf.page == 1) {
            [weakSelf.dataList removeAllObjects];
            [weakSelf.tableView.infiniteScrollingView setEnabled:YES];
        }
        if (data.count == 20) {
            weakSelf.page ++;
        }else{
            [weakSelf.tableView.infiniteScrollingView setEnabled:NO];
        }
        [weakSelf.dataList addObjectsFromArray:data];
        [weakSelf.tableView reloadData];
    } Fail:^(int code, NSString *failDescript) {
        [weakSelf.tableView.pullScrollingView stopAnimating];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
    }];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_dataList.count == 0) {
        _v_info.hidden = NO;
    }else{
        _v_info.hidden = YES;
    }
    
    return [_dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 81.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChildAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildAlbumListCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ChildAlbumListCell" bundle:nil] forCellReuseIdentifier:@"ChildAlbumListCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChildAlbumListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DownloadAlbumInfo *album = _dataList[indexPath.row];
    cell.downloadAlbumInfo = album;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DownloadAlbumInfo *album = _dataList[indexPath.row];
    ChildAlbumDetailVC *t_vc = [[ChildAlbumDetailVC alloc] init];
    t_vc.downloadAlbumInfo = album;
    if (self.ownerVC) {
        [self.ownerVC.navigationController pushViewController:t_vc animated:YES];
    }else{
        [self.navigationController pushViewController:t_vc animated:YES];
    }
}





@end
