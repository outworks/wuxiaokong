//
//  DownloadingVC.m
//  HelloToy
//
//  Created by ilikeido on 16/4/29.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "DownloadingVC.h"
#import "NDToyAPI.h"
#import "UIScrollView+PullTORefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "NDMediaAPI.h"
#import "ChildCommonCell.h"

#import "PureLayout.h"
#import "ChooseView.h"

@interface DownloadingVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataList;

@property(nonatomic,assign) int page;

@property (weak, nonatomic) IBOutlet UIView *v_info;

@property(nonatomic,strong)  ShowHUD *hud;

@property (nonatomic,strong) NSNumber *playMediaId;

@end

@implementation DownloadingVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
        [weakSelf loadDownloadMedia];
    }];
    [_tableView triggerPullScrolling];
    
}

-(void)reloadDatas{
    _page = 1;
    [self loadDownloadMedia];
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

- (void)loadDownloadMedia{
    [_v_info setHidden:YES];
    __weak typeof(self) weakSelf = self;
    NDMediaQueryDownloadParams *params = [[NDMediaQueryDownloadParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.download = 2;
    params.page = weakSelf.page;
    params.rows = 20;
    [NDMediaAPI queryDownloadWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        [weakSelf.tableView.pullScrollingView stopAnimating];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        if (_page == 1) {
            [_dataList removeAllObjects];
            [_tableView.infiniteScrollingView setEnabled:YES];
        }
        if (data.count == 20) {
            _page ++;
        }else{
            [_tableView.infiniteScrollingView setEnabled:NO];
        }
        [_dataList addObjectsFromArray:data];
        [weakSelf.tableView reloadData];
        if (_dataList.count == 0) {
            [_v_info setHidden:NO];
        }
    } Fail:^(int code, NSString *failDescript) {
        [weakSelf.tableView.pullScrollingView stopAnimating];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
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
        
        [_tableView triggerPullScrolling];
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        
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
    AlbumMedia *media = _dataList[indexPath.row];
    cell.albumMedia = media;
    
    [cell setPlayMediaId:_playMediaId];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     ChildCommonCell *cell = (ChildCommonCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    AlbumMedia *albumMedia = _dataList[indexPath.row];
    
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChildCommonCell *cell = (ChildCommonCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.albumMedia) {
        
        if ([cell.albumMedia.status isEqualToNumber:@0]) {
            
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
        
        ChildCommonCell *cell = (ChildCommonCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        
        [ChooseView showChooseViewInMiddleWithTitle:PROGRAMNAME andPrimitiveText:nil andChooseList:@[[NSString stringWithFormat:NSLocalizedString(@"从玩具中删除", nil)]] andCancelButtonTitle:NSLocalizedString(@"Cancle", nil) andConfirmButtonTitle:NSLocalizedString(@"Sure", nil) andChooseCompleteBlock:^(NSInteger row) {
            if (cell.albumMedia) {
                
                [weakSelf toyMediaDeleteRequest:cell.albumMedia.media_id];
            }
            
        } andChooseCancleBlock:^(NSInteger row) {
        }];
        
        
    }
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
