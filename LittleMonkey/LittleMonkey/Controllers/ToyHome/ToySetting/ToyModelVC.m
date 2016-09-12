//
//  ToyModelVC.m
//  HelloToy
//
//  Created by nd on 15/5/18.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "ToyModelVC.h"

@interface ToyModelVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) ShowHUD *hud;
@property (strong,nonatomic) NSString *mode;

@end

@implementation ToyModelVC

#pragma mark - viewLift

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"模式切换", nil);
    [self queryToyDataWithKeys:@[DATA_KEY_MODECHANGE]];
    [_tableView setTableFooterView:[[UIView alloc]init]];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private Methods

/*********** 查询玩具模式 ************/

- (void)queryToyDataWithKeys:(NSArray *)keys{
    
    NDToyDataKeyValueParams *params = [[NDToyDataKeyValueParams alloc] init];
    params.toy_id = _toy.toy_id;
    params.keys = keys;
    
    _hud = [ShowHUD showText:NSLocalizedString(@"请求中", nil) configParameter:^(ShowHUD *config) {} inView:self.view];
    
    [NDToyAPI toyDataKeyValueParams:params completionBlockWithSuccess:^(ToyStatus *data) {
        [_hud hide];
        _mode = data.mode;
        [_tableView reloadData];
    } Fail:^(int code, NSString *failDescript) {
        
        [_hud hide];
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
    }];
}



#pragma mark - UITableViewDelegate 


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"ToyModelSetCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.tintColor = UIColorFromRGB(0xff6948);
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    switch (indexPath.row) {
        case 0:{
            cell.textLabel.text = NSLocalizedString(@"对讲模式", nil);
            if ([_mode isEqual:@"2"]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            }
            break;
        case 1:{
            cell.textLabel.text = NSLocalizedString(@"音乐模式", nil);
            if ([_mode isEqual:@"1"]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
            break;
        case 2:{
            cell.textLabel.text = NSLocalizedString(@"故事模式", nil);
            if ([_mode isEqual:@"0"]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
            break;
        case 3:{
            cell.textLabel.text = NSLocalizedString(@"玩耍模式", nil);
            if ([_mode isEqual:@"3"]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
            break;
        case 4:{
            cell.textLabel.text = NSLocalizedString(@"夜灯模式", nil);
            if ([_mode isEqual:@"10"]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
            break;
        default:
            break;
    }
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NDToyChangeModeParams *params = [[NDToyChangeModeParams alloc] init];
    params.toy_id = _toy.toy_id;
    
    switch (indexPath.row) {
        case 0:{
            params.mode = @2;
        }
            break;
        case 1:{
            params.mode = @1;
        }
            break;
        case 2:{
            params.mode = @0;
        }
            break;
        case 3:{
            params.mode = @3;
        }
            break;
        case 4:{
            params.mode = @10;
        }
            break;
        default:
            break;
    }
    [NDToyAPI toyChangeModeWithParams:params completionBlockWithSuccess:^(NDToyChangeModeResult *result) {
        _mode = [params.mode stringValue];
        [_tableView reloadData];
        
        if (result.isonline) {
            
            if ([result.isonline boolValue]) {
                [ShowHUD showSuccess:NSLocalizedString(@"切换成功", nil) configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:self.view];
            }else{
                [ShowHUD showSuccess:NSLocalizedString(@"设备不在线，五分钟内生效", nil) configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:self.view];
            }
            return ;
        }
        [ShowHUD showSuccess:NSLocalizedString(@"切换成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }];
}



#pragma mark - dealloc

-(void)dealloc{
    NSLog(@"ToyModelVC dealloc");
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
