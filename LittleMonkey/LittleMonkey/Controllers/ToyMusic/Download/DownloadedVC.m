//
//  DownloadedVC.m
//  HelloToy
//
//  Created by ilikeido on 16/4/29.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "DownloadedVC.h"
#import "LRPageMenu.h"
#import "DownloadAlbumVC.h"
#import "DownloadMedioVC.h"
#import "DownloadingVC.h"
#import "PureLayout.h"
#import "ShowHUD.h"

@interface DownloadedVC ()

@property(nonatomic,strong) LRPageMenu *pageMenu;

@end

@implementation DownloadedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"玩具下载";
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initUI{
    DownloadAlbumVC *albumVC     = [[DownloadAlbumVC alloc] init];
    albumVC.title = @"专辑";
    albumVC.ownerVC = self;
    
    DownloadMedioVC *medioVC     = [[DownloadMedioVC alloc] init];
    medioVC.title = @"声音";
    albumVC.ownerVC = self;
    
    DownloadingVC *downloadingVC     = [[DownloadingVC alloc] init];
    downloadingVC.title = @"下载中";
    albumVC.ownerVC = self;
    
    NSArray * arr_controllers = @[albumVC,medioVC,downloadingVC];
    
    NSDictionary *dic_options = @{LRPageMenuOptionUseMenuLikeSegmentedControl:@(YES),
                                  LRPageMenuOptionSelectedTitleColor:UIColorFromRGB(0xff6948),
                                  LRPageMenuOptionUnselectedTitleColor:UIColorFromRGB(0x2d2d2d),
                                  LRPageMenuOptionSelectionIndicatorColor:UIColorFromRGB(0xff6948),
                                  LRPageMenuOptionScrollMenuBackgroundColor:[UIColor whiteColor],
                                  LRPageMenuOptionSelectionIndicatorWidth:@(50),
                                  
                                  };
    
    _pageMenu = [[LRPageMenu alloc] initWithViewControllers:arr_controllers frame:CGRectMake(0.0, 0, ScreenWidth, self.view.frame.size.height) options:dic_options];
    [self.view addSubview:_pageMenu.view];
    
    [_pageMenu.scro_controller setScrollEnabled:NO];
    
    [_pageMenu.view configureForAutoLayout];
    [_pageMenu.view autoPinEdgesToSuperviewEdges];
    [_pageMenu moveToPage:_index];

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
