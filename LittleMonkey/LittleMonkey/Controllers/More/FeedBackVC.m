//
//  FeedBackVC.m
//  HelloToy
//
//  Created by nd on 15/8/25.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "FeedBackVC.h"
#import "InputView.h"
#import "IQKeyboardManager.h"
#import "NDSystemAPI.h"
#import "ImageFileInfo.h"
#import "ChatCell.h"
#import "ChooseView.h"
#import "NDSystemAPI.h"
#import "PureLayout.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface FeedBackVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSInteger _currentWriten;
    MBProgressHUD *_hud;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *v_info;


@property (strong, nonatomic) InputView *inputView;
@property (strong, nonatomic) NSLayoutConstraint *input_bottom;

@property (strong,nonatomic) NSMutableArray *arr_data;


@property (strong,nonatomic) ChatCell *chatCell;



@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arr_data = [NSMutableArray array];
    
    
    [IQKeyboardManager sharedManager].enable = NO;
    [self addobserver];
    [self initUI];
    
    UINib *cellNib = [UINib nibWithNibName:@"ChatCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CellIdentifier];
    self.chatCell  = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self loadSuggestData];
    [self clearReplys];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;

}


#pragma mark - private methods 

-(void)addobserver{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chatImageTap) name:NOTIFCATION_CHATIMAGETAP object:nil];
    
    
}

-(void)initUI{
    
    
    self.navigationItem.title = NSLocalizedString(@"Feedback", nil);
    
    self.inputView = [InputView initCustomView];
    [self.inputView setUpWithSuperVC:self];
    [self.inputView setDelegate:(id<InputViewDelegate>)self];
    self.inputView.placeText = NSLocalizedString(@"PleaseInputTheOpinion", nil);
    self.inputView.maxLine = 5.0f;
    [self.view addSubview:self.inputView];
    
    [self.inputView configureForAutoLayout];
    
    [self.inputView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.inputView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    _input_bottom = [self.inputView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
   
    [self.inputView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tableView];
    self.inputView.v_height = [self.inputView autoSetDimension:ALDimensionHeight toSize:self.inputView.tv_minHeight+6];
    
}

#pragma mark - loadData

-(void)loadSuggestData{
    
    __weak __typeof(self) weakSelf = self;
    
    ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"Requesting", nil) configParameter:^(ShowHUD *config) {
    } inView:self.view];
    
    NDSystemQuerySuggestParams *params = [[NDSystemQuerySuggestParams alloc] init];
    [NDSystemAPI systemQuerySuggestWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        [hud hide];
        if ([data count] > 0) {
        
            for (int i = 0; i < [data count]; i++) {
                Suggest *suggest = data[i];
                if (suggest.reply && ![suggest.reply isEqualToString:@""]) {
                    Suggest *suggest_first = [[Suggest alloc] init];
                    suggest_first.suggest_id = suggest.suggest_id;
                    suggest_first.content = suggest.content;
                    suggest_first.picture = suggest.picture;
                    suggest_first.pictureWidth = suggest.pictureWidth;
                    suggest_first.pictureHeight = suggest.pictureHeight;
                    suggest_first.time = suggest.time;
                    suggest_first.reply =@"";
                    [weakSelf.arr_data addObject:suggest_first];
                    
                    Suggest *suggest_second = [[Suggest alloc] init];
                    suggest_second.suggest_id = suggest.suggest_id;
                    suggest_second.content = @"";
                    suggest_second.picture = @"";
                    suggest_second.pictureWidth = suggest.pictureWidth;
                    suggest_second.pictureHeight = suggest.pictureHeight;
                    suggest_second.time = suggest.time;
                    suggest_second.reply =suggest.reply;
                    
                    [weakSelf.arr_data addObject:suggest_second];
                }else{
                    [weakSelf.arr_data addObject:suggest];
                }
            }
            
            
        }
        
        [weakSelf.tableView reloadData];
        [[GCDQueue mainQueue]  execute:^{
            [weakSelf tableViewScrollToBottom];
        } afterDelay:.5f*NSEC_PER_SEC];
        
        
        
    } Fail:^(int code, NSString *failDescript) {
        [hud hide];
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
    }];
    
}

-(void)clearReplys{
    NDSystemMarkAllReplyParams *params = [[NDSystemMarkAllReplyParams alloc]init];
    [NDSystemAPI systemMarkAllReplyWithParams:params completionBlockWithSuccess:^{
        
    } Fail:^(int code, NSString *failDescript) {
        
    }];
    
}

-(void)sendMessage:(NSString *)message OrImageUrl:(NSString *)imageUrl{

    NDSystemAddSuggestParams *params = [[NDSystemAddSuggestParams alloc] init];
    if (message) {
        params.content = message;
    }
    
    if (imageUrl) {
        params.picture = imageUrl;
    }
    params.app_id = @25;
    
    
    __weak __typeof(self) weakSelf = self;
    
    [NDSystemAPI systemAddSuggestWithParams:params completionBlockWithSuccess:^{
        
        Suggest *t_suggest = [[Suggest alloc] init];
        if (message) {
            t_suggest.content = message;
        }
        
        if (imageUrl) {
            t_suggest.picture = imageUrl;
        }
        
        t_suggest.reply = @"";
        t_suggest.time = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceNow]];
        
        [weakSelf.arr_data addObject:t_suggest];
        [weakSelf.tableView reloadData];
        [weakSelf tableViewScrollToBottom];
        _inputView.tv_input.text = nil;
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }];

}

-(void)uploadImage:(UIImage *)image{
    
    __weak __typeof(self) weakSelf = self;
    
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    _hud.progress = 0.0;
    _hud.mode = MBProgressHUDModeAnnularDeterminate;
    _hud.labelText = NSLocalizedString(@"Uploading", nil);
    [self.view addSubview:_hud];
    [_hud show:YES];
    //    _headImage = [_headImage imageByScaleForSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.width)];
    ImageFileInfo *fileInfo = [[ImageFileInfo alloc]initWithImage:image];
    
    [GCDQueue executeInGlobalQueue:^{
        
        [NDBaseAPI uploadImageFile:fileInfo.fileData name:fileInfo.name fileName:fileInfo.fileName mimeType:fileInfo.mimeType ProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            [[GCDQueue mainQueue] execute:^{
                _currentWriten += bytesWritten;
                _hud.progress = (float)_currentWriten/fileInfo.filesize;
            }];
        } successBlock:^(NSString *filepath) {
            [_hud removeFromSuperview];
            _hud = nil;
            
            filepath = [filepath stringByAppendingString:[NSString stringWithFormat:@"?imageWidth=%.1f&&imageHeight=%.1f",image.size.width,image.size.height]];
            
            [weakSelf sendMessage:nil OrImageUrl:filepath];
        } errorBlock:^(BOOL NotReachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _hud.labelText = NSLocalizedString(@"NetworkNotToForce", nil);
                _hud.mode = MBProgressHUDModeText;
                [_hud hide:YES afterDelay:1.5];
            });
        }];
    }];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_arr_data count] > 0) {
        _v_info.hidden = YES;
    }else{
        _v_info.hidden = NO;
    }
    
    return [_arr_data count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 判断indexPath对应cell的重用标示符，
    //NSString *reuseIdentifier = CellIdentifier;;
    
    // 从cell字典中取出重用标示符对应的cell。如果没有，就创建一个新的然后存储在字典里面。
    // 警告：不要调用table view的dequeueReusableCellWithIdentifier:方法，因为这会导致cell被创建了但是又未曾被tableView:cellForRowAtIndexPath:方法返回，会造成内存泄露！
    //ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];//[self.offscreenCells objectForKey:reuseIdentifier];
    
    ChatCell *cell = (ChatCell *)self.chatCell;
    
    // 用indexPath对应的数据内容来配置cell，例如：
    
    Suggest *t_suggest = _arr_data[indexPath.row];
    if (t_suggest) {
        cell.suggest = t_suggest;
    }

    // ...
    
    // 确保cell的布局约束被设置好了，因为它可能刚刚才被创建好。
    // 使用下面两行代码，前提是假设你已经在cell的updateConstraints方法中设置好了约束：
//    [cell setNeedsUpdateConstraints];
//    [cell updateConstraintsIfNeeded];
    
    // 将cell的宽度设置为和tableView的宽度一样宽。
    // 这点很重要。
    // 如果cell的高度取决于table view的宽度（例如，多行的UILabel通过单词换行等方式），
    // 那么这使得对于不同宽度的table view，我们都可以基于其宽度而得到cell的正确高度。
    // 但是，我们不需要在-[tableView:cellForRowAtIndexPath]方法中做相同的处理，
    // 因为，cell被用到table view中时，这是自动完成的。
    // 也要注意，一些情况下，cell的最终宽度可能不等于table view的宽度。
    // 例如当table view的右边显示了section index的时候，必须要减去这个宽度。
   // cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    
    // 触发cell的布局过程，会基于布局约束计算所有视图的frame。
    // （注意，你必须要在cell的-[layoutSubviews]方法中给多行的UILabel设置好preferredMaxLayoutWidth值；
    // 或者在下面2行代码前手动设置！）
    
//    if (cell.isMyMessage) {
//        cell.lb_myContent.preferredMaxLayoutWidth = 180;
//    }else{
//        cell.lb_otherContent.preferredMaxLayoutWidth = 180;
//    }
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // 得到cell的contentView需要的真实高度
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // 要为cell的分割线加上额外的1pt高度。因为分隔线是被加在cell底边和contentView底边之间的。
    if (!t_suggest.picture || t_suggest.picture.length == 0) {
        height += 5;
    }
    
    NSLog(@"height:::::::::::%f",height);
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 判断indexPath对应cell的重用标示符，
    // 取决于特定的布局需求（可能只有一个，也或者有多个）

    // 取出重用标示符对应的cell。
    // 注意，如果重用池(reuse pool)里面没有可用的cell，这个方法会初始化并返回一个全新的cell，
    // 因此不管怎样，此行代码过后，你会可以得到一个布局约束已经完全准备好，可以直接使用的cell。
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    // 用indexPath对应的数据内容来配置cell，例如：

    Suggest *t_suggest = _arr_data[indexPath.row];
    if (t_suggest) {
        cell.suggest = t_suggest;
    }

    // ...
    
    // 确保cell的布局约束被设置好了，因为它可能刚刚才被创建好。
    // 使用下面两行代码，前提是假设你已经在cell的updateConstraints方法中设置好了约束：
//    [cell setNeedsUpdateConstraints];
//    [cell updateConstraintsIfNeeded];
    
    // 如果你使用的是多行的UILabel，不要忘了，preferredMaxLayoutWidth需要设置正确。
    // 如果你没有在cell的-[layoutSubviews]方法中设置，就在这里设置。
    // 例如：
   
    return cell;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}


#pragma mark - scrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


#pragma mark - inputViewDelegate

- (void)inputView:(InputView *)inputView sendMessage:(NSString *)message{
    [self sendMessage:message OrImageUrl:nil];

}

- (void)choiceImage
{
    [ChooseView showChooseViewInBottomWithChooseList:@[NSLocalizedString(@"TakePhotos", nil),NSLocalizedString(@"FromMobilePhonePhotoAlbumsChoose", nil),NSLocalizedString(@"Cancle", nil)] andBackgroundColorList:@[RGB(255, 255, 255),RGB(255, 255, 255),RGB(255, 255, 255)] andTextColorList:@[RGB(30, 28, 39),RGB(30, 28, 39),RGB(30, 28, 39)] andChooseCompleteBlock:^(NSInteger row) {
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
        [ChooseView showChooseViewInMiddleWithTitle:NSLocalizedString(@"Tips", nil) andPrimitiveText:nil andChooseList:@[NSLocalizedString(@"YourCameraCan'tUse", nil)] andCancelButtonTitle:nil andConfirmButtonTitle:NSLocalizedString(@"Sure", nil) andChooseCompleteBlock:^(NSInteger row) {
        } andChooseCancleBlock:^(NSInteger row) {
        }];
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - imagePickerControllerDelegate

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage* image;
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImage:image];
        
    }];
    picker = nil;
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}


#pragma mark - Notifications

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (notification.name == UIKeyboardWillShowNotification) {
        _input_bottom.constant = - keyboardEndFrame.size.height;
    }else{
        _input_bottom.constant = 0;
    }
    
    [self.view layoutIfNeeded];

    [UIView commitAnimations];
    
}

-(void)chatImageTap{

    [self.view endEditing:YES];
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    if (_arr_data.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_arr_data.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - dealloc 

-(void)dealloc{
    [IQKeyboardManager sharedManager].enable = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"FeedBackVC dealloc");
    self.inputView.vc_super = nil;
    [self.inputView removeFromSuperview];
    self.inputView = nil;
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
