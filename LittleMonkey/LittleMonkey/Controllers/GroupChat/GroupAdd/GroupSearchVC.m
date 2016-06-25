//
//  GroupSearchVC.m
//  LittleMonkey
//
//  Created by Hcat on 16/6/7.
//  Copyright © 2016年 CivetCatsTeam. All rights reserved.
//

#import "GroupSearchVC.h"
#import "NoneInfoView.h"
#import "NDGroupAPI.h"
#import "UIButton+Block.h"
#import "SearchCell.h"


@interface GroupSearchVC ()
{
    ShowHUD *_hud;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *aryData;

@property (strong, nonatomic) NoneInfoView *noneInfoView;

@end

@implementation GroupSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加入家庭圈";
    [self initData];
    [self initView];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_textField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_textField resignFirstResponder];
}

#pragma mark - private

- (void)initData
{
    _aryData = [[NSMutableArray alloc]init];
    
    self.textField.placeholder = NSLocalizedString(@"搜索群号", nil);
   
}

- (void)initView
{
    [_btnDelete handleClickEvent:UIControlEventTouchUpInside withClickBlick:^{
        _textField.text = @"";
    }];
}

#pragma mark -API

//搜索群
-(void)searchGroup:(NSString *)group_id{
    
    _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
    } inView:self.view];
    
    if ([_aryData count] != 0) {
        [_aryData removeAllObjects];
    }
    
    NDGroupDetailParams *params = [[NDGroupDetailParams alloc] init];
    params.id_list = group_id;
    [NDGroupAPI groupSearchWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        [_hud hide];
        
        [_aryData addObjectsFromArray:data];
        
        if (_aryData.count == 0) {
            [self addNonInfoView];
        } else {
            [self removeNonInfoView];
        }
        
        [_tableView reloadData];
        
    } Fail:^(int code, NSString *failDescript) {
        [_hud hide];
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        if (code != -1 && code != 2101) {
            [self addNonInfoView];
        }
        [_tableView reloadData];
        
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_aryData.count > 0) {
        return _aryData.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SEARCHCELL"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"SEARCHCELL"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"SEARCHCELL"];
    }
    [cell setDelegate:(id<SearchCellDelegate>)self];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_aryData.count > 0) {
        GroupDetail *groupDetail = _aryData[indexPath.row];
        [cell setCellDataWithGroupDetail:groupDetail];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SearchCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _textField) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 10) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString* phoneNum=@"^[0-9]*$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNum];
    if (![numberPre evaluateWithObject:_textField.text]) {
        [ShowHUD showError:NSLocalizedString(@"只能输入数字群号", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5 inView:self.view];
        return NO;
    }

    if ([_textField.text isEqualToString:@""]) {
        
        [ShowHUD showTextOnly:NSLocalizedString(@"请输入群号", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return NO;
        
    }else{
        
        [self removeNonInfoView];
        
        [_textField resignFirstResponder];
        
        [self searchGroup:_textField.text];
        return YES;
        
    }
    return YES;
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

#pragma mark - SearchCellDelegate

- (void)searchCellJoinDidClick:(UIButton *)joinButton andSearchCell:(SearchCell *)cell
{
    ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
    } inView:self.view];
    
    NDGroupApplyJoinParams *params = [[NDGroupApplyJoinParams alloc] init];
    params.group_id = cell.groupDetail.group_id;
    
    params.content = [NSString stringWithFormat:@"%@ 申请加入群 %@",[ShareValue sharedShareValue].user.nickname,cell.groupDetail.name];
    
    [NDGroupAPI groupApplyJoinWithParams:params completionBlockWithSuccess:^{
        
        [hud hide];
        [ShowHUD showSuccess:NSLocalizedString(@"申请已提交", nil) configParameter:^(ShowHUD *config) {
        } duration:0.5f inView:self.view];
        
    } Fail:^(int code, NSString *failDescript) {
        [hud hide];
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }];
    
}

#pragma mark - Functions

- (void)addNonInfoView
{
    _noneInfoView = [[[NSBundle mainBundle] loadNibNamed:@"DataNetWorkSuperView" owner:nil options:nil] lastObject];
    _noneInfoView.frame = CGRectMake(0, 64, ViewWidth(self.view), ViewHeight(self.view) - 64);
    _noneInfoView.btnReload.hidden = YES;
    _noneInfoView.lbTitle.text = NSLocalizedString(@"未找到相关群", nil);
    [self.view addSubview:_noneInfoView];
    
}

- (void)removeNonInfoView
{
    for(UIView *view in self.view.subviews){
        if ([view isKindOfClass:[DataNetWorkSuperView class]]) {
            [view removeFromSuperview];
        }
    }
}




#pragma mark - dealloc

- (void)dealloc{

    NSLog(@"GroupSearchVC dealloc");
    
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
