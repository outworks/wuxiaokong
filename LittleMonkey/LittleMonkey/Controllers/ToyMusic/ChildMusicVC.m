//
//  ChildMusicVC.m
//  HelloToy
//
//  Created by huanglurong on 16/4/11.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildMusicVC.h"
#import "LRPageMenu.h"
#import "ChildRecomVC.h"
#import "HaloSquareVC.h"

#import "ChildMenuView.h"
#import "ChildSearchVC.h"
#import "PortDownloadedVC.h"

#import "PureLayout.h"
#import "NDAlbumAPI.h"

#import "AppDelegate.h"

@interface ChildMusicVC ()


@property (nonatomic,strong) LRPageMenu *pageMenu;

@property (weak, nonatomic) IBOutlet UIButton *btn_back;

@property (weak, nonatomic) IBOutlet UIButton *btn_more;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_search;

@end

@implementation ChildMusicVC

#pragma mark -viewLife

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    //[ChildMusicVC loadCollections];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    if (_canBack) {
        [ApplicationDelegate hideTabView];
    }
    

    if (![ShareValue sharedShareValue].toyDetail.toy_id) {
        _layout_search.constant = 10;
        _btn_more.hidden = YES;
    }else{
        _layout_search.constant = 47.f;
        _btn_more.hidden = NO;

    }

}

#pragma mark - private

- (void)initialize{
    
    self.navigationItem.title = @"儿童故事";

    HaloSquareVC *vc_childRecom     = [[HaloSquareVC alloc] init];
    vc_childRecom.title = @"推荐";
    
    ChildRecomVC *vc_childRecomVC     = [[ChildRecomVC alloc] init];
    vc_childRecomVC.title = @"喜马拉雅";
    
    PortDownloadedVC *vc_portDownloadedVC     = [[PortDownloadedVC alloc] init];
    vc_portDownloadedVC.title = @"玩具";

    NSArray * arr_controllers = @[vc_childRecom,vc_childRecomVC,vc_portDownloadedVC];
    
    NSDictionary *dic_options = @{LRPageMenuOptionUseMenuLikeSegmentedControl:@(YES),
                                  LRPageMenuOptionSelectedTitleColor:UIColorFromRGB(0xff6948),
                                  LRPageMenuOptionUnselectedTitleColor:UIColorFromRGB(0x2d2d2d),
                                  LRPageMenuOptionSelectionIndicatorColor:UIColorFromRGB(0xff6948),
                                  LRPageMenuOptionScrollMenuBackgroundColor:[UIColor whiteColor],
                                  LRPageMenuOptionSelectionIndicatorWidth:@(80),
                                  
                                  };
    
    _pageMenu = [[LRPageMenu alloc] initWithViewControllers:arr_controllers frame:CGRectMake(0.0, 64.0, ScreenWidth, self.view.frame.size.height-64) options:dic_options];
    
    [self.view addSubview:_pageMenu.view];
    [_btn_back setHidden:!_canBack];
}

#pragma mark - Functions

-(IBAction)handleBtnBackClicked:(id)sender{
    
    if (self.navigationController.viewControllers.count == 1) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

/* -------------------- 下载故事收藏 ------------------ */

+ (void)loadCollections{
    
    
    if (![ShareValue sharedShareValue].collection_id) {
        
        GCDGroup *group = [GCDGroup new];
        [[GCDQueue globalQueue] execute:^{
            
            GCDSemaphore *semaphore = [GCDSemaphore new];
            
            
            NDAlbumQueryParams *params = [[NDAlbumQueryParams alloc] init];
            params.source = @"2";
            params.page = [NSNumber numberWithInteger:1];
            
            [NDAlbumAPI albumQueryWithParams:params completionBlockWithSuccess:^(NSArray *data) {
                
                if ([data count] > 0 ) {
                    
                    for (AlbumInfo *album in data) {
                        
                        if ([album.name isEqualToString:@"我的收藏"]) {
                            
                            [ShareValue sharedShareValue].collection_id = album.album_id;
                            
                            break;
                        }
                    }
                }
                
                [semaphore signal];
                
            } Fail:^(int code, NSString *failDescript) {
                
                [semaphore signal];
                
            }];
            
            [semaphore wait];
            
        } inGroup:group];
        
        
        [[GCDQueue globalQueue] notify:^{
            
            NDAlbumDetailParams *params = [[NDAlbumDetailParams alloc] init];
            params.album_id = [ShareValue sharedShareValue].collection_id;
            
            [NDAlbumAPI albumDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
                
                if (data > 0) {
                    
                    NSMutableArray *mArr_t = [NSMutableArray arrayWithArray:data];
                    [ShareValue sharedShareValue].mArr_collections = mArr_t;
                    [NotificationCenter postNotificationName:NOTIFCATION_COLLECTION object:nil userInfo:nil];
                    
                }
                
            } Fail:^(int code, NSString *failDescript) {
                
            }];
            
        } inGroup:group];
        
    }else{
        
        NDAlbumDetailParams *params = [[NDAlbumDetailParams alloc] init];
        params.album_id = [ShareValue sharedShareValue].collection_id;
        
        [NDAlbumAPI albumDetailWithParams:params completionBlockWithSuccess:^(NSArray *data) {
            
            if (data > 0) {
                
                NSMutableArray *mArr_t = [NSMutableArray arrayWithArray:data];
                [ShareValue sharedShareValue].mArr_collections = mArr_t;
                
                [NotificationCenter postNotificationName:NOTIFCATION_COLLECTION object:nil userInfo:nil];
            }
            
        } Fail:^(int code, NSString *failDescript) {
            
        }];
    }
    
}

#pragma mark -
#pragma mark buttonActions

- (IBAction)btnSearchAction:(id)sender {
    
    ChildSearchVC *t_vc = [[ChildSearchVC alloc] init];
    [self.navigationController pushViewController:t_vc animated:YES];
    
    
}

- (IBAction)btnMoreAction:(id)sender {
    
    ChildMenuView * childMenuView = [ChildMenuView initCustomView];
    [self.view addSubview:childMenuView];
    [childMenuView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [childMenuView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [childMenuView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [childMenuView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [childMenuView layoutIfNeeded];
    
    [childMenuView show];
    
}


#pragma mark -dealloc

- (void)dealloc{

    NSLog(@"ChildrenMusicVC dealloc");

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
