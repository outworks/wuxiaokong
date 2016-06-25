//
//  ChildInfoSetVC.m
//  HelloToy
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "ChildInfoSetVC.h"
#import "GroupChatSettingCell.h"

#import "NDToyAPI.h"
#import "NDGroupAPI.h"

#import "CFPickerView.h"
#import "LKDBHelper.h"

#import "ChooseView.h"
#import "ImageFileInfo.h"
#import "UIImageView+WebCache.h"
#import "UIImage+External.h"

#define NickName_MaxLen 16

@interface ChildInfoSetVC ()<UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *_aryData;
    NSIndexPath *_clickCellIndexPath;//记录点击的cell
    UIImagePickerController *_picker;
    NSInteger _currentWriten;
    MBProgressHUD *_hud;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *vNickName;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UIView *vCover;
@property (strong,nonatomic) CFPickerView *datePicker;
@property (strong,nonatomic) NSDate *date;

@property (strong,nonatomic) NSString *nameString;
@property (strong,nonatomic) NSString *sexString;
@property (strong,nonatomic) NSString *birthdayString;

@property(nonatomic,strong) UIImage *headImage;         //选中的头部视图
@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;

@property (assign,nonatomic) BOOL isChange;

- (IBAction)handleCancelDidClick:(id)sender;
- (IBAction)handleSaveDidClick:(id)sender;
- (IBAction)handleDeleteDidClick:(id)sender;

@end

@implementation ChildInfoSetVC

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"%@",_toy);
    [self initData];
    [self initView];
}

- (void)initData
{
    self.title = NSLocalizedString(@"设置宝宝信息", nil);
    _aryData = @[NSLocalizedString(@"名字", nil),NSLocalizedString(@"性别", nil),NSLocalizedString(@"生日", nil)];
    _isChange = NO;
    _nameString = _toy.nickname;
    switch (_toy.gender.intValue) {
        case 1:
            _sexString = NSLocalizedString(@"男", nil);
            break;
        case 2:
            _sexString = NSLocalizedString(@"女", nil);
            break;
        default:
            _sexString = NSLocalizedString(@"男", nil);
            break;
    }
}

- (void)initView
{
    [self showRightBarButtonItemWithTitle:NSLocalizedString(@"完成", nil) target:self action:@selector(finishAction:)];
    
    //设置vPhoneLogin初始frame
    _vNickName.frame = CGRectMake(0, -_vNickName.frame.size.height, [UIScreen mainScreen].bounds.size.width, _vNickName.frame.size.height);
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:_vNickName];
    
    _imageV_icon.layer.cornerRadius = 54/2;
    _imageV_icon.layer.masksToBounds = YES;
    
    if ([ShareValue sharedShareValue].toyDetail.icon.length == 0) {
        
        [_imageV_icon setImage:[UIImage imageNamed:@"icon_defaultuser"]];
        
    }else{
        
        [_imageV_icon sd_setImageWithURL:[NSURL URLWithString:[ShareValue sharedShareValue].toyDetail.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonActions

- (void)finishAction:(id)sender
{
    if ([_nameString isEqualToString:@""]) {
        [ShowHUD showWarning:NSLocalizedString(@"请输入宝宝名字", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return ;
    }

    if ([_birthdayString isEqualToString:@""]) {
        [ShowHUD showWarning:NSLocalizedString(@"请输入宝宝生日", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return ;
    }
    
    NSArray *arr_toy = [Toy searchWithWhere:nil orderBy:nil offset:0 count:0];
    
    for (Toy *t_toy in arr_toy) {
        if (t_toy) {
            if ([t_toy.nickname isEqualToString:_tfName.text] && ![t_toy.toy_id isEqualToNumber:_toy.toy_id]) {
                [ShowHUD showError:NSLocalizedString(@"不允许设置同名玩具", nil) configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:self.view];
                return;
            }
        }
    }
    
    UIButton *button = (UIButton *)sender;
    button.enabled = NO;
    
    ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"保存中...", nil) configParameter:^(ShowHUD *config) {
        
    } inView:[[UIApplication sharedApplication] windows].firstObject];
    
    NDToyUpdateParams *params = [[NDToyUpdateParams alloc]init];
    params.toy_id = _toy.toy_id;
    params.nickname = _nameString;
    if ([_sexString isEqualToString:@""]) {
        _toy.gender = @1;
    }
    params.gender = _toy.gender;
    params.birthday = _toy.birthday;
    params.icon = _toy.icon;
    [NDToyAPI toyUpdateWithParams:params completionBlockWithSuccess:^(Toy *data) {
        [hud hide];
        [ShowHUD showSuccess:NSLocalizedString(@"保存成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
        
        Toy *t_toy = (Toy *)data;
        [ShareValue sharedShareValue].toyDetail = t_toy;
        _toy = [ShareValue sharedShareValue].toyDetail;
        NDGroupDetailParams *params = [[NDGroupDetailParams alloc]init];
        [NDGroupAPI groupDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
            if (data.count != 0) {
                GroupDetail *groupDetail = data[0];
                [groupDetail save];
                [ShareFun enterGroup:groupDetail];
            }
            if (_isBindSetting) {
                
               [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOADTOYLISY object:nil userInfo:nil];
                
            } else {
                
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOADTOYLISY object:@{@"reload":@1} userInfo:nil];
                
            }
        } Fail:^(int code, NSString *failDescript) {
            button.enabled = YES;
            [hud hide];
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
        }];
        NSLog(@"%@",[ShareValue sharedShareValue].toyDetail);
    } Fail:^(int code, NSString *failDescript) {
        button.enabled = YES;
        [hud hide];
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
    }];
}

/****************** 更新玩具Icon头像 *******************/

- (IBAction)toyIcon:(id)sender{
    
    [ChooseView showChooseViewInBottomWithChooseList:@[NSLocalizedString(@"拍照", nil),NSLocalizedString(@"从手机相册选取", nil),NSLocalizedString(@"取消", nil)] andBackgroundColorList:@[RGB(255, 255, 255),RGB(255, 255, 255),RGB(255, 255, 255)] andTextColorList:@[RGB(30, 28, 39),RGB(30, 28, 39),RGB(30, 28, 39)] andChooseCompleteBlock:^(NSInteger row) {
        switch (row) {
            case 0:
            {
                [self takePhoto];
            }
                break;
            case 1:
            {
                [self localPhoto];
            }
                break;
            default:
                break;
        }
    } andChooseCancleBlock:^(NSInteger row) {
    } andTitle:nil andPrimitiveText:nil];
}

-(void)handleBtnBackClicked{

    if (_isChange) {
        
        UIAlertView *t_alert = [[UIAlertView alloc] initWithTitle:PROGRAMNAME message:@"你的信息已经修改，是否保存" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [t_alert show];
        
    }else{
        [super handleBtnBackClicked];
    }

}


- (IBAction)handleCancelDidClick:(id)sender {
    self.tfName.text = @"";
    [self.tfName resignFirstResponder];
    [self updateNickNameViewHiddenAnimateIfNeed];
}

- (IBAction)handleSaveDidClick:(id)sender {
    //设置昵称只允许使用中文、拼音、数字
    if(![self validNickName:_tfName.text]){
        return;
    }
    if (_tfName.text.length > NickName_MaxLen) {
        [ShowHUD showError:NSLocalizedString(@"昵称超过16位咯~", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
        return;
    }
    
    GroupChatSettingCell *cell = (GroupChatSettingCell *)[_tableView cellForRowAtIndexPath:_clickCellIndexPath];
    cell.lbRight.text = _tfName.text;
    _isChange = YES;
    _nameString = _tfName.text;
    [self.tfName resignFirstResponder];
    [self updateNickNameViewHiddenAnimateIfNeed];
}

- (IBAction)handleDeleteDidClick:(id)sender {
    _tfName.text = @"";
}

//点击蒙层
- (IBAction)handleCoverClick:(id)sender {
    self.tfName.text = @"";
    [self.tfName resignFirstResponder];
    [self updateNickNameViewHiddenAnimateIfNeed];
}

#pragma mark - Functions

/**
 *  父类方法，用于控制是否显示返回按钮，默认yes
 */
- (BOOL)canBack{
    return !_isBindSetting;
}

//修改群名视图消失的动画
- (void)updateNickNameViewHiddenAnimateIfNeed
{
    __weak ChildInfoSetVC *weakSelf = self;
    //vNickName消失
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.vCover.hidden = YES;
        CGRect frame = weakSelf.vNickName.frame;
        frame.origin.y = -frame.size.height;
        weakSelf.vNickName.frame = frame;
    }];
    
}

//验证昵称是否合法
- (BOOL)validNickName:(NSString *)nickName
{
    NSString *nickNameRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";
    NSPredicate *emailChecker = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nickNameRegex];
    if(![emailChecker evaluateWithObject:nickName])
    {
        [ShowHUD showError:NSLocalizedString(@"昵称格式不正确", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark private methods

/****************** 开始拍照 *******************/

-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.allowsEditing = NO;  //设置拍照后的图片可被编辑
        _picker.sourceType = sourceType;
        [self presentViewController:_picker animated:YES completion:nil];
        
    }else{
        
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

/****************** 打开本地相册 *******************/

-(void)localPhoto
{
    _picker = [[UIImagePickerController alloc] init];
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker.delegate = self;
    //设置选择后的图片可被编辑
    _picker.allowsEditing = NO;
    [self presentViewController:_picker animated:YES completion:nil];
    
}

/****************** 上传图片到文件服务器 *******************/

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
            [self updateToyIcon:filepath];
            
        } errorBlock:^(BOOL NotReachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _hud.labelText = NSLocalizedString(@"上传失败...", nil);
                _hud.mode = MBProgressHUDModeText;
                [_hud hide:YES afterDelay:1.5];
                
            });
        }];
    }];
    
}

/****************** 更新玩具Icon头像 *******************/

-(void)updateToyIcon:(NSString *)filepath{
    
    NDToyUpdateParams *params = [[NDToyUpdateParams alloc] init];
    
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.nickname = [ShareValue sharedShareValue].toyDetail.nickname;
    params.icon = filepath;
    
    [NDToyAPI toyUpdateWithParams:params completionBlockWithSuccess:^(Toy *data) {
        
        [ShowHUD showSuccess:NSLocalizedString(@"更新成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        [ShareValue sharedShareValue].toyDetail = data;
        _toy = [ShareValue sharedShareValue].toyDetail;
        for (Toy *toy in [ShareValue sharedShareValue].groupDetail.toy_list) {
            if ([toy isEqual:data]) {
                toy.nickname = data.nickname;
                toy.icon = data.icon;
            }
        }
        
        [_imageV_icon sd_setImageWithURL:[NSURL URLWithString:[ShareValue sharedShareValue].toyDetail.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        
        //[self.tb_content reloadData];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOADTOYLISY object:@{@"reload":@1}];
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }];
    
}




#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupChatSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GROUPCHATSETTINGCELL"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"GroupChatSettingCell" bundle:nil] forCellReuseIdentifier:@"GROUPCHATSETTINGCELL"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"GROUPCHATSETTINGCELL"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.ivHeader.hidden = YES;
    cell.lbLeft.text = _aryData[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
           cell.lbRight.text = _toy.nickname;
        }
            break;
        case 1:
        {
            cell.lbRight.text = _sexString;
        }
            break;
        case 2:
        {
            cell.lbRight.text = _toy.birthday;
            cell.vLine.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupChatSettingCell *cell = (GroupChatSettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    _clickCellIndexPath = indexPath;
    if (indexPath.row == 0) {
        self.lbTitle.text = cell.lbLeft.text;
        _tfName.text = cell.lbRight.text;
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
                                 [_tfName becomeFirstResponder];
                             } completion:^(BOOL finished) {
                             }];
                             
                         } completion:^(BOOL finished) {
                         }];

    } else if (indexPath.row == 1) {
        NSArray *array = @[NSLocalizedString(@"男", nil),NSLocalizedString(@"女", nil)];
        CFPickerView *pickerView = [[CFPickerView alloc] initPickviewWithArray:array Title:NSLocalizedString(@"性别", nil) DidSelect:^(NSString *strRet) {
            if(strRet.length > 0){
                _sexString = strRet;
                _isChange = YES;
                cell.lbRight.text = _sexString;
                if ([strRet isEqualToString:NSLocalizedString(@"男", nil)]) {
                    _toy.gender = @1;
                } else if ([strRet isEqualToString:NSLocalizedString(@"女", nil)]) {
                    _toy.gender = @2;
                } else {
                    _toy.gender = @1;//默认为男
                }
            }
        }];
        [pickerView show];

    } else if (indexPath.row == 2) {
        NSString *birthday = [NSString stringWithFormat:@"%@ 08:00:00",cell.lbRight.text];
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* date = [formater dateFromString:birthday];
        NSLog(@"%@", date);
        
        CFPickerView *pickerView = [[CFPickerView alloc]initDatePickWithDate:date Title:NSLocalizedString(@"生日", nil) datePickerMode:UIDatePickerModeDate DidSelect:^(NSString *strRet) {
            _birthdayString = [strRet substringToIndex:10];
            cell.lbRight.text = _birthdayString;
            _toy.birthday = _birthdayString;
            _isChange = YES;
//            NSLog(@"%@",[strRet substringToIndex:10]);
        }];
        [pickerView show];
    }
}

#pragma mark -
#pragma mark imagePickerControllerDelegate

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
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
    
    [_picker dismissViewControllerAnimated:YES completion:^{
        
        [self uploadImage];
        
    }];
    
    _picker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    _picker = nil;
}

#pragma mark - UIAlertView Delegate 


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        [self finishAction:nil];
    }else{
        [super handleBtnBackClicked];
    }
    

}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == _tfName){
        if (string.length == 0) {
            return YES;
        }
        return textField.text.length<NickName_MaxLen;
    }
    return YES;
}

#pragma mark - Dealloc

- (void)dealloc
{
    [_vNickName removeFromSuperview];
     NSLog(@"ChildInfoSetVC dealloc");
}


@end
