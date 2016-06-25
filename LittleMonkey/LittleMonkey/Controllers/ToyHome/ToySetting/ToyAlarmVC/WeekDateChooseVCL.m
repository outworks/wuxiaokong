//
//  WeekDateChooseVCL.m
//  belang
//
//  Created by ilikeido on 14-9-22.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "WeekDateChooseVCL.h"

@interface WeekDateChooseVCL (){
    NSArray *_weeksArray;
    NSMutableArray *_weekSelected;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WeekDateChooseVCL

- (void)viewDidLoad {
    [super viewDidLoad];
    _weeksArray = @[NSLocalizedString(@"周一", nil),NSLocalizedString(@"周二", nil),NSLocalizedString(@"周三", nil),NSLocalizedString(@"周四", nil),NSLocalizedString(@"周五", nil),NSLocalizedString(@"周六", nil),NSLocalizedString(@"周日", nil)];
    
    self.navigationController.navigationBarHidden = NO;

    _weekSelected = [[NSMutableArray alloc]init];
    if (_alarm.weekday.length>0) {
        NSArray *array = [_alarm.weekday componentsSeparatedByString:@","];
        [_weekSelected addObjectsFromArray:array];
    }
    self.title = NSLocalizedString(@"重复", nil);
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleBtnBackClicked {
    NSComparator finderSort = ^(id string1,id string2){
        if ([string1 integerValue] > [string2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([string1 integerValue] < [string2 integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *sortArray = [_weekSelected sortedArrayUsingComparator:finderSort];
    _alarm.weekday = [sortArray componentsJoinedByString:@","];
    
    if (self.SaveBlock) {
        self.SaveBlock(_alarm);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *WEEKCELL = @"WEEKCELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WEEKCELL];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WEEKCELL];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-44, 0, 44, 44)];
        imageView.tag = 11;
        imageView.contentMode = UIViewContentModeCenter;
        [cell.contentView addSubview:imageView];
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 , 43, ScreenWidth - 10, 1)];
        imageView.tag = 12;
        [imageView setBackgroundColor:[UIColor colorWithRed:210.f/255.f green:210.f/255.f blue:210.f/255.f alpha:0.6f]];
        [cell.contentView addSubview:imageView];
        
    }
    
    cell.textLabel.text = [_weeksArray objectAtIndex:indexPath.row];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:11];
    NSString *weekData = [NSString stringWithFormat:@"%d",indexPath.row+1];
    if ([_weekSelected containsObject:weekData]) {
        imageView.image = [UIImage imageNamed:@"icon_selected"];
    }else{
        imageView.image = nil;
    }
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *weekData = [NSString stringWithFormat:@"%d",indexPath.row+1];
    if ([_weekSelected containsObject:weekData]) {
        [_weekSelected removeObject:weekData];
    }else{
        [_weekSelected addObject:weekData];
    }
    [_tableView reloadData];
}



@end
