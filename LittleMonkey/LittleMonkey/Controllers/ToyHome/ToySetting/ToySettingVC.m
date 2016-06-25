//
//  ToySettingVC.m
//  HelloToy
//
//  Created by nd on 15/11/2.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "ToySettingVC.h"
#import "ToySettingCell.h"

#import "ImageFileInfo.h"

#import "ToyModelVC.h"
#import "ToyThemeVC.h"
#import "TimerListVCL.h"
#import "ToyWifiFirstVC.h"
#import "ToyDeviceChangeVC.h"
#import "ToyNightModelVC.h"
#import "UIImageView+WebCache.h"
#import "UIImage+External.h"
#import "ChooseView.h"
#import "ChildInfoSetVC.h"

#import "Setting.h"
#import "NDToyAPI.h"
#import "ToyContactVC.h"
#import "TimeTool.h"
#import "ToyInfoVC.h"

#import "PureLayout.h"

@interface ToySettingVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIImagePickerController *_picker;
    NSInteger _currentWriten;
    MBProgressHUD *_hud;
}


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutBottomViewHeight;

@property (weak, nonatomic) IBOutlet UITableView *tb_content;

@property (weak, nonatomic) IBOutlet UIView *v_bottom;
@property (weak, nonatomic) IBOutlet UIButton *btnFireBind; //解除绑定按钮


@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;
@property (weak, nonatomic) IBOutlet UILabel *lb_toyName;
@property (strong, nonatomic) IBOutlet UIView *v_top;

@property (weak, nonatomic) IBOutlet UIButton *btn_first;
@property (weak, nonatomic) IBOutlet UIButton *btn_secend;
@property (weak, nonatomic) IBOutlet UIButton *btn_third;
@property (weak, nonatomic) IBOutlet UIButton *btn_fourth;


@property(nonatomic,strong) UIImage *headImage;         //选中的头部视图
@property(nonatomic,strong) Setting *setting;           //夜间模式



@end

@implementation ToySettingVC

#pragma mark -
#pragma mark viewCycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    [self initUI];
    
    if (!_setting) {
        
        __weak typeof(self) weakSelf = self;
        NDToySettingParams *params = [[NDToySettingParams alloc] init];
        
        params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
        params.keys = @"nightMode";
        
        [NDToyAPI toySettinWithParams:params completionBlockWithSuccess:^(NSArray *data) {
            
            if (data.count > 0 ) {
                
                weakSelf.setting = data[0];
            
            }
            
        } Fail:^(int code, NSString *failDescript) {
            
            NSLog(@"请求夜间模式数据失败");
            
        }];

    }
   
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    _lb_toyName.text = [ShareValue sharedShareValue].toyDetail.nickname;
    [_imageV_icon sd_setImageWithURL:[NSURL URLWithString:[ShareValue sharedShareValue].toyDetail.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];


}

#pragma mark -
#pragma mark - init

- (void)initUI{

    self.navigationItem.title = NSLocalizedString(@"玩具设置", nil);
    
    if (![ShareFun isGroupOwner]) {
        _layoutBottomViewHeight.constant = 0;
        _btnFireBind.hidden = YES;
    } else {
        _layoutBottomViewHeight.constant = 77;
        _btnFireBind.hidden = NO;
    }
    
    _imageV_icon.layer.cornerRadius = 54/2;
    _imageV_icon.layer.masksToBounds = YES;
    self.imageV_icon.layer.borderWidth = 0.5f;
    self.imageV_icon.layer.borderColor = [UIColorFromRGB(0xff6948) CGColor];
    
    self.v_top.translatesAutoresizingMaskIntoConstraints = YES;
    self.tb_content.tableHeaderView = _v_top;
    
    if (IOSVersion > 8.0) {
    [_v_top configureForAutoLayout];
    [_v_top autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
    [_v_top autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH];
    [_v_top autoSetDimension:ALDimensionHeight toSize:255.f];
    
    NSArray *arr_view = [[NSArray alloc] initWithObjects:_btn_first,_btn_secend,_btn_third,_btn_fourth, nil];
    [arr_view autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:20.0 insetSpacing:YES matchedSizes:YES];

    }else{
    
    }


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
                
                _hud.labelText = NSLocalizedString(@"网络不给力", nil);
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
        
        for (Toy *toy in [ShareValue sharedShareValue].groupDetail.toy_list) {
            
            if ([toy isEqual:data]) {
                
                toy.nickname = data.nickname;
                toy.icon = data.icon;
            }
        }
        
        [_imageV_icon sd_setImageWithURL:[NSURL URLWithString:[ShareValue sharedShareValue].toyDetail.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOADTOYLISY object:@{@"reload":@1}];
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }];
    
}

#pragma mark -
#pragma mark buttonAction

/****************** 更新玩具Icon头像 *******************/

- (IBAction)toyIcon:(id)sender{
    
    if (![ShareFun isGroupOwner]) {
        
        [ShowHUD showTextOnly:@"您不是群主" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        return;
    }
    
    [ChooseView showChooseViewInBottomWithChooseList:@[NSLocalizedString(@"拍照", nil),NSLocalizedString(@"从手机相册选择", nil),NSLocalizedString(@"取消", nil)] andBackgroundColorList:@[RGB(255, 255, 255),RGB(255, 255, 255),RGB(255, 255, 255)] andTextColorList:@[RGB(30, 28, 39),RGB(30, 28, 39),RGB(30, 28, 39)] andChooseCompleteBlock:^(NSInteger row) {
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

/****************** 更新儿童信息 *******************/

- (IBAction)toyInfo:(id)sender{
    
    if (![ShareFun isGroupOwner]) {
        
        [ShowHUD showTextOnly:@"您不是群主" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        return;
    }
    
    ChildInfoSetVC *childInfoSetVC = [[ChildInfoSetVC alloc]init];
    childInfoSetVC.toy = [ShareValue sharedShareValue].toyDetail;
    childInfoSetVC.isBindSetting = NO;
    [self.navigationController pushViewController:childInfoSetVC animated:YES];
}



/****************** 玩具wifi配置 *******************/

- (IBAction)toyWifiConnect:(id)sender{
    
    ToyWifiFirstVC *t_vc = [[ToyWifiFirstVC alloc] init];
    t_vc.type = ToyWifiSetType;
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

/****************** 配置调节 *******************/

- (IBAction)toyDeviceChange:(id)sender{

    ToyDeviceChangeVC *t_vc = [[ToyDeviceChangeVC alloc] init];
    t_vc.toy = [ShareValue sharedShareValue].toyDetail;
    [self.navigationController pushViewController:t_vc animated:YES];


}

/****************** 玩具闹铃 *******************/

- (IBAction)toyAlarm:(id)sender{
    
    if (![ShareFun isGroupOwner]) {
        
        [ShowHUD showTextOnly:@"您不是群主" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        return;
    }
    
    TimerListVCL *t_vc = [[TimerListVCL alloc] init];
    t_vc.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

/****************** 玩具模式切换 *******************/

- (IBAction)toyChangeModel:(id)sender{

    ToyModelVC *vc = [[ToyModelVC alloc] init];
    vc.toy = [ShareValue sharedShareValue].toyDetail;
    [self.navigationController pushViewController:vc animated:YES];
    
}

/****************** 玩具音效配置 *******************/

- (IBAction)toyChangeTheme:(id)sender{
    
    if (![ShareFun isGroupOwner]) {
        
        [ShowHUD showTextOnly:@"您不是群主" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        return;
    }
    
    ToyThemeVC *t_vc = [[ToyThemeVC alloc] init];
    t_vc.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

/****************** 玩具夜间模式配置 *******************/

- (IBAction)toyNightModel:(id)sender{
    
    if (![ShareFun isGroupOwner]) {
        
        [ShowHUD showTextOnly:@"您不是群主" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
     
        return;
    }
    
    
    ToyNightModelVC *t_vc = [[ToyNightModelVC alloc] init];
    if (_setting) {
        t_vc.setting = _setting;
    }
    t_vc.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    t_vc.SaveBlock = ^(Setting *setting) {
      
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:t_vc animated:YES];
    
}


/****************** 玩具解除绑定 *******************/

- (IBAction)toyUnBingAction:(id)sender {
    
    UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:PROGRAMNAME message:[NSString stringWithFormat:NSLocalizedString(@"是否确定解绑玩具", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    t_alertView.tag = 11;
    [t_alertView show];
    
}



#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15.f;

}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1.f;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
            
        case 0:{
            return 1;
        }
        case 1:{
            return 1;
            break;
        }
        default:
            return 0;
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString* identifier = @"ToySettingCell";
    
    ToySettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"ToySettingCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    cell.lb_content.hidden      = YES;
    cell.imageV_arrow.hidden    = YES;
    cell.imageV_icon.hidden     = YES;
    cell.lb_nightModel.hidden   = YES;
    cell.swh.hidden             = YES;
    
    if (indexPath.section == 0) {
        
        cell.lb_title.text = NSLocalizedString(@"玩具信息", nil);
        cell.imageV_arrow.hidden = NO;
        
    }else if (indexPath.section == 1) {
        
        cell.lb_title.text = NSLocalizedString(@"小伙伴", nil);
        cell.imageV_arrow.hidden = NO;
        
    }
    
    return cell;

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:{
           
            ToyInfoVC  *vc = [[ToyInfoVC alloc]init];
            vc.toy = [ShareValue sharedShareValue].toyDetail;
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 1:{
            
            ToyContactVC *vc = [[ToyContactVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
    
            break;
        }
      
        default:
            
            break;
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

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 11){
        
        if (buttonIndex == 1) {
            
            NDToyDeleteParams *params = [[NDToyDeleteParams alloc] init];
            params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
            ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"解绑中..", nil) configParameter:^(ShowHUD *config) {
            } inView:self.view];
            
            [NDToyAPI toyDeleteWithParams:params completionBlockWithSuccess:^{
                
                [hud hide];
                
                [ShowHUD showSuccess:NSLocalizedString(@"解绑成功", nil) configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:self.view];
               
                
                [ShareValue sharedShareValue].toyDetail = nil;
                
            } Fail:^(int code, NSString *failDescript) {
                
                [hud hide];
                
                [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:ApplicationDelegate.window];
                
            }];
            
        }
        
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


#pragma mark -
#pragma mark dealloc 

- (void)dealloc{

    NSLog(@"ToySettingVC dealloc");

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
