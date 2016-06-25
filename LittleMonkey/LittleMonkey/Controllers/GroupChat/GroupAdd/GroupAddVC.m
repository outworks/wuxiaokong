//
//  GroupAddVC.m
//  LittleMonkey
//
//  Created by Hcat on 16/6/7.
//  Copyright © 2016年 CivetCatsTeam. All rights reserved.
//

#import "GroupAddVC.h"
#import "QRCodeVC.h"
#import "NDGroupAPI.h"
#import "GroupSearchCell.h"
#import "GroupSearchVC.h"
#import "ChooseView.h"

@interface GroupAddVC ()<QRCodeVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *vSearch;

@end

@implementation GroupAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterNotification:) name:NOTIFICATION_REMOTE_ENTER object:nil];
    
    [self initData];
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

- (void)initView
{
    
   _tableView.tableHeaderView = _vSearch;
    
}

- (void)initData
{
    self.title = NSLocalizedString(@"加入家庭圈", nil);
}

- (void)juageGroup
{
    
    NDGroupDetailParams *params = [[NDGroupDetailParams alloc] init];
    [NDGroupAPI groupDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        
        if (data.count != 0) {
            
            GroupDetail *groupDetail = data[0];
            [groupDetail save];
            [ShareFun enterGroup:groupDetail];
            
            [GCDQueue executeInMainQueue:^{
                
                ApplicationDelegate.tabBarController.selectedIndex = 0;
                [ApplicationDelegate initAKTabBarController];
                ApplicationDelegate.window.rootViewController = ApplicationDelegate.tabBarController;
                
            } afterDelaySecs:1];
            
        }
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFCATION_LOGOUT object:nil];
    }];
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GROUPSEARCHCELL"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"GroupSearchCell" bundle:nil] forCellReuseIdentifier:@"GROUPSEARCHCELL"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"GROUPSEARCHCELL"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.ivIcon.image = [UIImage imageNamed:@"icon_sweepcode.png"];
    cell.lbName.text = NSLocalizedString(@"扫描家庭圈邀请二维码", nil);
    
    cell.vLine.hidden = NO;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GroupSearchCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QRCodeVC *vc = [[QRCodeVC alloc]init];
    vc.delegate = self;
    vc.content = NSLocalizedString(@"请让对方打开家庭圈设置，对准家庭群二维码扫描", nil);
    UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:t_nav animated:YES completion:^{
        
    }];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        if (scrollView.contentOffset.y < 0) {
            CGPoint position = CGPointMake(0, 0);
            [scrollView setContentOffset:position animated:NO];
            return;
        }
    }
}


#pragma mark - ButtonActions
- (IBAction)handleSearchDidClick:(id)sender {
    GroupSearchVC *searchVC = [[GroupSearchVC alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - QRCodeVCDelegate
-(NSDictionary *)getTypeByCode:(NSString *)code{
    //是否扫描登录功能
    if ([code rangeOfString:@"/login/"].length > 0) {
        return @{@"type":@1,@"url":code};
    }else if([code rangeOfString:@":"].length >0){
        NSArray *codesub = [code componentsSeparatedByString:@":"];
        if (codesub.count == 2) {
            NSString *type = codesub[0];
            if ([type isEqual:@"group"]) {
                return @{@"type":@2,@"id":@([codesub[1] integerValue])};
            }else if ( [type isEqual:@"member"]){
                return @{@"type":@3,@"id":@([codesub[1] integerValue])};
            }else if ( [type isEqual:@"toy"]){
                return @{@"type":@4,@"id":@([codesub[1] integerValue])};
            }
        }
    }
    return 0;
}

-(void)scanReturn:(NSString *)result QRCodeVC:(QRCodeVC *)codeVc{
    __weak typeof(self) weakself = self;
    NSDictionary *dict = [self getTypeByCode:result];
    NSNumber *type = [dict objectForKey:@"type"];
    if (type.integerValue == 2) {
        NSNumber *groupid = [dict objectForKey:@"id"];
        [codeVc dismissViewControllerAnimated:YES completion:^{
            [ChooseView showChooseViewInMiddleWithTitle:PROGRAMNAME andPrimitiveText:nil andChooseList:@[NSLocalizedString(@"是否加入该群？", nil)] andCancelButtonTitle:NSLocalizedString(@"拒绝", nil)  andConfirmButtonTitle:NSLocalizedString(@"确定", nil)  andChooseCompleteBlock:^(NSInteger row) {
                [weakself addGroupId:groupid owner:nil];
            } andChooseCancleBlock:^(NSInteger row) {
            }];
        }];
    }
    
}

-(void)scanError{
    
}

-(void)addGroupId:(NSNumber *)groupid owner:(NSString *)ownerid{
    __weak typeof(self) weakSelf = self;
    if (groupid) {
        ShowHUD * _hud = [ShowHUD showText:NSLocalizedString(@"正在处理...", nil) configParameter:^(ShowHUD *config) {
        } inView:self.view];
        
        NDGroupApplyJoinParams *params = [[NDGroupApplyJoinParams alloc] init];
        params.group_id = groupid;
        
        params.content = [NSString stringWithFormat:NSLocalizedString(@"%@ 申请加入群", nil),[ShareValue sharedShareValue].user.nickname];
        
        [NDGroupAPI groupApplyJoinWithParams:params completionBlockWithSuccess:^{
            if (_hud) [_hud hide];
            [ShowHUD showSuccess:NSLocalizedString(@"申请已提交", nil) configParameter:^(ShowHUD *config) {
                
            } duration:1.5f inView:weakSelf.view];
        
        } Fail:^(int code, NSString *failDescript) {
            
            if (_hud) [_hud hide];
            
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
                
            } duration:1.5f inView:weakSelf.view];
        
        }];
        
    }
    
}

#pragma mark - notification

-(void)enterNotification:(NSNotification *)note{
    
    [self juageGroup];
    
}

#pragma mark - dealloc

- (void)dealloc{

    NSLog(@"GroupAddVC dealloc");

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
