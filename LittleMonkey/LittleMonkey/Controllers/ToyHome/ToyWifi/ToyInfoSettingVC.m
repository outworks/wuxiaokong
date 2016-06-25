//
//  ToyInfoSettingVC.m
//  LittleMonkey
//
//  Created by Hcat on 16/6/5.
//  Copyright © 2016年 CivetCatsTeam. All rights reserved.
//

#import "ToyInfoSettingVC.h"

#import "LKDBHelper.h"
#import "NDToyAPI.h"
#import "CFPickerView.h"


#import "ChooseView.h"
#import "ImageFileInfo.h"
#import "UIImageView+WebCache.h"
#import "UIImage+External.h"
#import <SDWebImage/UIButton+WebCache.h>

#define NickName_MaxLen 16

@interface ToyInfoSettingVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *_picker;
    NSInteger _currentWriten;
    MBProgressHUD *_hud;
}


@property (weak, nonatomic) IBOutlet UIButton *btn_icon;

@property (weak, nonatomic) IBOutlet UITextField *tf_nickName;
@property (weak, nonatomic) IBOutlet UITextField *tf_sex;
@property (weak, nonatomic) IBOutlet UITextField *tf_birthday;

@property (weak, nonatomic) IBOutlet UILabel *lb_nickName;
@property (weak, nonatomic) IBOutlet UILabel *lb_sex;
@property (weak, nonatomic) IBOutlet UILabel *lb_birthday;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_nickName;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_sex;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_birthday;

@property (strong,nonatomic) NSString *nameString;
@property (strong,nonatomic) NSString *sexString;
@property (strong,nonatomic) NSString *birthdayString;

@property(nonatomic,strong) UIImage *headImage;         //选中的头部视图

@end

@implementation ToyInfoSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initData];
    [self initView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}

#pragma mark - privateMethods 

- (void)initData
{

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
    _birthdayString = _toy.birthday;
    
}

- (void)initView
{
    _btn_icon.layer.cornerRadius = 68/2;
    _btn_icon.layer.masksToBounds = YES;
    
    [_btn_icon sd_setImageWithURL:[NSURL URLWithString:_toy.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
    
    _tf_nickName.text = _nameString;
    _tf_sex.text = _sexString;
    _tf_birthday.text = _birthdayString;
    
}

#pragma mark - function

//验证昵称是否合法
- (BOOL)validNickName:(NSString *)nickName
{
    NSString *nickNameRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";
    NSPredicate *emailChecker = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nickNameRegex];
    if(![emailChecker evaluateWithObject:nickName])
    {
        [ShowHUD showError:NSLocalizedString(@"昵称格式出错", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
        return NO;
    }
    
    return YES;
}


- (void)handleSexAction{

    NSArray *array = @[NSLocalizedString(@"男", nil),NSLocalizedString(@"女", nil)];
    CFPickerView *pickerView = [[CFPickerView alloc] initPickviewWithArray:array Title:NSLocalizedString(@"性别", nil) DidSelect:^(NSString *strRet) {
        if(strRet.length > 0){
            _sexString = strRet;
            _tf_sex.text = _sexString;
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

}

- (void)handleBirthdatAction{

    NSString *birthday = [NSString stringWithFormat:@"%@ 08:00:00",_toy.birthday];
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [formater dateFromString:birthday];
    NSLog(@"%@", date);
    
    CFPickerView *pickerView = [[CFPickerView alloc]initDatePickWithDate:date Title:NSLocalizedString(@"生日时间", nil) datePickerMode:UIDatePickerModeDate DidSelect:^(NSString *strRet) {
        _birthdayString = [strRet substringToIndex:10];
        _tf_birthday.text = _birthdayString;
        _toy.birthday = _birthdayString;
    }];
    [pickerView show];

}


#pragma mark - 设置完玩具之后的事件处理

- (void)handleBingToyAction{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SETTOYINFOSUCESS object:nil];

}


#pragma mark - buttonAction

- (IBAction)btnFinishAction:(id)sender {
    
    if ([_tf_nickName.text isEqualToString:@""]) {
        [ShowHUD showWarning:NSLocalizedString(@"请输入宝宝昵称", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return ;
    }
    
    if ([_tf_birthday.text isEqualToString:@""]) {
        [ShowHUD showWarning:NSLocalizedString(@"请输入宝宝生日", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return ;
    }
    
    NSArray *arr_toy = [Toy searchWithWhere:nil orderBy:nil offset:0 count:0];
    
    for (Toy *t_toy in arr_toy) {
        if (t_toy) {
            if ([t_toy.nickname isEqualToString:_tf_nickName.text] && ![t_toy.toy_id isEqualToNumber:_toy.toy_id]) {
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
    params.nickname = _toy.nickname;
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
        
         NSLog(@"当前玩具昵称:%@",[ShareValue sharedShareValue].toyDetail.nickname);
        
        [self handleBingToyAction];
       
        button.enabled = YES;
       
    } Fail:^(int code, NSString *failDescript) {
        button.enabled = YES;
        [hud hide];
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
    }];
    
}

/****************** 更新玩具Icon头像 *******************/

- (IBAction)btntoyIconAction:(id)sender{
    
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
    
    __weak typeof(self) weakSelf = self;
    
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
            
            weakSelf.toy.icon = filepath;
            [weakSelf.btn_icon sd_setImageWithURL:[NSURL URLWithString:weakSelf.toy.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
            
        } errorBlock:^(BOOL NotReachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _hud.labelText = NSLocalizedString(@"网络不给力", nil);
                _hud.mode = MBProgressHUDModeText;
                [_hud hide:YES afterDelay:1.5];
                
            });
        }];
    }];
    
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

#pragma mark - UITextFieldNotifition

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

   return YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField*)textField{
    
    if (textField == _tf_nickName) {
        
        [_imageV_nickName setBackgroundColor:UIColorFromRGB(0xff6948)];
        [_imageV_sex setBackgroundColor:RGB(151, 151, 151)];
        [_imageV_birthday setBackgroundColor:RGB(151, 151, 151)];

        [_lb_nickName setTextColor:[UIColor blackColor]];
        [_lb_sex setTextColor:RGB(151, 151, 151)];
        [_lb_birthday setTextColor:RGB(151, 151, 151)];
        
    }else if (textField == _tf_sex) {
        
        [self.tf_sex becomeFirstResponder];
        
        [_imageV_nickName setBackgroundColor:RGB(151, 151, 151)];
        [_imageV_sex setBackgroundColor:UIColorFromRGB(0xff6948)];
        [_imageV_birthday setBackgroundColor:RGB(151, 151, 151)];
        
        [_lb_nickName setTextColor:RGB(151, 151, 151)];
        [_lb_sex setTextColor:[UIColor blackColor]];
        [_lb_birthday setTextColor:RGB(151, 151, 151)];
       
        [self handleSexAction];
        
        [self.tf_sex resignFirstResponder];
        
    }else if (textField == _tf_birthday) {
        
        [self.tf_birthday becomeFirstResponder];
    
        [_imageV_nickName setBackgroundColor:RGB(151, 151, 151)];
        [_imageV_sex setBackgroundColor:RGB(151, 151, 151)];
        [_imageV_birthday setBackgroundColor:UIColorFromRGB(0xff6948)];
        
        [_lb_nickName setTextColor:RGB(151, 151, 151)];
        [_lb_sex setTextColor:RGB(151, 151, 151)];
        [_lb_birthday setTextColor:[UIColor blackColor]];
        
        [self handleBirthdatAction];
        
        [self.tf_birthday resignFirstResponder];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [_imageV_nickName setBackgroundColor:RGB(151, 151, 151)];
    [_imageV_sex setBackgroundColor:RGB(151, 151, 151)];
    [_imageV_birthday setBackgroundColor:RGB(151, 151, 151)];
    
    [_lb_nickName setTextColor:RGB(151, 151, 151)];
    [_lb_sex setTextColor:RGB(151, 151, 151)];
    [_lb_birthday setTextColor:RGB(151, 151, 151)];
    
    [_tf_nickName resignFirstResponder];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == _tf_nickName){
        if (string.length == 0) {
            return YES;
        }
        return textField.text.length<NickName_MaxLen;
    }
    return YES;
}


#pragma mark - dealloc

- (void)dealloc{

    NSLog(@"ToyInfoSettingVC dealloc");

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
