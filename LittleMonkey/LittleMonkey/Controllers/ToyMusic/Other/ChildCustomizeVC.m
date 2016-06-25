//
//  ChildCustomizeVC.m
//  HelloToy
//
//  Created by huanglurong on 16/4/12.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildCustomizeVC.h"
#import "LoadDownNoInfoView.h"
#import "ChildMusicVC.h"
#import "ChildCustomizeCell.h"
#import "ChildAlbumDetailVC.h"

#import "NDAlbumAPI.h"

#import "IQKeyboardManager.h"
#import "UIScrollView+PullTORefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ChildCustomizeDetailVC.h"


@interface ChildCustomizeVC ()<UITableViewDataSource,UITableViewDelegate,LoadDownNoInfoViewDelegate,UITextFieldDelegate>
{
    ShowHUD *_hud;
}

@property (strong,nonatomic) NSMutableArray *arr_currentData;              //当前显示数据
@property (nonatomic,strong) AlbumInfo      *albumInfo_selected;    //选中的专辑
@property (assign,nonatomic) NSInteger      page;
@property (assign,nonatomic) BOOL           isLastPage;
@property (strong,nonatomic) LoadDownNoInfoView *noneInfoView;

@property (assign,nonatomic) NSInteger mediaType; //专辑类型

@property (weak, nonatomic) IBOutlet UIView *vCover;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *vAdd;
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)handleDeleteDidClick:(id)sender;

@end

@implementation ChildCustomizeVC

- (instancetype)init{
    
    if ( self = [super init]) {
        
        [self initialize];
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView triggerPullScrolling];

    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

- (void)initView
{
    __weak typeof(self) weakSelf = self;
    
    [_tableView addPullScrollingWithActionHandler:^{
        [weakSelf reloadDatas];
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        [weakSelf loadData];
    }];
    
    //设置vNickName初始frame
    _vAdd.frame = CGRectMake(0, -[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:_vAdd];
    
}


#pragma mark -
#pragma mark private methods

/***    初始化数据    ***/

- (void)initialize{
    
    _arr_currentData = [NSMutableArray array];
    self.navigationItem.title = @"歌单";
    _isLastPage = NO;
    _page = 1;
    
    
}


-(void)reloadDatas{
    _page = 1;
    _isLastPage = NO;
    [_arr_currentData removeAllObjects];
    [_tableView reloadData];
    [self loadData];
}

#pragma mark -
#pragma mark set&&get


#pragma mark - APIS

/***    请求儿歌专辑列表    ***/

- (void)loadData{
    
    __weak typeof(*&self) weakSelf = self;
    
    if (_page == 1) {
        _tableView.showsInfiniteScrolling = NO;
    }else{
        _tableView.showsInfiniteScrolling = !_isLastPage;
    }
    
    if (_page == 1) {
        _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
        } inView:self.view];
    }
    
    NDAlbumQueryParams *params = [[NDAlbumQueryParams alloc] init];
    params.source = @"1";
    params.page = [NSNumber numberWithInteger:_page];
    
    [NDAlbumAPI albumQueryWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        
        if (_hud) [_hud hide];
        [weakSelf.tableView.pullScrollingView stopAnimating];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        
        if ([data count] < 20) {
            
            weakSelf.isLastPage = YES;
            
        }
        [weakSelf.arr_currentData addObjectsFromArray:data];
        

        if (weakSelf.arr_currentData.count == 0) {
            [self addNonInfoView];
        } else {
            [self removeNonInfoView];
        }
        
        weakSelf.tableView.showsInfiniteScrolling = !_isLastPage;
        [weakSelf.tableView reloadData];
        
        weakSelf.page ++;
        
    } Fail:^(int code, NSString *failDescript) {
        
        if (_hud) [_hud hide];
        
        if (weakSelf.arr_currentData.count == 0) {
            [self addNonInfoView];
        } else {
            [self removeNonInfoView];
        }
        [weakSelf.tableView.pullScrollingView stopAnimating];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        [weakSelf.tableView reloadData];
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }];
    
}

//添加专辑
- (void)addAlbumRequest
{
    NDAlbumAddParams *params = [[NDAlbumAddParams alloc]init];
    params.name = _textField.text;
    params.source = @2;
    params.icon = @"";
    params.album_type = @(_mediaType);
    [NDAlbumAPI albumAddWithParams:params completionBlockWithSuccess:^{
        [self.textField resignFirstResponder];
        [self hiddenAddView];
        [self reloadDatas];
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
    }];
}

#pragma mark - Functions

- (void)addNonInfoView
{
    _noneInfoView = [[[NSBundle mainBundle] loadNibNamed:@"LoadDownNoInfoView" owner:nil options:nil] lastObject];
    _noneInfoView.frame = CGRectMake(0, 0, ViewWidth(self.view), ViewHeight(self.view));
    _noneInfoView.delegate = self;
    _noneInfoView.imageView.hidden = NO;
    [_noneInfoView.addButton setImage:[UIImage imageNamed:@"addAlbum_n"] forState:UIControlStateNormal];
    [_noneInfoView.addButton setImage:[UIImage imageNamed:@"addAlbum_h"] forState:UIControlStateHighlighted];
//    if (self.mediaType == LocalMediaTypeMusic) {
//        _noneInfoView.textLabel.text = NSLocalizedString(@"PrivateMusicCollectionAlbum", nil);
//    } else if (self.mediaType == LocalMediaTypeStory) {
//        _noneInfoView.textLabel.text = NSLocalizedString(@"PrivateStoryCollectionAlbum", nil);
//    }
    [self.view addSubview:_noneInfoView];
}

- (void)removeNonInfoView
{
    for(UIView *view in self.view.subviews){
        if ([view isKindOfClass:[LoadDownNoInfoView class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)showAddView
{
    //vNickName出现[添加下降动画]
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^() {
                         CGRect frame = _vAdd.frame;
                         frame.origin.y = 0;
                         _vAdd.frame = frame;
                         [UIView animateWithDuration:0.2 animations:^{
                             _vCover.hidden = NO;
                             [_textField becomeFirstResponder];
                         } completion:^(BOOL finished) {
                         }];
                         
                     } completion:^(BOOL finished) {
                     }];
}

- (void)hiddenAddView
{
    __weak ChildCustomizeVC *weakSelf = self;
    //vNickName消失
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.vCover.hidden = YES;
        CGRect frame = weakSelf.vAdd.frame;
        frame.origin.y = - frame.size.height;
        weakSelf.vAdd.frame = frame;
    }];
}

#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_arr_currentData) {
        
        return [_arr_currentData count];
        
    }else{
        
        return 0;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString* identifier = @"ChildCustomizeCell";
    
    ChildCustomizeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"ChildCustomizeCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.albumInfo          = _arr_currentData[indexPath.row];
    cell.isAdd = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    ChildCustomizeDetailVC *t_childAlbumDetail = [[ChildCustomizeDetailVC alloc] init];
    t_childAlbumDetail.albumInfo = _arr_currentData[indexPath.row];
    
    [self.navigationController pushViewController:t_childAlbumDetail animated:YES];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_arr_currentData count] > 0) {
        
        return YES;
        
    }
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        __weak typeof(self) weakSelf = self;
        
        AlbumInfo *t_albumInfo =  _arr_currentData[indexPath.row];
        
        NDAlbumDeleteParams *params = [[NDAlbumDeleteParams alloc] init];
        params.album_id = t_albumInfo.album_id;
        
        ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"删除中...", nil) configParameter:^(ShowHUD *config) {
        } inView:self.view];
        
        [NDAlbumAPI albumDeleteWithParams:params completionBlockWithSuccess:^{
            [hud hide];
            [ShowHUD showSuccess:NSLocalizedString(@"删除成功", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:weakSelf.view];
            
            [weakSelf.arr_currentData removeObject:t_albumInfo];
            [weakSelf.tableView reloadData];
            
        } Fail:^(int code, NSString *failDescript) {
            
            [hud hide];
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:weakSelf.view];
            
            
        }];
        
        
    }
}

#pragma mark - ButtonActions

- (IBAction)handleCancleDidClick:(id)sender {
    self.textField.text = @"";
    [self.textField resignFirstResponder];
    [self hiddenAddView];
}

- (IBAction)handleSaveDidClick:(id)sender {
    if (_textField.text.length == 0) {
        [ShowHUD showTextOnly:NSLocalizedString(@"请输入专辑名称", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
        return;
    }
    if (_textField.text.length > 16) {
        [ShowHUD showError:NSLocalizedString(@"专辑名称超过16位咯~", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
        return;
    }
    [self addAlbumRequest];
}

- (IBAction)handleDeleteDidClick:(id)sender {
    _textField.text = @"";
}

//点击蒙层
- (IBAction)handleCoverClick:(id)sender {
    self.textField.text = @"";
    [self.textField resignFirstResponder];
    [self hiddenAddView];
}

- (IBAction)handleAddAlbumDidClick:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"专辑类型" delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"音乐",@"故事", nil];
    [actionSheet showInView:self.view];
    
    
}
#pragma mark - LoadDownNoInfoViewDelegate

- (void)onViewAddDidClicked:(LoadDownNoInfoView *)view
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"专辑类型" delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"音乐",@"故事", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UIActionSheetDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    NSLog(@"%ld",buttonIndex);
    
    if (buttonIndex == 0) {
        _mediaType = 1;
        [self showAddView];
    }else if (buttonIndex == 1){
        _mediaType = 0;
        [self showAddView];
    }

}


#pragma mark -
#pragma mark 通知事件


- (void)updataMediaNotication:(NSNotification *)note{
    [self.tableView reloadData];
    
}

#pragma mark -
#pragma mark dealloc
-(void)dealloc{
    
    NSLog(@"GroupMemberVC dealloc");
    [_vAdd removeFromSuperview];
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
