//
//  GroupInfo2VC.m
//  HelloToy
//
//  Created by huanglurong on 16/6/1.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "GroupInfo2VC.h"

#import "NDGroupAPI.h"
#import "WXApi.h"

#import "ChooseView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+External.h"
#import "UIButton+Block.h"
#import "ImageFileInfo.h"

#import "GroupMemberItemCell.h"
#import "GroupCodeVC.h"

#define  NickName_MaxLen 16

@interface GroupInfo2VC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSInteger _currentWriten;
    MBProgressHUD *_hud;
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *v_bottom;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;
@property (weak, nonatomic) IBOutlet UILabel *lb_groupId;
@property (weak, nonatomic) IBOutlet UILabel *lb_groupName;

@property (weak, nonatomic) IBOutlet UILabel *lb_groupNummber;
@property (weak, nonatomic) IBOutlet UIButton *btn_quitGroup;


@property (strong, nonatomic) IBOutlet UIView *vNickName;
@property (weak, nonatomic) IBOutlet UIButton *btnCancle;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btndelete;
@property (weak, nonatomic) IBOutlet UITextField *tfNickName;
@property (weak, nonatomic) IBOutlet UIView *vCover;


@property(nonatomic,strong) UIImage *headImage;

@property (strong, nonatomic) NSMutableArray *aryData;

@end

@implementation GroupInfo2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.aryData = [NSMutableArray new];
    self.title = NSLocalizedString(@"我的家设置", nil);
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self groupDetailRequest];
    
}

-(void)initUI{

    _lb_groupName.text = [ShareValue sharedShareValue].groupDetail.name;
    _lb_groupId.text = [NSString stringWithFormat:@"家庭号:%@",[ShareValue sharedShareValue].groupDetail.group_id];
    [_imageV_icon sd_setImageWithURL:[NSURL URLWithString:_groupDetail.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
    
    _imageV_icon.layer.cornerRadius = 54/2;
    _imageV_icon.layer.masksToBounds = YES;
    
    _lb_groupNummber.text = [NSString stringWithFormat:@"家庭成员(%d人)",([_groupDetail.user_list count]+[_groupDetail.toy_list count])];
    
    if ([_groupDetail.owner_id isEqualToNumber:[ShareValue sharedShareValue].user.user_id]) {
        //群主
        [_btn_quitGroup setTitle:NSLocalizedString(@"解散群", nil) forState:UIControlStateNormal];
    } else {
        //成员
        [_btn_quitGroup setTitle:NSLocalizedString(@"退出群", nil) forState:UIControlStateNormal];
    }

}

- (void)initView{

    __weak typeof(self) weakSelf = self;
    
    //设置vNickName初始frame
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
            [ShowHUD showWarning:NSLocalizedString(@"PleaseEnterTheGroupName", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
            
            return ;
        }
        
        if (_tfNickName.text.length > NickName_MaxLen) {
            [ShowHUD showError:NSLocalizedString(@"GroupNameTooLong", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
            return;
        }
        
        ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"Saving", nil) configParameter:^(ShowHUD *config) {
        } inView:[[UIApplication sharedApplication] windows].firstObject];
        
        NDGroupUpdateParams *params = [[NDGroupUpdateParams alloc] init];
        params.group_id = _groupDetail.group_id;
        params.name = weakSelf.tfNickName.text;
        params.icon = _groupDetail.icon;
        
        [NDGroupAPI groupUpdateWithParams:params
               completionBlockWithSuccess:^(GroupDetail *data) {
                   [hud hide];
                   [ShowHUD showSuccess:NSLocalizedString(@"ChangeSuccess", nil) configParameter:^(ShowHUD *config) {
                   } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
                   _groupDetail.name = weakSelf.tfNickName.text;
                   [self updateNickNameViewHiddenAnimateIfNeed];
                   
                   _lb_groupName.text = _groupDetail.name;
                   
               } Fail:^(int code, NSString *failDescript) {
                   [hud hide];
                   if(code == 1011){
                       
                       [ShowHUD showError:@"新群名和旧群名相同" configParameter:^(ShowHUD *config) {
                       } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
                   
                   }else{
                       
                       [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
                       } duration:1.5f inView:[[UIApplication sharedApplication] windows].firstObject];
                   }
                   
                  
               }
         ];
    }];
    
    //删除按钮
    [_btndelete handleClickEvent:UIControlEventTouchUpInside withClickBlick:^{
        weakSelf.tfNickName.text = @"";
    }];


}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    GroupMemberItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupMemberItemCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"GroupMemberItemCell" bundle:nil] forCellReuseIdentifier:@"GroupMemberItemCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"GroupMemberItemCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([_aryData count] > 0) {
        
        cell.mArr_groupMember = _aryData;
        
    }
   
    [cell setDelegate:(id<GroupMemberItemCellDelegate>)self];
    
    

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (_aryData && [_aryData count] > 0) {
    
                if ([_aryData count] % 4 == 0) {
    
                    return 20 + [_aryData count]/4*90;
    
                }else{
    
                    return 20 + ([_aryData count]/4 + 1 )*90 ;
    
                }
    
    }
    
    return 300;

    
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



#pragma mark -buttonAciton

- (IBAction)btnIconAction:(id)sender {
    
    if (![ShareFun isGroupOwner]) {
        [ShowHUD showTextOnly:@"您不是群主" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        return;
    }
    
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

- (IBAction)btnEnCodeAction:(id)sender {
    
    GroupCodeVC *vc = [[GroupCodeVC alloc] init];
    vc.groupDetail =_groupDetail;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


- (IBAction)btnNameAction:(id)sender {
    
    if (![ShareFun isGroupOwner]) {
        [ShowHUD showTextOnly:@"您不是群主" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        return;
    }
    
    _tfNickName.text = _groupDetail.name;
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



- (IBAction)addGroupAction:(id)sender {
    
    if ([_groupDetail.owner_id isEqualToNumber:[ShareValue sharedShareValue].user.user_id]) {
        //群主
        [_tableView setEditing:NO animated:YES];
        
        [ChooseView showChooseViewInMiddleWithTitle:PROGRAMNAME andPrimitiveText:nil andChooseList:@[[NSString stringWithFormat:NSLocalizedString(@"是否确定解散群", nil)]] andCancelButtonTitle:NSLocalizedString(@"取消", nil) andConfirmButtonTitle:NSLocalizedString(@"确定", nil) andChooseCompleteBlock:^(NSInteger row) {
            [self dismissGroupRequest];
        } andChooseCancleBlock:^(NSInteger row) {
        }];
    } else {
        //成员
        [_tableView setEditing:NO animated:YES];
        
        [ChooseView showChooseViewInMiddleWithTitle:PROGRAMNAME andPrimitiveText:nil andChooseList:@[[NSString stringWithFormat:NSLocalizedString(@"是否确定退出群", nil)]] andCancelButtonTitle:NSLocalizedString(@"取消", nil) andConfirmButtonTitle:NSLocalizedString(@"确定", nil) andChooseCompleteBlock:^(NSInteger row) {
            [self quitGroupRequest];
        } andChooseCancleBlock:^(NSInteger row) {
        }];
    }
    
   
}


#pragma mark - APIS

//查询群信息
- (void)groupDetailRequest
{
    NDGroupDetailParams *params = [[NDGroupDetailParams alloc] init];
    [NDGroupAPI groupDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        if (data.count != 0) {
            GroupDetail *groupDetail = data[0];
            [groupDetail save];
            _groupDetail = groupDetail;
            [ShareValue sharedShareValue].groupDetail = groupDetail;
            [ShareValue sharedShareValue].group_id = groupDetail.group_id;
            [ShareValue sharedShareValue].group_owner_id = groupDetail.owner_id;
            [self initMemBerData];
            [_tableView reloadData];
            [self initUI];
        }
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }];
}

//解散群
- (void)dismissGroupRequest
{
    NDGroupDismissParams *params = [[NDGroupDismissParams alloc] init];
    params.group_id = _groupDetail.group_id;
    ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
    } inView:self.view];
    
    __weak __typeof(self) weakSelf = self;
    [NDGroupAPI groupDismissWithParams:params completionBlockWithSuccess:^{
        [hud hide];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_DISMISS object:nil userInfo:nil];
        [ShowHUD showSuccess:NSLocalizedString(@"解散成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
        [ShareFun deleteAllTable];
        [ShareFun deleteMailTable];
        [ShareFun quitGroup];
        [[GCDQueue mainQueue] execute:^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } afterDelay:1.5 *NSEC_PER_SEC];
        
    } Fail:^(int code, NSString *failDescript) {
        [hud hide];
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
    }];
    
}

//退出群
- (void)quitGroupRequest
{
    
    NDGroupQuitParams *params = [[NDGroupQuitParams alloc] init];
    params.group_id = _groupDetail.group_id;
    
    ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
    } inView:self.view];
    __weak __typeof(self) weakSelf = self;
    [NDGroupAPI groupQuitWithParams:params completionBlockWithSuccess:^{
        [hud hide];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_QUIT object:nil userInfo:nil];
        [ShowHUD showSuccess:NSLocalizedString(@"退出成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
        [ShareFun deleteAllTable];
        [ShareFun deleteMailTable];
        [ShareFun quitGroup];
        [[GCDQueue mainQueue] execute:^{
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        } afterDelay:1.5 *NSEC_PER_SEC];
    } Fail:^(int code, NSString *failDescript) {
        [hud hide];
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
    }];
    
}

- (void)initMemBerData
{
    _aryData = [[NSMutableArray alloc]init];
    if (_groupDetail.user_list) {
        [_aryData addObjectsFromArray:_groupDetail.user_list];
    }
    if (_groupDetail.toy_list) {
        [_aryData addObjectsFromArray:_groupDetail.toy_list];
    }
    
    NSString *str = @"加人";
    [_aryData addObject:str];

}


#pragma mark - Functions

//修改群名视图消失的动画
- (void)updateNickNameViewHiddenAnimateIfNeed
{
    __weak GroupInfo2VC *weakSelf = self;
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
    NDGroupUpdateParams *params = [[NDGroupUpdateParams alloc] init];
    params.group_id = _groupDetail.group_id;
    params.name = _groupDetail.name;
    params.icon = filepath;
    
    [NDGroupAPI groupUpdateWithParams:params
           completionBlockWithSuccess:^(GroupDetail *data) {
               [ShowHUD showSuccess:NSLocalizedString(@"更新成功", nil) configParameter:^(ShowHUD *config) {
               } duration:1.5f inView:self.view];
               NDGroupDetailParams *params = [[NDGroupDetailParams alloc] init];
               [NDGroupAPI groupDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
                   if (data.count != 0) {
                       GroupDetail *groupDetail = data[0];
                       [groupDetail save];
                       [ShareFun enterGroup:groupDetail];
                       _groupDetail = [ShareValue sharedShareValue].groupDetail;
                   }
                
                   [_tableView reloadData];
                   
                    [_imageV_icon sd_setImageWithURL:[NSURL URLWithString:_groupDetail.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
                   
               } Fail:^(int code, NSString *failDescript) {
               }];
           } Fail:^(int code, NSString *failDescript) {
               [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
               } duration:1.5f inView:self.view];
           }
     ];
}

#pragma mark  - GroupMemberDelegate

-(void)ClickItemAction:(GroupMemberItem *)album{
    
    if (album.user) {
        [self groupDetailRequest];
    }else if (album.toy){
        [self groupDetailRequest];
    }else if (album.add){
        
        User *user = [ShareValue sharedShareValue].user;
        GroupDetail *groupDetail = [ShareValue sharedShareValue].groupDetail;
        
        NDGroupInviteCodeParams *params = [[NDGroupInviteCodeParams alloc] init];
        params.group_id = groupDetail.group_id;
        [NDGroupAPI groupInviteCodeWithParams:params completionBlockWithSuccess:^(NDGroupInviteCodeResult *data) {
            if (data) {
                NSString *code = data.inviteCode;
                NSString* userNickname = user.nickname;
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = [NSString stringWithFormat:@"%@邀请你加入\"%@\"(群号:%@)",userNickname,groupDetail.name,groupDetail.group_id];
                NSString* url = [NSString stringWithFormat:@"%@download?code=%@",NDDOWNLOAD_SERVERURL,code];
                
                message.description = NSLocalizedString(@"悟小空智能故事机。史上最强，接入喜马拉雅海量故事，更多惊喜，等你发现，点我立刻下载(必看)", nil);
                [message setThumbImage:[UIImage imageNamed:@"icon_app.png"]];
                
                
                WXWebpageObject *ext = [WXWebpageObject object];
                
                ext.webpageUrl = url;
                message.mediaObject = ext;
                
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;
                req.message = message;
                req.scene = WXSceneSession;
                
                [WXApi sendReq:req];
            }
            
            
        } Fail:^(int code, NSString *failDescript) {
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
        }];
        
    }
    
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


#pragma mark - dealloc

- (void)dealloc{

    

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
