//
//  ChildAddToAlbumVC.m
//  HelloToy
//
//  Created by huanglurong on 16/4/28.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildAddToAlbumVC.h"
#import "ChildCustomizeCell.h"
#import "LoadDownNoInfoView.h"
#import "NDAlbumAPI.h"

#import "IQKeyboardManager.h"
#import "UIScrollView+PullTORefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"



@interface ChildAddToAlbumVC ()<UITableViewDataSource,UITableViewDelegate>
{
    ShowHUD *_hud;
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *arr_currentData;              //当前显示数据
@property (nonatomic,strong) AlbumInfo      *albumInfo_selected;    //选中的专辑
@property (assign,nonatomic) NSInteger      page;
@property (assign,nonatomic) BOOL           isLastPage;

@property (weak, nonatomic) IBOutlet UILabel * lb_info;
@property (weak, nonatomic) IBOutlet UIView *v_info;

@property (strong,nonatomic) LoadDownNoInfoView *noneInfoView;


@property (assign,nonatomic) NSInteger mediaType; //专辑类型

@property (weak, nonatomic) IBOutlet UIView *vCover;
@property (strong, nonatomic) IBOutlet UIView *vAdd;
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)handleDeleteDidClick:(id)sender;


@end

@implementation ChildAddToAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加到歌单";
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

#pragma mark - private

- (void)initUI{

    __weak typeof(self) weakSelf = self;

     _v_info.hidden = YES;
    
    _arr_currentData = [NSMutableArray array];
    _isLastPage = NO;
    _page = 1;

    [_tableView addPullScrollingWithActionHandler:^{
        [weakSelf reloadDatas];
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        [weakSelf loadData];
    }];
    
    [_tableView triggerPullScrolling];
    
    _vAdd.frame = CGRectMake(0, -[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:_vAdd];

    

}

-(void)reloadDatas{
    _page = 1;
    _isLastPage = NO;
    [_arr_currentData removeAllObjects];
    [_tableView reloadData];
    [self loadData];
}


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
    params.source = @1;
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


#pragma mark - butttonAciton 

- (IBAction)btnQuedingAction:(id)sender {
    
    if (!_albumInfo_selected) {
        [ShowHUD showError:@"请先选择专辑" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        return;
    }
    
    _hud = [ShowHUD showText:nil configParameter:^(ShowHUD *config) {
    } inView:ApplicationDelegate.window];
    
    NDAlbumAddMediaParams *params = [[NDAlbumAddMediaParams alloc] init];
    params.album_id = _albumInfo_selected.album_id;
    params.media_id = self.albumMedia.media_id;
    [NDAlbumAPI albumAddMediaWithParams:params completionBlockWithSuccess:^{
        
        if(_hud) [_hud hide];
        
        //[MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        [ShowHUD showSuccess:@"添加成功" configParameter:^(ShowHUD *config) {
        } duration:1.0f inView:ApplicationDelegate.window];
        
       
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        }];
    
    } Fail:^(int code, NSString *failDescript) {
        
        if(_hud) [_hud hide];
        

        [ShowHUD showError:@"添加失败" configParameter:^(ShowHUD *config) {
        } duration:1.0f inView:ApplicationDelegate.window];
    }];

}

- (void)addNonInfoView
{
    _noneInfoView = [[[NSBundle mainBundle] loadNibNamed:@"LoadDownNoInfoView" owner:nil options:nil] lastObject];
    _noneInfoView.frame = CGRectMake(0, 0, ViewWidth(self.view), ViewHeight(self.view));
    [_noneInfoView setDelegate:(id<LoadDownNoInfoViewDelegate>)self];
    _noneInfoView.imageView.hidden = NO;
    [_noneInfoView.addButton setImage:[UIImage imageNamed:@"addAlbum_n"] forState:UIControlStateNormal];
    [_noneInfoView.addButton setImage:[UIImage imageNamed:@"addAlbum_h"] forState:UIControlStateHighlighted];
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
    __weak ChildAddToAlbumVC *weakSelf = self;
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
    cell.isAdd = YES;
    cell.albumInfo_selected = _albumInfo_selected;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   
    _albumInfo_selected = _arr_currentData[indexPath.row];
    
    [_tableView reloadData];
    
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

#pragma mark - dealloc

- (void)dealloc{

    NSLog(@"ChildAddToAlbumVC dealloc");
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
