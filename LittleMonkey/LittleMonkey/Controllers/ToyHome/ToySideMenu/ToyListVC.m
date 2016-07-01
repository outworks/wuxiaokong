//
//  ToyListVC.m
//  LittleMonkey
//
//  Created by Hcat on 16/6/5.
//  Copyright © 2016年 CivetCatsTeam. All rights reserved.
//

#import "ToyListVC.h"
#import "ToyGuideToBindVC.h"
#import <RESideMenu/RESideMenu.h>
#import "ToyHomeVC.h"
#import "ToyListCell.h"
#import "NDGroupAPI.h"


@interface ToyListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) BOOL isLoadToyList;

@end

@implementation ToyListVC

#pragma mark - viewLift

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LoadToyListNotification:) name:NOTIFICATION_LOADTOYLISY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setToyInfoSucess:) name:NOTIFICATION_SETTOYINFOSUCESS object:nil]; //玩具绑定成功通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(toyQuit:) name:NOTIFICATION_REMOTE_QUIT object:nil]; //玩具退出群通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addToyListNotification:) name:NOTIFICATION_REMOTE_DATAS object:nil];
    _isLoadToyList = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isLoadToyList) {
        _isLoadToyList = YES;
        [self loadToyList];
    }
    
}

#pragma mark - private

-(void)loadToyList{
    
    GroupDetail *groupDetail = [ShareValue sharedShareValue].groupDetail;
    
    if (groupDetail.toy_list.count >0) {
        
        if (![ShareValue sharedShareValue].toyDetail) {
            
            [ShareValue sharedShareValue].toyDetail = groupDetail.toy_list.firstObject;
    
        }
        
        ToyHomeVC *t_vc = [[ToyHomeVC alloc] init];
        
        UINavigationController *toyHomeNav = [[UINavigationController alloc]initWithRootViewController:t_vc];
        [self.sideMenuViewController setContentViewController:toyHomeNav animated:YES];
        [self.sideMenuViewController hideMenuViewController];
        
    }else{
        
        [ShareValue sharedShareValue].toyDetail = nil;
        ToyGuideToBindVC *t_vc = [[ToyGuideToBindVC alloc] init];
        t_vc.isGuide = NO;
        t_vc.isHaveToy = NO;
        UINavigationController *toyGuideNav = [[UINavigationController alloc]initWithRootViewController:t_vc];
        [self.sideMenuViewController setContentViewController:toyGuideNav animated:YES];
        [self.sideMenuViewController hideMenuViewController];
        
    }
    
    [_tableView reloadData];
    
}


- (void)juageGroup
{
    
    __weak typeof(self) weakSelf = self;
    
    NDGroupDetailParams *params = [[NDGroupDetailParams alloc] init];
    [NDGroupAPI groupDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        
        if (data.count != 0) {
            
            GroupDetail *groupDetail = data[0];
            [groupDetail save];
            [ShareFun enterGroup:groupDetail];
            
            [weakSelf loadToyList];
            
        }
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [ShareValue sharedShareValue].groupDetail.toy_list.count + 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"ToyListCell";
    
    ToyListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ToyListCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if (indexPath.row == [ShareValue sharedShareValue].groupDetail.toy_list.count) {
        
        cell.toy = nil;
        
    } else {
        
        Toy *toy = [ShareValue sharedShareValue].groupDetail.toy_list[indexPath.row];
        cell.toy = toy;
    }
    
    return cell;
    
}


#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *array = [ShareValue sharedShareValue].groupDetail.toy_list;
    
    if (indexPath.row >= array.count) {
        
        [ShareValue sharedShareValue].toyDetail = nil;
        
        ToyGuideToBindVC *t_vc = [[ToyGuideToBindVC alloc] init];
        t_vc.isGuide = NO;
        t_vc.isHaveToy = [ShareValue sharedShareValue].groupDetail.toy_list.count;
        
        UINavigationController *toyGuideNav = [[UINavigationController alloc]initWithRootViewController:t_vc];
        [self.sideMenuViewController setContentViewController:toyGuideNav animated:YES];
        
        [self.sideMenuViewController hideMenuViewController];
        
        [self.tableView reloadData];
        
    }else{
        
        if ([ShareValue sharedShareValue].toyDetail  != [ShareValue sharedShareValue].groupDetail.toy_list[indexPath.row]) {
            
            [ShareValue sharedShareValue].toyDetail = [ShareValue sharedShareValue].groupDetail.toy_list[indexPath.row];
            [tableView reloadData];
            
            ToyHomeVC *t_vc = [[ToyHomeVC alloc] init];;
            
            UINavigationController *toyHomeNav = [[UINavigationController alloc]initWithRootViewController:t_vc];
            [self.sideMenuViewController setContentViewController:toyHomeNav animated:YES];
          
        }
        
        [self.sideMenuViewController hideMenuViewController];
        
    }
    
}






#pragma mark - NSNotification

-(void)LoadToyListNotification:(NSNotification *)note{
    if ([note.object objectForKey:@"reload"]) {
        [self.tableView reloadData];
    }else{
        [self loadToyList];
    }
}

-(void)setToyInfoSucess:(NSNotification *)note{

    [self juageGroup];
    
}

-(void)toyQuit:(NSNotification *)note{

    NSDictionary *dictionary =  note.userInfo;
    
    if (dictionary) {
        NSNumber *member_type = [dictionary objectForKey:@"member_type"];
        
        if ([member_type isEqualToNumber:@1]) {
            [self juageGroup];
        }
    }

}

-(void)addToyListNotification:(NSNotification *)note{
    
    
    GroupDetail *groupDetail = [ShareValue sharedShareValue].groupDetail;
    
    if (groupDetail.toy_list.count == 0) {
        
       [self juageGroup];
        
    }
    
}


#pragma mark - dealloc

- (void)dealloc{

    NSLog(@"ToyListVC dealloc");

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
