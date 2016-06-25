//
//  TranceiverDetailVC.h
//  HelloToy
//
//  Created by yull on 15/12/30.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "Fm.h"

@interface TranceiverDetailVC : HideTabSuperVC

@property (strong, nonatomic) IBOutlet UIImageView *albumIV;
@property (strong, nonatomic) IBOutlet UILabel *albumNameL;
@property (strong, nonatomic) IBOutlet UILabel *albumDescL;
@property (strong, nonatomic) IBOutlet UILabel *countL;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) FM *fm;

@end
