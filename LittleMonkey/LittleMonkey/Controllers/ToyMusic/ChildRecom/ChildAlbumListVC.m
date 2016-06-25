//
//  ChildAlbumListVC.m
//  HelloToy
//
//  Created by huanglurong on 16/4/18.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildAlbumListVC.h"
#import "XMSDK.h"
#import "ChildAlbumListCell.h"
#import "ChildAlbumDetailVC.h"
#import "UIScrollView+SVInfiniteScrolling.h"


@interface ChildAlbumListVC (){
    ShowHUD *_hud;
}

@property (weak, nonatomic) IBOutlet UITableView *tb_content;

@property (nonatomic,strong) NSMutableArray *mArr_data;
@property (assign,nonatomic) NSInteger      page_album;
@property (assign,nonatomic) BOOL           isAlbumLastPage;

@end

@implementation ChildAlbumListVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initialize];
    
    __weak typeof(self) weakSelf = self;
    
    [_tb_content addInfiniteScrollingWithActionHandler:^{
    
        [weakSelf queryAlbumList:@6 withTagName:_tagName];
      
    }];

    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private

- (void)initialize{
    
    if (_tagName) {
        
        self.navigationItem.title = _tagName;
        
    }else{
    
        self.navigationItem.title = @"儿童排行榜";
        
    }
    
    _mArr_data = [NSMutableArray array];
    _isAlbumLastPage = NO;
    _page_album = 1;
   
    [self queryAlbumList:@6 withTagName:_tagName];
}



- (void)queryAlbumList:(NSNumber *)category_id withTagName:(NSString *)tagName{
    
    __weak typeof(self) weakSelf = self;
    
    if (_page_album == 1) {
        _tb_content.showsInfiniteScrolling = NO;
    }else{
        _tb_content.showsInfiniteScrolling = !_isAlbumLastPage;
    }
    
    if (_page_album == 1) {
        _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
        } inView:self.view];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:category_id forKey:@"category_id"];
    if (tagName) {
        
        [params setObject:tagName forKey:@"tag_name"];
        
    }
    [params setObject:@1 forKey:@"calc_dimension"];
    [params setObject:@20 forKey:@"count"];
    [params setObject:[NSNumber numberWithInteger:_page_album] forKey:@"page"];
    
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_AlbumsList params:params withCompletionHander:^(id result, XMErrorModel *error) {
        
        if(!error){
            
            NSArray *data = [self showReceivedData:result className:@"XMAlbum" valuePath:@"albums"];
            
            
            if (_hud) [_hud hide];
            [weakSelf.tb_content.infiniteScrollingView stopAnimating];
            
            if ([data count] < 20) {
                
                weakSelf.isAlbumLastPage = YES;
                
            }
            [weakSelf.mArr_data addObjectsFromArray:data];
            
            weakSelf.tb_content.showsInfiniteScrolling = !weakSelf.isAlbumLastPage;
            [weakSelf.tb_content reloadData];
            
            weakSelf.page_album ++;
        
        }else{
            
            NSLog(@"%@   %@",error.description,result);
            if (_hud) [_hud hide];
        
            [weakSelf.tb_content.infiniteScrollingView stopAnimating];
            [weakSelf.tb_content reloadData];
            
            [ShowHUD showError:error.description configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:weakSelf.view];
            
        }
        
    }];
    
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

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_mArr_data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 81.0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChildAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildAlbumListCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ChildAlbumListCell" bundle:nil] forCellReuseIdentifier:@"ChildAlbumListCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChildAlbumListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    XMAlbum * album = _mArr_data[indexPath.row];
    cell.album = album;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XMAlbum * album = _mArr_data[indexPath.row];
    
    ChildAlbumDetailVC *t_vc = [[ChildAlbumDetailVC alloc] init];
    t_vc.album_xima = album;
    
    [self.navigationController pushViewController:t_vc animated:YES];
}


#pragma mark - dealloc

- (void)dealloc{

    NSLog(@"ChildAlbumListVC dealloc");
    
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
