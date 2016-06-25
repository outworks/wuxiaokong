//
//  ToyInfoVC.m
//  HelloToy
//
//  Created by huanglurong on 16/6/1.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ToyInfoVC.h"
#import "GroupChatSettingCell.h"
#import "NDToyAPI.h"


@interface ToyInfoVC (){

    NSArray *_aryData;
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString *toy_version;

@end

@implementation ToyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"玩具信息";
     _aryData = @[NSLocalizedString(@"玩具号", nil),NSLocalizedString(@"固件版本", nil)];
    
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - privateMethods


-(void)loadData{
    
    NDToyVersionParams *params = [[NDToyVersionParams alloc] init];
    params.toy_id = _toy.toy_id;
    [NDToyAPI toyVersionWithParams:params completionBlockWithSuccess:^(ToyUpdate *data) {
        if (data) {
        
            _toy_version = data.version;
        
            [self.tableView reloadData];
            
        }
        
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
    cell.ivArrows.hidden = YES;
    cell.lbLeft.text = _aryData[indexPath.row];
    cell.layout_lbright.constant = 15.f;
    [cell layoutIfNeeded];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.lbRight.text = [_toy.toy_id  stringValue];
        }
            break;
        case 1:
        {
            cell.lbRight.text = [NSString stringWithFormat:@"V%@",_toy_version];
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
