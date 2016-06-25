//
//  TranceiverDescriptVC.m
//  HelloToy
//
//  Created by ilikeido on 16/1/18.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "TranceiverDescriptVC.h"
#import "TransceiverDesciptCell.h"

@interface TranceiverDescriptVC ()

@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation TranceiverDescriptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"简介", nil);
    [self.table registerNib:[UINib nibWithNibName:@"TransceiverDesciptCell" bundle:nil] forCellReuseIdentifier:@"TransceiverDesciptCell"];
    self.table.tableFooterView = [[UIView alloc]init];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   TransceiverDesciptCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransceiverDesciptCell"];
    if (_fm) {
        [cell.lb_content setText:_fm.desc];
    }else if(_desc){
        [cell.lb_content setText:_desc];
    }
    
    return [self getCellHeight:cell];
}


- (CGFloat)getCellHeight:(UITableViewCell*)cell
{
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransceiverDesciptCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransceiverDesciptCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_fm) {
        [cell.lb_content setText:_fm.desc];
    }else if(_desc){
        [cell.lb_content setText:_desc];
    }
    return cell;
}


@end
