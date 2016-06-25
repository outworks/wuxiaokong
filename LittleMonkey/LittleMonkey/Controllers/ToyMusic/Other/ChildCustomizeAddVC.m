//
//  ChildCustomizeAddVC.m
//  HelloToy
//
//  Created by huanglurong on 16/6/23.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildCustomizeAddVC.h"
#import "NDMediaAPI.h"

#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+PullTORefresh.h"
#import "PureLayout.h"
#import "UIImageView+WebCache.h"

#import "NDAlbumAPI.h"

@interface ChildCustomizeAddVC ()

@property (weak, nonatomic) IBOutlet UITableView *tabView;

@property (nonatomic,strong) NSMutableArray *marr_data;
@property (nonatomic,strong) NSMutableArray *marr_selectedData;

@property (weak, nonatomic) IBOutlet UIView *v_info;

@property (assign,nonatomic) int            page_album;
@property (assign,nonatomic) BOOL           isAlbumLastPage;
@property (nonatomic,assign) BOOL           isReload;

@end

@implementation ChildCustomizeAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initView];
    [self initData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tabView triggerPullScrolling];
}

#pragma mark - init

- (void)initView{

    self.title = @"添加媒体";
    
    [self showRightBarButtonItemWithTitle:@"完成" target:self action:@selector(AlbumAddAction)];

}

- (void)initData{
    
    __weak typeof(self) weakSelf = self;
    
    self.marr_data = [NSMutableArray array];
    self.marr_selectedData = [NSMutableArray array];

    _page_album = 1;
    
    [_tabView addPullScrollingWithActionHandler:^{
        weakSelf.isReload = YES;
        weakSelf.page_album = 1;
        [weakSelf loadMediaLostRequest];
        
    }];
    
    [_tabView addInfiniteScrollingWithActionHandler:^{
        weakSelf.isReload = NO;
        [weakSelf loadMediaLostRequest];
        
    }];

}


#pragma mark - APIS

- (void)loadMediaLostRequest{
    
    __weak __typeof(self) weakSelf = self;
    
    ShowHUD *showHud = nil;
    if (_page_album == 1) {
        
        showHud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
        } inView:self.view];
        
    }
    
    NDMediaLostParams *params = [[NDMediaLostParams alloc] init];
    params.page = _page_album;
    
    [NDMediaAPI mediaLostWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        
        if (showHud) [showHud hide];
        [weakSelf.tabView.pullScrollingView stopAnimating];
        [weakSelf.tabView.infiniteScrollingView stopAnimating];
        
        if ([data count] < 20) {
            
            weakSelf.isAlbumLastPage = YES;
            
        }else{
            
            weakSelf.isAlbumLastPage = NO;
        }
        
        if (_isReload) {
            [weakSelf.marr_data removeAllObjects];
        }
        
        [weakSelf.marr_data addObjectsFromArray:data];
        
        weakSelf.tabView.showsInfiniteScrolling = !weakSelf.isAlbumLastPage;
        [weakSelf.tabView reloadData];
        
        weakSelf.page_album ++;
        
    } Fail:^(int code, NSString *failDescript) {
        
        if (showHud) [showHud hide];
        
        [weakSelf.tabView.infiniteScrollingView stopAnimating];
        [weakSelf.tabView.pullScrollingView stopAnimating];
        [weakSelf.tabView reloadData];
        
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
        
    }];
    
}

- (void)addToAlbumRequest:(AlbumMedia *)t_media{

    __weak typeof(self) weakSelf = self;
    GCDSemaphore *semaphore = [GCDSemaphore new];
    
    NDAlbumAddMediaParams *params = [[NDAlbumAddMediaParams alloc] init];
    params.album_id = _albumInfo.album_id;
    params.media_id = t_media.media_id;
    [NDAlbumAPI albumAddMediaWithParams:params completionBlockWithSuccess:^{
        
        [semaphore signal];
        
    } Fail:^(int code, NSString *failDescript) {
        
       [semaphore signal];
        
    }];
    
    [semaphore wait];
    
}

#pragma mark -

- (void)AlbumAddAction{
    
    __weak typeof(self) weakSelf = self;
    
    GCDGroup *group = [GCDGroup new];
    
    for (AlbumMedia *t_media  in _marr_selectedData) {
        
        [[GCDQueue globalQueue] execute:^{
            
            [weakSelf addToAlbumRequest:t_media];
            
        } inGroup:group];
    
    }
    
    [[GCDQueue mainQueue] notify:^{
       
        [ShowHUD showSuccess:@"添加成功" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } inGroup:group];
    
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (_marr_data) {
        
        if ([_marr_data count] == 0) {
            
            _v_info.hidden = NO;
            
        }else{
            _v_info.hidden = YES;
        }
        
        return [_marr_data count];
        
    }else{
        
        return 0;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCustomsizeAddCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChildCustomsizeAddCell"];
        
        UIImageView *t_imageIcon = [[UIImageView alloc] init];
        [cell.contentView addSubview:t_imageIcon];
        [t_imageIcon configureForAutoLayout];
        
        [t_imageIcon autoSetDimensionsToSize:CGSizeMake(40, 40)];
        [t_imageIcon autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:15.0];
        [t_imageIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [t_imageIcon setTag:8];
        
        UILabel *t_lb = [[UILabel alloc] init];
        [cell.contentView addSubview:t_lb];
        [t_lb configureForAutoLayout];
        
        [t_lb autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:t_imageIcon withOffset:15];
        [t_lb autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [t_lb autoSetDimension:ALDimensionWidth toSize:160 relation:NSLayoutRelationLessThanOrEqual];
        [t_lb setTag:9];
        
        
        UIImageView *t_imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_gedan_unselect" ]];
        [cell.contentView addSubview:t_imageV];
        [t_imageV configureForAutoLayout];
        
//        [t_imageV autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:t_lb withOffset:15 relation:NSLayoutRelationGreaterThanOrEqual];
        [t_imageV autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:15.0];
        [t_imageV autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [t_imageV setTag:10];
        
        UIImageView *t_imagebottom = [[UIImageView alloc] init];
        t_imagebottom.backgroundColor = UIColorFromRGB(0xe2e2e2);
        [cell.contentView addSubview:t_imagebottom];
        [t_imagebottom configureForAutoLayout];
        
        [t_imagebottom autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 10, 0, -10) excludingEdge:ALEdgeTop];
        [t_imagebottom autoSetDimension:ALDimensionHeight toSize:1.f];
        
        
        
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *t_imageIcon = [cell.contentView viewWithTag:8];
    UILabel *t_lb = [cell.contentView viewWithTag:9];
   
    AlbumMedia *albumMedia = _marr_data[indexPath.row];
    
    
    if (albumMedia) {
        
      [t_imageIcon sd_setImageWithURL:[NSURL URLWithString:albumMedia.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        t_lb.text = albumMedia.name;
        
    }
    
    UIImageView *t_image = [cell.contentView viewWithTag:10];
    
    for (int i = 0 ; i < [_marr_selectedData count]; i++) {
        
        AlbumMedia *t_media = _marr_selectedData[i];
        
        if ([t_media.media_id isEqualToNumber:albumMedia.media_id]) {
            
            [t_image setImage:[UIImage imageNamed:@"icon_gedan_select"]];
            break;
        }
        
        if (i == [_marr_selectedData count] - 1) {
            [t_image setImage:[UIImage imageNamed:@"icon_gedan_unselect"]];
        }
        
    }
    
    if ([_marr_selectedData count] == 0) {
        [t_image setImage:[UIImage imageNamed:@"icon_gedan_unselect"]];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AlbumMedia *albumMedia = _marr_data[indexPath.row];
    
    if (albumMedia) {
       
        for (AlbumMedia *t_media  in _marr_selectedData) {
            
            if ([t_media.media_id isEqualToNumber:albumMedia.media_id]) {
                
                [_marr_selectedData removeObject:t_media];
                
                [_tabView reloadData];
                return;
            }
            
        }
        
        [_marr_selectedData addObject:albumMedia];
        [_tabView reloadData];
    
    }
    
}

#pragma mark - dealloc

- (void)dealloc{

    NSLog(@"ChildCustomizeAddVC Dealloc");
    
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
