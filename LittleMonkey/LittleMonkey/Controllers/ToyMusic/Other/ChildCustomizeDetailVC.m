//
//  ChildCustomizeDetailVC.m
//  HelloToy
//
//  Created by huanglurong on 16/6/21.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildCustomizeDetailVC.h"
#import "UIImageView+WebCache.h"
#import "UIImage+External.h"
#import "UIButton+Block.h"
#import "ImageFileInfo.h"
#import "ChooseView.h"
#import "FXBlurView.h"
#import "ChildSelectView.h"

#import "NDAlbumAPI.h"
#import "ND3rdMediaAPI.h"
#import "NDToyAPI.h"

#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+PullTORefresh.h"

#import "ChildMediaBatVC.h"
#import "ChildCustomizeAddVC.h"
#import "PureLayout.h"

#import "ChildCommonCell.h"

#define  NickName_MaxLen 16

@interface ChildCustomizeDetailVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSInteger _currentWriten;
    MBProgressHUD *_hud;
}

@property (weak, nonatomic) IBOutlet UITableView *tb_content;

@property (weak, nonatomic) IBOutlet UIView *v_top;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_music;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_store;

@property (nonatomic, weak) IBOutlet FXBlurView *blurView;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_background;

@property (weak, nonatomic) IBOutlet UILabel *lb_musicNumber;
@property (weak, nonatomic) IBOutlet UIButton *btn_xuanji;
@property (weak, nonatomic) IBOutlet UIButton *btn_batDownload;

@property (nonatomic,strong) ChildSelectView *childSelectView;

@property (weak, nonatomic) IBOutlet UIView *v_info;
@property (weak, nonatomic) IBOutlet UILabel * lb_info;

@property (strong, nonatomic) IBOutlet UIView *vNickName;
@property (weak, nonatomic) IBOutlet UIButton *btnCancle;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btndelete;
@property (weak, nonatomic) IBOutlet UITextField *tfNickName;
@property (weak, nonatomic) IBOutlet UIView *vCover;
@property(nonatomic,strong) UIImage *headImage;
@property (nonatomic,strong) UIButton *btn_share;


@property (nonatomic,strong) NSMutableArray *arr_currentData;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *coverGesture;



@property (assign,nonatomic) int            page_album;
@property (assign,nonatomic) int            index_page;
@property (assign,nonatomic) BOOL           isAlbumLastPage;
@property (nonatomic,assign) BOOL           isReload;
@property (nonatomic,assign) BOOL           isShare;

@property (nonatomic,strong) NSNumber *playMediaId;

@end

@implementation ChildCustomizeDetailVC

#pragma mark - viewlift

- (instancetype)init{
    if ( self = [super init]) {
      
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPlayDown:) name:@"播放完刷新" object:nil];
        [NotificationCenter addObserver:self selector:@selector(removeMedia:) name:@"移除媒体通知" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadStatusAction:) name:NOTIFCATION_DOWNLOADSTATUSARR object:nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRightNavigationItem];
    [self initView];
    
    [self initData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tb_content triggerPullScrolling];
}

#pragma mark - init

- (void)initData{
    
    __weak typeof(self) weakSelf = self;
    
    self.arr_currentData = [NSMutableArray array];
    
    _page_album = 1;
    _index_page = _page_album;
    
    [_tb_content addPullScrollingWithActionHandler:^{
        weakSelf.isReload = YES;
        weakSelf.page_album = weakSelf.index_page;
        
        [weakSelf loadAblumDetail];
    }];
    
    [_tb_content addInfiniteScrollingWithActionHandler:^{
        weakSelf.isReload = NO;
        [weakSelf loadAblumDetail];
        
    }];
    
}

- (void)initView{
    
    __weak typeof(self) weakSelf = self;
    
    self.navigationItem.title = @"歌单详情";
    
    
    if ([_albumInfo.source isEqualToNumber:@1]) {
        _btn_share.selected = YES;
        
        [_btn_share setTitle:@"已分享" forState:UIControlStateNormal];
        [_btn_share setImage:nil forState:UIControlStateNormal];
        
    }
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnIconEditAction:)];
    _imageV_icon.userInteractionEnabled = YES;
    [_imageV_icon addGestureRecognizer:gesture];
    
    self.blurView.blurRadius = 30.0;
    
    
    _imageV_icon.layer.cornerRadius  = 5.f;
    _imageV_icon.layer.masksToBounds = YES;
    [_imageV_icon sd_setImageWithURL:[NSURL URLWithString:_albumInfo.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
    
    [_imgv_background sd_setImageWithURL:[NSURL URLWithString:_albumInfo.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
    
    if ([_albumInfo.album_type isEqualToNumber:@0]) {
        
        _imageV_music.hidden = YES;
        _imageV_store.hidden = NO;
        
    }else{
        
        _imageV_music.hidden = NO;
        _imageV_store.hidden = YES;

    }
    
    _lb_title.text = _albumInfo.name;
     _lb_musicNumber.text = [NSString stringWithFormat:@"共%d条声音",[_albumInfo.number integerValue]];
    
    //设置vNickName初始frame
    _vNickName.frame = CGRectMake(0, -_vNickName.frame.size.height, [UIScreen mainScreen].bounds.size.width, _vNickName.frame.size.height);
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:_vNickName];
    
    //取消按钮
    [_btnCancle handleClickEvent:UIControlEventTouchUpInside withClickBlick:^{
        [_vCover removeGestureRecognizer:_coverGesture];
        
        weakSelf.tfNickName.text = @"";
        [weakSelf.tfNickName resignFirstResponder];
        [self updateNickNameViewHiddenAnimateIfNeed];
    }];
    
    //保存按钮
    [_btnSave handleClickEvent:UIControlEventTouchUpInside withClickBlick:^{
        [weakSelf.tfNickName resignFirstResponder];
        
        if (_isShare) {
            
            NDAlbumUpdateParams *params = [[NDAlbumUpdateParams alloc] init];
            params.album_id = _albumInfo.album_id;
            params.source  = @1;
            params.info    = weakSelf.tfNickName.text;
            
            [NDAlbumAPI albumUpdateWithParams:params
                   completionBlockWithSuccess:^(void) {
                       
                       [ShowHUD showSuccess:NSLocalizedString(@"分享成功", nil) configParameter:^(ShowHUD *config) {
                       } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
                       
                       _btn_share.selected = YES;
                       
                       [_btn_share setTitle:@"已分享" forState:UIControlStateNormal];
                       [_btn_share setImage:nil forState:UIControlStateNormal];
                       [_btn_share setTitle:@"已分享" forState:UIControlStateSelected];
                       [_btn_share setImage:nil forState:UIControlStateSelected];
                       
                       _albumInfo.source = params.source;
                       
                   } Fail:^(int code, NSString *failDescript) {
                       
                       [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
                       } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
                       
                   }
             ];
            
        }else{
            
            if ([weakSelf.tfNickName.text isEqualToString:@""]) {
                [ShowHUD showWarning:NSLocalizedString(@"请输入歌单名", nil) configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
                
                return ;
            }
            
            if (_tfNickName.text.length > NickName_MaxLen) {
                [ShowHUD showError:NSLocalizedString(@"歌单名太长了", nil) configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
                return;
            }
            
            ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"保存中...", nil) configParameter:^(ShowHUD *config) {
            } inView:[[UIApplication sharedApplication] windows].firstObject];
            
            NDAlbumUpdateParams *params = [[NDAlbumUpdateParams alloc] init];
            params.album_id = _albumInfo.album_id;
            params.name = weakSelf.tfNickName.text;
            params.icon = _albumInfo.icon;
            
            [NDAlbumAPI albumUpdateWithParams:params
                   completionBlockWithSuccess:^(void) {
                       [hud hide];
                       [ShowHUD showSuccess:NSLocalizedString(@"修改成功", nil) configParameter:^(ShowHUD *config) {
                       } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
                       _albumInfo.name = weakSelf.tfNickName.text;
                       [self updateNickNameViewHiddenAnimateIfNeed];
                       
                       _lb_title.text = _albumInfo.name;
                       
                   } Fail:^(int code, NSString *failDescript) {
                       [hud hide];
                       if(code == 1011){
                           
                           [ShowHUD showError:@"新歌单名和旧歌单名相同" configParameter:^(ShowHUD *config) {
                           } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
                           
                       }else{
                           
                           [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
                           } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
                       }
                   }
             ];
            
        }
    }];
    
    //删除按钮
    [_btndelete handleClickEvent:UIControlEventTouchUpInside withClickBlick:^{
        weakSelf.tfNickName.text = @"";
    }];
    
   
    if (![ShareValue sharedShareValue].toyDetail.toy_id) {
        [_btn_batDownload setHidden:YES];
    }

}

- (void)initRightNavigationItem{

    
    CGRect buttonFrame = CGRectMake(0, 0, 100, self.navigationController.navigationBar.frame.size.height);
    
    UIView *t_view =  [[UIView alloc] initWithFrame:buttonFrame];
    //t_view.backgroundColor = [UIColor redColor];
    
    _btn_share = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn_share.contentMode = UIViewContentModeScaleAspectFit;
    _btn_share.backgroundColor = [UIColor clearColor];
    _btn_share.frame = CGRectMake(0, 0, 60, self.navigationController.navigationBar.frame.size.height);
//    btn_share.backgroundColor = [UIColor yellowColor];
    
    _btn_share.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_btn_share setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn_share setTitle:@"分享" forState:UIControlStateNormal];
    [_btn_share setImage:[UIImage imageNamed:@"icon_gedan_share"] forState:UIControlStateNormal];
     [_btn_share setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
     [_btn_share setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    [_btn_share addTarget:self action:@selector(btnShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [t_view addSubview:_btn_share];
  
    UIButton *btn_more = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_more.contentMode = UIViewContentModeScaleAspectFit;
    //btn_more.backgroundColor = [UIColor yellowColor];
    btn_more.frame = CGRectMake(60, 0, 40, self.navigationController.navigationBar.frame.size.height);
    [btn_more setEnlargeEdgeWithTop:0 right:80 bottom:0 left:0];
    
    btn_more.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btn_more setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_more setTitle:nil forState:UIControlStateNormal];
    [btn_more setImage:[UIImage imageNamed:@"icon_child_more"] forState:UIControlStateNormal];
    [btn_more setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -30)];
    [btn_more addTarget:self action:@selector(btnMoreAction:) forControlEvents:UIControlEventTouchUpInside];
    [t_view addSubview:btn_more];
    t_view.clipsToBounds = NO;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithCustomView:btn_more];
    negativeSpacer.width = 10;
    
    self.navigationItem.rightBarButtonItem = negativeSpacer;
    
}

#pragma mark - APIS

- (void)loadAblumDetail{

    
    if (_albumInfo) {
        
        __weak __typeof(*&self) weakSelf = self;
        
        ShowHUD *showHud = nil;
        if (_page_album == 1) {
            
            showHud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
            } inView:self.view];
            
        }
        
        NDAlbumDetailParams *params = [[NDAlbumDetailParams alloc] init];
        params.album_id = _albumInfo.album_id;
        params.page = @(_page_album);
        params.rows = @20;
        
        [NDAlbumAPI albumDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
            
            if (showHud) [showHud hide];
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
            
            if (showHud) [showHud hide];
            
            [weakSelf.tb_content.infiniteScrollingView stopAnimating];
            [weakSelf.tb_content.pullScrollingView stopAnimating];
            [weakSelf.tb_content reloadData];
            
            
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:weakSelf.view];
            
            weakSelf.page_album ++;
            
        }];
        
    }
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

#pragma mark - privetMethods 

- (void)addMusic{

    ChildCustomizeAddVC *t_vc = [[ChildCustomizeAddVC alloc] init];
    t_vc.albumInfo = _albumInfo;
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

- (void)deleteAlbum{

    __weak typeof(self) weakSelf = self;
    
    [ChooseView showChooseViewInMiddleWithTitle:PROGRAMNAME andPrimitiveText:nil andChooseList:@[[NSString stringWithFormat:NSLocalizedString(@"是否删除歌单", nil)]] andCancelButtonTitle:NSLocalizedString(@"否", nil) andConfirmButtonTitle:NSLocalizedString(@"是", nil) andChooseCompleteBlock:^(NSInteger row) {
        
        NDAlbumDeleteParams *params = [[NDAlbumDeleteParams alloc] init];
        params.album_id = _albumInfo.album_id;
        
        ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"删除中...", nil) configParameter:^(ShowHUD *config) {
        } inView:self.view];
        
        [NDAlbumAPI albumDeleteWithParams:params completionBlockWithSuccess:^{
            
            [hud hide];
            
            [ShowHUD showSuccess:NSLocalizedString(@"删除成功", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:ApplicationDelegate.window];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        } Fail:^(int code, NSString *failDescript) {
            
            [hud hide];
            
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:ApplicationDelegate.window];
            
            
        }];
        
        
    } andChooseCancleBlock:^(NSInteger row) {
    }];

}


#pragma mark - buttonAction

- (IBAction)btnTitleEditAction:(id)sender {
    
    _isShare = NO;
    
    [_vCover addGestureRecognizer:_coverGesture];
    
    _tfNickName.text = _albumInfo.name;
    //vNickName出现[添加下降动画]
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^() {
                         CGRect frame = _vNickName.frame;
                         frame.origin.y = 0;
                         _vNickName.frame = frame;
                         [UIView animateWithDuration:0.2 animations:^{
                             _vCover.hidden = NO;
                             [_tfNickName becomeFirstResponder];
                         } completion:^(BOOL finished) {
                         }];
                         
                     } completion:^(BOOL finished) {
                     }];
    
}


- (IBAction)btnIconEditAction:(id)sender {

    [ChooseView showChooseViewInBottomWithChooseList:@[NSLocalizedString(@"拍照", nil),NSLocalizedString(@"从手机相册选取", nil),NSLocalizedString(@"取消", nil)] andBackgroundColorList:@[RGB(255, 255, 255),RGB(255, 255, 255),RGB(255, 255, 255)] andTextColorList:@[RGB(30, 28, 39),RGB(30, 28, 39),RGB(30, 28, 39)] andChooseCompleteBlock:^(NSInteger row) {
        switch (row) {
            case 0:
            {
                [self takePhoto];
            }
                break;
            case 1:
            {
                [self LocalPhoto];
            }
                break;
            default:
                break;
        }
    } andChooseCancleBlock:^(NSInteger row) {
    } andTitle:nil andPrimitiveText:nil];
    
    
    
}


- (IBAction)btnShareAction:(id)sender {

    NSLog(@"share click");
    
    UIButton *t_button = (UIButton *)sender;
    if (t_button.selected == YES) {
        return;
    }
    
    _isShare = YES;
    
    [_vCover addGestureRecognizer:_coverGesture];
    
    _tfNickName.text = _albumInfo.name;
    //vNickName出现[添加下降动画]
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^() {
                         CGRect frame = _vNickName.frame;
                         frame.origin.y = 0;
                         _vNickName.frame = frame;
                         [UIView animateWithDuration:0.2 animations:^{
                             _vCover.hidden = NO;
                             [_tfNickName becomeFirstResponder];
                         } completion:^(BOOL finished) {
                         }];
                         
                     } completion:^(BOOL finished) {
    }];
    
}


- (IBAction)btnMoreAction:(id)sender{
 
    NSLog(@"more click");

    [ChooseView showChooseViewInBottomWithChooseList:@[NSLocalizedString(@"添加媒体", nil),NSLocalizedString(@"删除歌单", nil),NSLocalizedString(@"取消", nil)] andBackgroundColorList:@[RGB(255, 255, 255),RGB(255, 255, 255),RGB(255, 255, 255)] andTextColorList:@[RGB(30, 28, 39),RGB(30, 28, 39),RGB(30, 28, 39)] andChooseCompleteBlock:^(NSInteger row) {
        switch (row) {
            case 0:
            {
                [self addMusic];
            }
                break;
            case 1:
            {
                [self deleteAlbum];
            }
                break;
            default:
                break;
        }
    } andChooseCancleBlock:^(NSInteger row) {
    } andTitle:nil andPrimitiveText:nil];
    
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
    
    if (_albumInfo) {
        [self.childSelectView setUpLabels:[_albumInfo.number integerValue] WithIndex:_index_page];
    }
    
    self.childSelectView.block_tag = ^(NSInteger index){
        
        weakSelf.isReload = YES;
        weakSelf.index_page = (int)index;
        
        weakSelf.page_album = weakSelf.index_page;
        
        if (weakSelf.albumInfo) {
            
            [weakSelf loadAblumDetail];
            
        }
        
        [weakSelf.childSelectView hide];
        
    };
    
    [self.childSelectView show];
    
}

- (IBAction)btnBatDownAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    ChildMediaBatVC *t_vc = [[ChildMediaBatVC alloc] init];
    t_vc.type = btn.tag;
    if (_albumInfo){
        
        t_vc.albumInfo = self.albumInfo;
        
    }
    [self.navigationController pushViewController:t_vc animated:YES];
    
    
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
    
    ChildCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCommonCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ChildCommonCell" bundle:nil] forCellReuseIdentifier:@"ChildCommonCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCommonCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (![ShareValue sharedShareValue].toyDetail.toy_id) {
        cell.btn_status.hidden = YES;
    }
    
    if (_albumInfo) {
        
        NSMutableDictionary *t_dic = _arr_currentData[indexPath.row];
        AlbumMedia *albumMedia = [t_dic objectForKey:@"AlbumMedia"];
        MediaDownloadStatus *downloadStatus = [t_dic objectForKey:@"MediaDownloadStatus"];
        cell.albumMedia = albumMedia;
        cell.albumInfo = _albumInfo;
        cell.isGedan = YES;
        
        if (downloadStatus) {
            
            cell.downloadStatus = downloadStatus;
        }
    
    }
    [cell setPlayMediaId:_playMediaId];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChildCommonCell *cell = (ChildCommonCell *)[self.tb_content cellForRowAtIndexPath:indexPath];
    
    if (_albumInfo) {
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
            }
            

        } andChooseCancleBlock:^(NSInteger row) {
        }];
        
        
        
        
    }
}


#pragma mark - Functions

//修改群名视图消失的动画
- (void)updateNickNameViewHiddenAnimateIfNeed
{
    __weak ChildCustomizeDetailVC *weakSelf = self;
    //vNickName消失
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.vCover.hidden = YES;
        CGRect frame = weakSelf.vNickName.frame;
        frame.origin.y = -frame.size.height;
        weakSelf.vNickName.frame = frame;
    }];
    
}

//点击蒙层
- (IBAction)handleCoverClick:(id)sender {
    self.tfNickName.text = @"";
    [self.tfNickName resignFirstResponder];
    [self updateNickNameViewHiddenAnimateIfNeed];
}


//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
//打开本地相册
-(void)LocalPhoto
{
    //相册是可以用模拟器打开的
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
    
}


//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [image fixOrientation];
        image = [image imageByScaleForSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
        self.headImage = image;
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImage];
    }];
    
    picker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}



-(void)uploadImage{
    
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    _hud.progress = 0.0;
    _hud.mode = MBProgressHUDModeAnnularDeterminate;
    _hud.labelText = NSLocalizedString(@"上传中...", nil);
    [self.view addSubview:_hud];
    [_hud show:YES];
    ImageFileInfo *fileInfo = [[ImageFileInfo alloc]initWithImage:_headImage];
    
    [GCDQueue executeInGlobalQueue:^{
        
        [NDBaseAPI uploadImageFile:fileInfo.fileData name:fileInfo.name fileName:fileInfo.fileName mimeType:fileInfo.mimeType ProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            [[GCDQueue mainQueue] execute:^{
                _currentWriten += bytesWritten;
                _hud.progress = (float)_currentWriten/fileInfo.filesize;
            }];
        } successBlock:^(NSString *filepath) {
            [_hud removeFromSuperview];
            _hud = nil;
            [self updategroupIcon:filepath];
        } errorBlock:^(BOOL NotReachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _hud.labelText = NSLocalizedString(@"网络不给力", nil);
                _hud.mode = MBProgressHUDModeText;
                [_hud hide:YES afterDelay:1.5];
            });
        }];
    }];
    
}

-(void)updategroupIcon:(NSString *)filepath
{
    
    NDAlbumUpdateParams *params = [[NDAlbumUpdateParams alloc] init];
    params.album_id = _albumInfo.album_id;
    params.icon = filepath;
    
    [NDAlbumAPI albumUpdateWithParams:params
           completionBlockWithSuccess:^(void) {

               [ShowHUD showSuccess:NSLocalizedString(@"修改过成功", nil) configParameter:^(ShowHUD *config) {
               } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
               
               _albumInfo.icon = filepath;
               
               [_imageV_icon sd_setImageWithURL:[NSURL URLWithString:_albumInfo.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
               
           } Fail:^(int code, NSString *failDescript) {
               
               [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
               } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
            
           }
     ];
    
}



#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == _tfNickName){
        if (string.length == 0) {
            return YES;
        }
        return textField.text.length<NickName_MaxLen;
    }
    return YES;
}

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

    NSLog(@"ChildCustomizeDetailVC dealloc");
    
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
