//
//  ExplainVC.m
//  LittleMonkey
//
//  Created by ilikeido on 16/6/25.
//  Copyright © 2016年 CivetCatsTeam. All rights reserved.
//

#import "ExplainVC.h"
#import "DescVC.h"

@interface ExplainVC ()
@property(nonatomic,strong) NSArray *datas;

@end

@implementation ExplainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"常见问题";
    [self initDatas];
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

-(void)initDatas{
    NSString *filePath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"instructions.plist"];
    NSArray *arrary = [NSArray arrayWithContentsOfFile:filePath];
    if (arrary) {
        self.datas = arrary;
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [_datas objectAtIndex:indexPath.row];
    DescVC *vc = [[DescVC alloc]init];
    vc.dict = dict;
    [self.navigationController pushViewController:vc animated:YES];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"MYCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    NSDictionary *dict = [_datas objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"title"];
    return cell;
}


@end
