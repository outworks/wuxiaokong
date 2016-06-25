//
//  TimerListVCL.h
//  belang
//
//  Created by ilikeido on 14-9-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabSuperVC.h"

@interface TimerListVCL : HideTabSuperVC


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lb_none;

@property(nonatomic,strong) NSNumber *toy_id;

@end
