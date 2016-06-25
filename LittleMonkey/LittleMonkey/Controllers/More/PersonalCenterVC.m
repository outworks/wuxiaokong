//
//  PersonalCenterVC.m
//  HelloToy
//
//  Created by apple on 15/11/18.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "PersonalCenterVC.h"
#import "PersonalCenterCell.h"

#import "LoginHomeVC.h"
#import "UpdataPasswordVC.h"

#import "NDUserAPI.h"
#import "ChooseView.h"

#import "UIButton+Block.h"
#import "UIImageView+WebCache.h"
#import "UIImage+External.h"
#import "ImageFileInfo.h"
#import "NSObject+LKDBHelper.h"

#define NickName_MaxLen 16

@interface PersonalCenterVC ()<UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    NSInteger _currentWriten;
    MBProgressHUD *_hud;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *vNickName;
@property (weak, nonatomic) IBOutlet UIButton *btnCancle;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btndelete;
@property (weak, nonatomic) IBOutlet UITextField *tfNickName;
@property (weak, nonatomic) IBOutlet UIView *vCover;

@property(nonatomic,strong) UIImage *headImage;
@property(nonatomic,strong) User *user;


@end

@implementation PersonalCenterVC

- (void)viewDidLoad {
    
    [self.navigationController setDelegate:(id<UINavigationControllerDelegate> _Nullable)self];
    
    [super viewDidLoad];
    [self initView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _user = [ShareValue sharedShareValue].user;
}

- (void)initView
{
    self.title = NSLocalizedString(@"个人中心", nil);
    
    __weak PersonalCenterVC *weakSelf = self;
    
    //设置vPhoneLogin初始frame
    _vNickName.frame = CGRectMake(0, -_vNickName.frame.size.height, [UIScreen mainScreen].bounds.size.width, _vNickName.frame.size.height);
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:_vNickName];
    
    //取消按钮
    [_btnCancle handleClickEvent:UIControlEventTouchUpInside withClickBlick:^{
        weakSelf.tfNickName.text = @"";
        [weakSelf.tfNickName resignFirstResponder];
        [self updateNickNameViewHiddenAnimateIfNeed];
    }];
    
    //保存按钮
    [_btnSave handleClickEvent:UIControlEventTouchUpInside withClickBlick:^{
        [weakSelf.tfNickName resignFirstResponder];
        
        if ([weakSelf.tfNickName.text isEqualToString:@""]) {
            [ShowHUD showWarning:NSLocalizedString(@"请输入用户昵称", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
            
            return ;
        }
        
        if(![self validNickName:_tfNickName.text]){
            return;
        }
        
        if (_tfNickName.text.length > NickName_MaxLen) {
            [ShowHUD showError:NSLocalizedString(@"昵称长度太长", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
            return;
        }
        
        ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"保存中...", nil) configParameter:^(ShowHUD *config) {
            
        } inView:[[UIApplication sharedApplication] windows].firstObject];
        
        NDUserUpdateParams *params = [[NDUserUpdateParams alloc] init];
        params.nickname = weakSelf.tfNickName.text;
        params.icon = weakSelf.user.icon;
        [NDUserAPI userUpdateWithParams:params completionBlockWithSuccess:^(User *user) {
            
            [hud hide];
            [ShowHUD showSuccess:NSLocalizedString(@"修改成功", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
            
            [ShareValue sharedShareValue].user = user;
            weakSelf.user = [ShareValue sharedShareValue].user;
            
            [weakSelf updateNickNameViewHiddenAnimateIfNeed];
            
            [weakSelf.tableView reloadData];
            
//            [[GCDQueue mainQueue] execute:^{
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//            } afterDelay:1.5f * NSEC_PER_SEC];
            
        } Fail:^(int code, NSString *failDescript) {
            
            [hud hide];
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
            
        }];
    }];
    
    //删除按钮
    [_btndelete handleClickEvent:UIControlEventTouchUpInside withClickBlick:^{
        weakSelf.tfNickName.text = @"";
    }];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section != 2) {
        
        return 10;
        
    }else{
        
        return 0;
        
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 2;
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalCenterCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"PersonalCenterCell" bundle:nil] forCellReuseIdentifier:@"PersonalCenterCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalCenterCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    switch (indexPath.section) {
            
        case 0:{
            
            cell.lb_title.hidden = YES;
            cell.imageV_arrow.hidden = NO;
            cell.lb_content.hidden = NO;
            cell.lb_content.text = @"头像";
            cell.imageV_icon.hidden = NO;
            [cell.imageV_icon sd_setImageWithURL:[NSURL URLWithString:_user.icon] placeholderImage:[UIImage imageNamed: @"icon_defaultuser"]];
            
            break;
        }
        case 1:{
            
            cell.lb_title.hidden = NO;
            cell.lb_content.hidden = NO;
            cell.imageV_icon.hidden = YES;
        
            if (indexPath.row == 0) {
                
                cell.imageV_arrow.hidden = NO;
                cell.lb_title.text = @"昵称";
                cell.lb_content.text = _user.nickname;
                
            }else if(indexPath.row == 1){
            
                cell.imageV_arrow.hidden = YES;
                cell.lb_title.text = @"悟小空号";
                cell.lb_content.text = [_user.user_id stringValue];
                
            }
            
            break;
        }
        case 2:{
            
            cell.lb_title.hidden = NO;
            cell.lb_content.hidden = YES;
            cell.imageV_icon.hidden = YES;
            cell.imageV_arrow.hidden = YES;
            
            if (indexPath.row == 0) {
            
                cell.lb_title.text = @"修改密码";
                
            }else if(indexPath.row == 1){
                
                cell.lb_title.text = @"退出登录";
                
            }
        
            break;
        }
        default:
            break;
    }
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 80;
    } else {
        return 50;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
            
        case 0:{
            
            [ChooseView showChooseViewInBottomWithChooseList:@[NSLocalizedString(@"拍照", nil),NSLocalizedString(@"从手机相册选择", nil),NSLocalizedString(@"取消", nil)] andBackgroundColorList:@[RGB(255, 255, 255),RGB(255, 255, 255),RGB(255, 255, 255)] andTextColorList:@[RGB(30, 28, 39),RGB(30, 28, 39),RGB(30, 28, 39)] andChooseCompleteBlock:^(NSInteger row) {
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
        
            
            break;
        }
        case 1:{
            
            if (indexPath.row == 0) {
                
                _tfNickName.text = _user.nickname;
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
        
            break;
        }
        case 2:{
            
            if (indexPath.row == 0) {
                
                UpdataPasswordVC *vc = [[UpdataPasswordVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if (indexPath.row == 1){
                
                [self handleQuitDidClick:nil];
            }
            
            
            break;
        }
        default:
            break;
    }

}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView)
    {
        if (scrollView.contentOffset.y < 0) {
            CGPoint position = CGPointMake(0, 0);
            [scrollView setContentOffset:position animated:NO];
            return;
        }
    }
}

#pragma mark - ButtonAction

/*************** 用户退出登陆事件 *****************/

- (IBAction)handleQuitDidClick:(id)sender {
    
    [ChooseView showChooseViewInMiddleWithTitle:PROGRAMNAME andPrimitiveText:nil andChooseList:@[NSLocalizedString(@"是否退出登录？", nil)] andCancelButtonTitle:NSLocalizedString(@"取消", nil) andConfirmButtonTitle:NSLocalizedString(@"退出", nil) andChooseCompleteBlock:^(NSInteger row) {
        
        [ShowHUD showSuccess:NSLocalizedString(@"退出成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.0f inView:ApplicationDelegate.window];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFCATION_LOGOUT object:nil];
        
    } andChooseCancleBlock:^(NSInteger row) {
        
    }];
    
}

/*************** 点击蒙层事件 *****************/

- (IBAction)handleCoverClick:(id)sender {
    
    self.tfNickName.text = @"";
    
    [self.tfNickName resignFirstResponder];
    
    [self updateNickNameViewHiddenAnimateIfNeed];
}

#pragma mark - Functions

/*************** 判断用户名格式正确性 *****************/

- (BOOL)validNickName:(NSString *)nickName
{
    NSString *nickNameRegex = @"^[a-zA-Z0-9_\u4e00-\u9fa5]+$";
    NSPredicate *emailChecker = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nickNameRegex];
    if(![emailChecker evaluateWithObject:nickName])
    {
        [ShowHUD showError:NSLocalizedString(@"昵称格式出错", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return NO;
    }
    
    return YES;
}


/*************** 开始拍照 *****************/


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

/*************** 打开本地相册 *****************/
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

/*************** 上传用户ICON到服务器 *****************/

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
            [self updateUserIcon:filepath];
        } errorBlock:^(BOOL NotReachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _hud.labelText = NSLocalizedString(@"网络不给力", nil);
                _hud.mode = MBProgressHUDModeText;
                [_hud hide:YES afterDelay:1.5];
            });
        }];
    }];
}

/*************** 修改用户图片API *****************/

-(void)updateUserIcon:(NSString *)filepath
{
    __weak typeof(self) weakSelf = self;
    
    NDUserUpdateParams *params = [[NDUserUpdateParams alloc] init];
    params.icon = filepath;
    params.nickname = _user.nickname;
    [NDUserAPI userUpdateWithParams:params completionBlockWithSuccess:^(User *user) {
        
        [ShowHUD showSuccess:NSLocalizedString(@"更新成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
        [ShareValue sharedShareValue].user = user;
        weakSelf.user = [ShareValue sharedShareValue].user;
        [weakSelf.tableView reloadData];
        
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showSuccess:NSLocalizedString(@"更新失败", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }];
    
}

/*************** 修改用户名视图消失的动画 *****************/

- (void)updateNickNameViewHiddenAnimateIfNeed
{
    __weak PersonalCenterVC *weakSelf = self;
    //vNickName消失
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.vCover.hidden = YES;
        CGRect frame = weakSelf.vNickName.frame;
        frame.origin.y = -frame.size.height;
        weakSelf.vNickName.frame = frame;
    }];
    
}


#pragma mark - UIImagePickerControllerDelegate


/*************** 当选择一张图片后进入这里 *****************/

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

#pragma mark - navigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[self class]]) {
        self.navigationController.navigationBarHidden = NO;
    }
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    NSLog(@"PersonalCenterVC dealloc");
    [_vNickName removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController setDelegate:nil];
    
}


@end
