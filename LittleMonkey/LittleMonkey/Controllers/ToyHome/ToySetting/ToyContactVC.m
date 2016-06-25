//
//  ToyContactVC.m
//  HelloToy
//
//  Created by huanglurong on 16/3/8.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ToyContactVC.h"
#import "ToyContactCell.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "NDToyAPI.h"
#import "MailCollectedDetailVC.h"

@interface ToyContactVC (){

    ShowHUD * _hud;
    
}

@property(nonatomic,strong) NSMutableArray *arr_data;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lb_info;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL isLastPage;

@end

@implementation ToyContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"buddy", nil);
    
    _arr_data = [NSMutableArray array];
    _page = 1;
    _isLastPage = NO;
    
    [self loadContactListRequest];
    
    __weak typeof(self) weakSelf = self;
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
       [weakSelf loadContactListRequest];
        
    }];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private 


- (void)loadContactListRequest{

    __weak typeof(self) weakSelf = self;
    
    if (_page == 1) {
        _tableView.showsInfiniteScrolling = NO;
    }else{
        _tableView.showsInfiniteScrolling = !_isLastPage;
    }
    
    if (_page == 1) {
        _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
        } inView:self.view];
    }
    
    NDToyContactListParams *params = [[NDToyContactListParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.page = _page;
    params.rows = 20;
    
    [NDToyAPI toyContactListWithParams:params completionBlockWithSuccess:^(NDToyContactListResult *data) {
        
        if (_hud) [_hud hide];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        
        if ([data.contactList count] < 20) {
            
            weakSelf.isLastPage = YES;
            
        }
        [weakSelf.arr_data addObjectsFromArray:data.contactList];
        
        weakSelf.tableView.showsInfiniteScrolling = !_isLastPage;
        [weakSelf.tableView reloadData];
        
        weakSelf.page ++;
        
    } Fail:^(int code, NSString *failDescript) {
        
        if (_hud) [_hud hide];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        [weakSelf.tableView reloadData];
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }];

}

#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([_arr_data count] > 0) {
        
        _lb_info.hidden = YES;
        return [_arr_data count];
    
    }else{
        
         _lb_info.hidden = NO;
        return 0;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString* identifier = @"ToyContactCell";
    
    ToyContactCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"ToyContactCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
    }
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.contactGmail          = _arr_data[indexPath.row];
   
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MailCollectedDetailVC *t_vc = [[MailCollectedDetailVC alloc] init];
    t_vc.isContact = YES;
    t_vc.contactGmail = _arr_data[indexPath.row];
    [self.navigationController pushViewController:t_vc animated:YES];

}




#pragma mark - dealloc 

- (void)dealloc{
    
    NSLog(@"ToyContactVC dealloc");

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
