//
//  ALarmEventVC.m
//  HelloToy
//
//  Created by nd on 15/6/16.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "ALarmEventVC.h"
#import "ToyThemeCell.h"
#import "AddAlarmEvent.h"


@interface ALarmEventVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray * arr_data;
@property (nonatomic,strong) AlarmEvent *alarmEvent_selected;

@end

@implementation ALarmEventVC

#pragma mark  - viewLift

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"闹钟铃声", nil);
    _arr_data = [[NSMutableArray alloc] init];
   
    [self initUI];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadAlarmEventList];
    

}


#pragma mark - private 

- (void)initUI{

    UIImage *image = [UIImage imageNamed:@"btn_toyHome_add"];
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button setImage:[UIImage imageNamed:@"btn_toyHome_add"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addAlarmEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;


}

-(void)loadAlarmEventList{
    
    NDAlarmEventListParams *params = [[NDAlarmEventListParams alloc] init];
    [NDAlarmAPI alarmEventListWithParams:params completionBlockWithSuccess:^(NSArray *data) {
        if ([data count] > 0) {
            if ([_arr_data count] > 0) {
                [_arr_data removeAllObjects];
            }
            
            [_arr_data addObjectsFromArray:data];
            [_tableView reloadData];
            
        }
        
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }];
}

-(void)changeAlarmEvent:(AlarmEvent *)alarmEvent{
    
    _alarmEvent.event_id = alarmEvent.event_id;
    _alarmEvent.desc = alarmEvent.desc;
    _alarmEvent.media_id = alarmEvent.media_id;
    
    [_tableView reloadData];

}

#pragma mark - buttonAction

- (void)addAlarmEvent:(id)sender{
    
    if (_arr_data && [_arr_data count] >= 10) {
        
        [ShowHUD showError:NSLocalizedString(@"铃声数量不能超过10个", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return;
    }
    
    AddAlarmEvent *t_vc = [[AddAlarmEvent alloc] init];
    [self.navigationController pushViewController:t_vc animated:YES];

}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_arr_data count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"ThemeListCell";
    
    ToyThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ToyThemeCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    
    
    AlarmEvent *alarmEvent = _arr_data[indexPath.row];
    
    cell.alarmEvent = alarmEvent;
    
    if (_alarmEvent) {
        if ([_alarmEvent.event_id isEqualToNumber:alarmEvent.event_id]) {
            cell.isSelected = YES;
        }else{
            cell.isSelected = NO;
        }
    }else{
        cell.isSelected = NO;
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AlarmEvent *alarmEvent = _arr_data[indexPath.row];
    
    [self changeAlarmEvent:alarmEvent];
    
    if (self.SelectAlarmBlock) {
        self.SelectAlarmBlock(alarmEvent);
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlarmEvent *alarmEvent = _arr_data[indexPath.row];
    
    if ([alarmEvent.event_type isEqualToNumber:@0] || (_alarmEvent && [_alarmEvent.event_id isEqualToNumber:alarmEvent.event_id])) {
        
        return NO;
        
    }else{
        
        
        
        return YES;
        
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        _alarmEvent_selected = nil;
       
        
        ToyThemeCell *cell = (ToyThemeCell *)[tableView  cellForRowAtIndexPath:indexPath];
        _alarmEvent_selected = cell.alarmEvent;
        UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:PROGRAMNAME message:[NSString stringWithFormat:NSLocalizedString(@"确定删除(%@)铃声?", nil),cell.alarmEvent.desc] delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        t_alertView.tag = 10;
        [t_alertView show];
    }
    
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedString(@"删除", nil);
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    __weak typeof(self) weakSelf = self;
    
    if (alertView.tag == 10) {
        
        if (buttonIndex == 1) {
            
            NDAlarmDelEventParams *params = [[NDAlarmDelEventParams alloc] init];
            params.event_id = _alarmEvent_selected.event_id;
            [NDAlarmAPI alarmDelEventWithParams:params completionBlockWithSuccess:^{
                [ShowHUD showSuccess:NSLocalizedString(@"删除成功", nil) configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:self.view];
                for (int i = 0 ; i < [_arr_data count] ; i++) {
                    AlarmEvent *alarmEvent = _arr_data[i];
                    if ([_alarmEvent_selected.event_id isEqualToNumber:alarmEvent.event_id]) {
                        _alarmEvent_selected = nil;
                        [_arr_data removeObject:alarmEvent];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                        break;
                    }
                }
                
                [weakSelf.tableView reloadData];
                
                
                
            } Fail:^(int code, NSString *failDescript) {
                _alarmEvent_selected = nil;
                [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:self.view];
            }];
            
        }
    }
}


#pragma mark - dealloc

- (void)dealloc{

    [self.tableView setEditing:NO];
    
    NSLog(@"ALarmEventVC dealloc");
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
