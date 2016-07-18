//
//  ChildRecomVC.m
//  HelloToy
//
//  Created by huanglurong on 16/4/12.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildRecomVC.h"
#import "KDCycleBannerView.h"

#import "ChildSortCell.h"
#import "XMSDK.h"
#import "ChildHotView.h"
#import "ChildAlbumListVC.h"
#import "PureLayout.h"
#import "ChildMusicVC.h"
#import "ChildAlbumDetailVC.h"
#import "UIScrollView+PullTORefresh.h"


@interface ChildRecomVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (strong, nonatomic) KDCycleBannerView *v_cycle;

@property (strong,nonatomic)  NSMutableArray *mArr_tag; // 标签分类，这个为定死的数据
@property (strong,nonatomic)  NSMutableArray *mArr_hot; //推荐
@property (strong, nonatomic) NSMutableArray *mArr_tagData; //更多分类数据

@end

@implementation ChildRecomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"喜马拉雅";
    
    [self initData];
    __weak typeof(self) weakself = self;
    [self.tb_content addPullScrollingWithActionHandler:^{
        [weakself reloadData];
    }];
    [self.tb_content triggerPullScrolling];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)reloadData{
    __weak typeof(self) weakSelf = self;
    GCDGroup *group = [GCDGroup new];
    [[GCDQueue globalQueue] execute:^{
        
        [weakSelf queryTagList:@6];
      
    } inGroup:group];
    
    [[GCDQueue globalQueue] execute:^{
        [weakSelf queryHotList];
    } inGroup:group];
    

    [[GCDQueue mainQueue] notify:^{
        
        GCDGroup *grouptag = [GCDGroup new];
        
        if ([_mArr_tag count] > 0) {
            [_mArr_tag removeAllObjects];
        }
        
        for (int index = 0; index < 6; index++) {
            XMTag *tag = weakSelf.mArr_tagData[index];
            [self initDicInArray:tag.tagName withIndex:@(index)];
            
            [[GCDQueue globalQueue] execute:^{
                [weakSelf queryAlbumList:@6 withTagName:tag.tagName];
            } inGroup:grouptag];
            
        }
        
        [[GCDQueue mainQueue] notify:^{
            
            [weakSelf.tb_content.pullScrollingView stopAnimating];
            [weakSelf.tb_content reloadData];
        } inGroup:grouptag];
    } inGroup:group];


}

#pragma mark - private 

- (void) initData{

    _mArr_tag = [NSMutableArray new];
    
//    NSArray *t_data = [NSMutableArray arrayWithObjects:@"儿歌大全",@"睡前故事",@"儿童英语",@"儿童学习",@"儿童教育",@"绘本故事",nil];
//  
//    for (NSString *tagName in t_data) {
//        
//        NSNumber *index = [NSNumber numberWithInteger:[t_data indexOfObject:tagName]] ;
//        [self initDicInArray:tagName withIndex:index];
//        
//    }
 
}

- (void)initDicInArray:(NSString *)tagName withIndex:(NSNumber *)index{

    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:tagName forKey:@"tag"];
    [dic setObject:index forKey:@"index"];
    [_mArr_tag addObject:dic];

}

- (void)pushChildAlbumListVC:(NSString *)tagName{

    ChildAlbumListVC *t_vc = [[ChildAlbumListVC alloc] init];
    t_vc.tagName = tagName;
    id target = self.view;
    
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[ChildMusicVC class]]) {
            break;
        }
    }
    
    ChildMusicVC *vc_target = (ChildMusicVC *)target;
    
    [vc_target.navigationController pushViewController:t_vc animated:YES];

}

- (void)pushChildAlbumDetailVC:(XMAlbum *)album{
    
    ChildAlbumDetailVC *t_vc = [[ChildAlbumDetailVC alloc] init];
    t_vc.album_xima = album;
    
    id target = self.view;
    
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[ChildMusicVC class]]) {
            break;
        }
    }
    
    ChildMusicVC *vc_target = (ChildMusicVC *)target;
    
    [vc_target.navigationController pushViewController:t_vc animated:YES];
    
}


- (void)queryTagList:(NSNumber *)category_id{

    __weak typeof(self) weakSelf = self;
    GCDSemaphore *semaphore = [GCDSemaphore new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:category_id forKey:@"category_id"];
    [params setObject:@0 forKey:@"type"];
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_TagsList params:params withCompletionHander:^(id result, XMErrorModel *error) {
        
        if (!error) {
            
            weakSelf.mArr_tagData = [self showReceivedData:result className:@"XMTag" valuePath:nil ];
//            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//            [weakSelf.tb_content reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
             [weakSelf.tb_content reloadData];
            
        }else{
        
          NSLog(@"%@   %@",error.description,result);
            
        }
        [semaphore signal];
    }];
    [semaphore wait];

}

- (void)queryAlbumList:(NSNumber *)category_id withTagName:(NSString *)tagName{

    __weak typeof(self) weakSelf = self;
    GCDSemaphore *semaphore = [GCDSemaphore new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:category_id forKey:@"category_id"];
    [params setObject:tagName forKey:@"tag_name"];
//    [params setObject:@"1" forKey:@"calc_dimension"];
    [params setObject:@3 forKey:@"count"];
    [params setObject:@1 forKey:@"page"];
    
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_AlbumsHot params:params withCompletionHander:^(id result, XMErrorModel *error) {
        if(!error && result){

            NSArray *date = [self showReceivedData:result className:@"XMAlbum" valuePath:@"albums"];
            
            for (NSMutableDictionary *t_dic in weakSelf.mArr_tag) {
                NSString *t_tagName = [t_dic objectForKey:@"tag"];
                if ([t_dic isKindOfClass:[NSDictionary class]]) {
                    
                }
                if ([t_tagName isEqualToString:tagName]) {
                    
                    [t_dic setObject:date forKey:@"albums"];
//                    NSNumber *row = [t_dic objectForKey:@"index"];
//                    
//                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[row integerValue] inSection:0];
//                    [weakSelf.tb_content reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                     [weakSelf.tb_content reloadData];
                    break;
                }
            }
        
        }else{
            
            NSLog(@"%@   %@",error.description,result);
            
        }
        [semaphore signal];
    }];
    [semaphore wait];
}

- (void)queryHotList{

    GCDSemaphore *semaphore = [GCDSemaphore new];
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@10 forKey:@"channel"];
    [params setObject:@10 forKey:@"app_version"];
    
    if (ScreenHeight >= HeightFor4p7InchScreen) {
        
        [params setObject:@3 forKey:@"image_scale"];
        
    }else{
        
        [params setObject:@2 forKey:@"image_scale"];
        
    }
    
    [params setObject:@6 forKey:@"category_id"];
    [params setObject:@"album" forKey:@"content_type"];
    
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_CategoryBanner params:params withCompletionHander:^(id result, XMErrorModel *error) {
        
        if (!error) {
            
            weakSelf.mArr_hot = [NSMutableArray new];
            
            NSArray *t_data = [self showReceivedData:result className:@"XMBanner" valuePath:nil];
            for (XMBanner *t_banner in t_data) {
                if (t_banner.albumId != 0) {
                    [weakSelf.mArr_hot addObject:t_banner];
                }
            }
            
            [weakSelf resetBannerDatas:[weakSelf.mArr_hot count]];
            
        }else{
        
            NSLog(@"%@",error.description);
        }
        [semaphore signal];
    }];
    [semaphore wait];
    
}


//设置轮播图
- (void)resetBannerDatas:(NSInteger)count{
    
    __weak typeof(self) weakSelf = self;
    
    if (self.v_cycle != nil) {
        [self.v_cycle removeFromSuperview];
        self.tb_content.tableHeaderView = nil;
    }
    
    UIView *t_v = [[UIView alloc] init];
    
    self.v_cycle = [[KDCycleBannerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 135)];
    CGRect frame = self.v_cycle.pageControl.frame ;
    frame.origin.x = ([UIScreen mainScreen].bounds.size.width - (count * 25))/2.0;
    self.v_cycle.pageControl.frame = frame;
    self.v_cycle.delegate = (id<KDCycleBannerViewDelegate>)self;
    self.v_cycle.datasource = (id<KDCycleBannerViewDataource>)self;
    self.v_cycle.continuous = YES;
    self.v_cycle.autoPlayTimeInterval = 3.f;
    [t_v  addSubview:self.v_cycle];
    
    ChildHotView *v_childHot  = [[[NSBundle mainBundle] loadNibNamed:@"ChildHotView" owner:nil options:nil] lastObject];
    v_childHot.block = ^(){
        
        [weakSelf pushChildAlbumListVC:nil];
    
    };
    
    [t_v addSubview:v_childHot];
    [v_childHot autoSetDimension:ALDimensionHeight toSize:55.0];
    [v_childHot autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [v_childHot autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [v_childHot autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    
    [t_v setFrame:CGRectMake(0, 0, ScreenWidth, 190)];
    
    self.tb_content.tableHeaderView = t_v;
    
    [self.tb_content reloadData];
}



- (NSMutableArray *)showReceivedData:(id)result className:(NSString*)className valuePath:(NSString *)path
{
    NSMutableArray *models = [NSMutableArray array];
    Class dataClass = NSClassFromString(className);
    if([result isKindOfClass:[NSArray class]]){
        for (NSDictionary *dic in result) {
            id model = [[dataClass alloc] initWithDictionary:dic];
            [models addObject:model];
        }
    }
    else if([result isKindOfClass:[NSDictionary class]]){
        if(path.length == 0)
        {
            id model = [[dataClass alloc] initWithDictionary:result];
            [models addObject:model];
        }
        else
        {
            for (NSDictionary *dic in result[path]) {
                id model = [[dataClass alloc] initWithDictionary:dic];
                [models addObject:model];
            }
        }
    }
  
    return models;
}

#pragma mark - cycleBannerViewDataource

- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView{
    NSMutableArray *t_arr = [NSMutableArray array];
    for (int i= 0 ; i < _mArr_hot.count; i++) {
       
        XMBanner *album = _mArr_hot[i];
        
        if (NSStringIsValid(album.bannerUrl)) {
            
            [t_arr addObject:[NSURL URLWithString:album.bannerUrl]];
            
        }

    }
    if ([t_arr count] == 1) {
        
        bannerView.continuous = NO;
        
    }
    
    return t_arr;
}

- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index{
    
    return UIViewContentModeScaleToFill;
    
}

- (UIImage *)placeHolderImageOfZeroBannerView{
    
    return [UIImage imageNamed:@"scrollViewplaceholder"];
    
}

- (UIImage *)placeHolderImageOfBannerView:(KDCycleBannerView *)bannerView atIndex:(NSUInteger)index{
    
    return [UIImage imageNamed:@"scrollViewplaceholder"];
    
}

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didScrollToIndex:(NSUInteger)index{
    
    
    
}

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index{
   
    XMBanner *t_banner = _mArr_hot[index];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(t_banner.albumId) forKey:@"album_id"];
    [params setObject:@1 forKey:@"count"];
    [params setObject:@1 forKey:@"page"];
    
    __weak typeof(self) weakSelf = self;
    
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_AlbumsBrowse params:params withCompletionHander:^(id result, XMErrorModel *error) {
        
        if(!error){
            
            NSArray *data = [self showReceivedData:result className:@"XMTrack" valuePath:@"tracks"];
            if (data.count == 0) {
                [ShowHUD showError:@"没有找到内容" configParameter:^(ShowHUD *config) {
                    
                } duration:2 inView:weakSelf.view];
                return;
            }
            ChildAlbumDetailVC *t_vc = [[ChildAlbumDetailVC alloc] init];
            XMTrack *t_track = data[0];
            XMAlbum *album_xima = [[XMAlbum alloc] init];
            album_xima.albumId = t_track.subordinatedAlbum.albumId;
            album_xima.coverUrlSmall = t_track.subordinatedAlbum.coverUrlSmall;
            album_xima.coverUrlMiddle = t_track.subordinatedAlbum.coverUrlMiddle;
            album_xima.coverUrlLarge = t_track.subordinatedAlbum.coverUrlLarge;
            album_xima.albumTitle = t_track.subordinatedAlbum.albumTitle;
            album_xima.includeTrackCount = [(NSNumber *)[(NSDictionary *)result objectForKey:@"total_count"] integerValue];
            t_vc.album_xima = album_xima;
    
            id target = weakSelf.view;
            
            while (target) {
                target = ((UIResponder *)target).nextResponder;
                if ([target isKindOfClass:[ChildMusicVC class]]) {
                    break;
                }
            }
            
            ChildMusicVC *vc_target = (ChildMusicVC *)target;
            
            [vc_target.navigationController pushViewController:t_vc animated:YES];
            
            //[self.navigationController pushViewController:t_vc animated:YES];

        }else{
        
        }
        
    }];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return [_mArr_tag count];
        
    } else {
        
        return 1;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    ChildSortCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildSortCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ChildSortCell" bundle:nil] forCellReuseIdentifier:@"ChildSortCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChildSortCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        NSMutableDictionary *t_dic = _mArr_tag[indexPath.row];
        NSArray *t_arrAlbum = [t_dic objectForKey:@"albums"];
        cell.ChildTag = [t_dic objectForKey:@"tag"];
        
        if (t_arrAlbum) {
            
            cell.isLoaded = YES;
            cell.mArr_album = [NSMutableArray arrayWithArray:t_arrAlbum];
            cell.block_album = ^(ChildSortCell *cell,XMAlbum *album){
            
                [weakSelf pushChildAlbumDetailVC:album];
                
                
            };
            
        }else{
            
            cell.isLoaded = NO;
            
        }
        
        
        
        cell.block_more = ^(ChildSortCell *cell){
            
            [weakSelf pushChildAlbumListVC:cell.ChildTag];
           
        };
        
        
    }else{
        cell.ChildTag = @"更多分类";
        

        if (_mArr_tagData && [_mArr_tagData count] > 0) {
            
            cell.isLoaded = YES;
            cell.mArr_tag = _mArr_tagData;
            
        }else{
        
            cell.isLoaded = NO;
        }
        
        __weak typeof(self) weakSelf = self;
        
        cell.block_tag = ^(ChildSortCell *cell, XMTag *tag){
            
            [weakSelf pushChildAlbumListVC:tag.tagName];

        };
        
    
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return (ScreenWidth - 4*15)/3 + 100.0;
        
    }else{
        
        if (_mArr_tagData && [_mArr_tagData count] > 0) {
            
            if ([_mArr_tagData count] % 3 == 0) {
                
                return 40 + [_mArr_tagData count]/3*33;
                
            }else{
                
                return 40 + ([_mArr_tagData count]/3 + 1 )*33 ;
                
            }
                    
        }else{
            
            return 201;
            
        }
        
        
    }

}

#pragma mark - scrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    if (scrollView == self.tb_content)
//    {
//        if (scrollView.contentOffset.y < 0) {
//            CGPoint position = CGPointMake(0, 0);
//            [scrollView setContentOffset:position animated:NO];
//            return;
//        }
//    }
//}

#pragma mark - dealloc

- (void)dealloc{

    NSLog(@"ChildRecomVC dealloc");
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
