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

@interface ChildSearchVC (){
    ShowHUD *_hud;
}


@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *v_noData;

@property (strong, nonatomic) IBOutlet UIView *v_album;
@property (strong, nonatomic) IBOutlet UIView *v_media;
@property (strong, nonatomic) IBOutlet UIButton *btn_album;
@property (strong, nonatomic) IBOutlet UIButton *btn_media;

@property (assign, nonatomic) NSInteger albumNumber;
@property (assign, nonatomic) NSInteger mediaNumber;
@property (nonatomic,strong) NSString *str_search;

@property (nonatomic,strong) NSMutableArray *mArr_album;
@property (nonatomic,strong) NSMutableArray *mArr_media;

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
            [_tableView reloadData];

            
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


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return 2;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( section == 0 && [_mArr_album count] > 0) {
        return _v_album;
    }else if (section == 1&& [_mArr_media count] > 0){
        return _v_media;
    }else{
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 0 && [_mArr_album count] > 0) {
        return 40.f;
    }else if (section == 1&& [_mArr_media count] > 0){
        return 40.f;
    }else{
        return 0.f;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        return 0;
    }else{
        return [_mArr_album count]? 10 : 0;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return [_mArr_album count];
        
    }else if (section == 1){
        
        return [_mArr_media count];
        
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
        
        
    }else{
        
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
            
            [cell setPlayMediaId:_playMediaId];
        }
        
    
        return cell;
        
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        
        XMAlbum * album = _mArr_album[indexPath.row];
        
        ChildAlbumDetailVC *t_vc = [[ChildAlbumDetailVC alloc] init];
        t_vc.album_xima = album;
        
        [self.navigationController pushViewController:t_vc animated:YES];

        
    }else{
        
        ChildCommonCell *cell = (ChildCommonCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        NSMutableDictionary * t_dic = _mArr_media[indexPath.row];
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
        
        [ShowHUD showWarning:NSLocalizedString(@"当前无玩具", nil) configParameter:^(ShowHUD *config) {
        } duration:1.0f inView:ApplicationDelegate.window];
        
        return;
    }
    
    NDToyPlayMediaParams *params = [[NDToyPlayMediaParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    
    params.media_id = cell.downloadStatus.media_id;
    params.media_type = @1;
    
    _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
    } inView:ApplicationDelegate.window];
    
    [NDToyAPI toyPlayMediaWithParams:params completionBlockWithSuccess:^{
        
        if (_hud) [_hud hide];
        
        [ShowHUD showSuccess:NSLocalizedString(@"点播成功", nil) configParameter:^(ShowHUD *config) {} duration:1.0f inView:ApplicationDelegate.window];
        
    } Fail:^(int code, NSString *failDescript) {
        
        if (_hud) [_hud hide];
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {} duration:1.0f inView:ApplicationDelegate.window];
        
    }];
    
}

- (void)handleDownBtnActionInCell:(ChildCommonCell *)cell{
    
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
        
    } Fail:^(int code, NSString *failDescript) {
        
    }];
    
    
    
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
