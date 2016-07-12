//
//  ToyThemeVC.m
//  HelloToy
//
//  Created by nd on 15/5/28.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "ToyThemeVC.h"
#import "NDToyAPI.h"
#import "UIButton+Block.h"
#import "NDDownLoadAPI.h"
#import "UIAlertView+BlocksKit.h"

@interface ToyThemeVC ()<AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *v_info;
@property (nonatomic,strong) NSMutableArray *arr_data;
@property (nonatomic,strong) Theme *selectedTheme;
@property (nonatomic,strong) Theme *tempTheme;
@property (nonatomic,strong) Theme *theme_play;

@property (nonatomic, strong) AVAudioPlayer *mp3Player;

@end

@implementation ToyThemeVC

#pragma mark - viewLift

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"音效主题", nil);
    _arr_data = [NSMutableArray array];
    _v_info.hidden = YES;
    [self loadThemeList];
    [self loadToyTheme];
    
}

#pragma makr - privateMethods

-(void)loadThemeList{

    NDToyThemeListParams *params = [[NDToyThemeListParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.trp_id = @20081;
    ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
    } inView:self.view];
    [NDToyAPI toyThemeListWithParams:params completionBlockWithSuccess:^(NSArray *data) {
         [hud hide];
        [_arr_data addObjectsFromArray:data];
        
        if ([_arr_data count] == 0) {
            _v_info.hidden = NO;
        }
        [self.tableView reloadData];
        
    } Fail:^(int code, NSString *failDescript) {
         [hud hide];
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }];
}

-(void)loadToyTheme{

    NDToyThemeParams *params = [[NDToyThemeParams alloc] init];
    params.toy_id  = _toy_id;
    [NDToyAPI toyThemeWithParams:params completionBlockWithSuccess:^(Theme *data) {
        _selectedTheme = data;
        
        [_tableView reloadData];
    } Fail:^(int code, NSString *failDescript) {
        NSLog(@"请求玩具主题失败..");
    }];

}

-(void)changeTheme:(Theme *)theme{

    NDToyChangeThemeParams *params = [[NDToyChangeThemeParams alloc] init];
    params.toy_id = _toy_id;
    params.theme_id = theme.theme_id;
    [NDToyAPI toyChangeThemeWithParams:params completionBlockWithSuccess:^{
        [ShowHUD showSuccess:NSLocalizedString(@"Theme切换成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.0f inView:self.view];
        
        _selectedTheme = theme;
        [_tableView reloadData];
    } Fail:^(int code, NSString *failDescript) {
        
        _tempTheme = theme;
        
        if (code == 2116) {
            UIAlertView *t_alert = [[UIAlertView alloc] initWithTitle:PROGRAMNAME message:[NSString stringWithFormat:NSLocalizedString(@"%@未下载到玩具,是否现在下载", nil),theme.name] delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
            t_alert.tag = 10;
            [t_alert show];
        }else{
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.0f inView:self.view];

        }
        
    }];

}

#pragma mark - buttonAction 

-(void)backAction:(id)sender{
    
    [self stopPlay];
    [self.navigationController popViewControllerAnimated:YES];
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
    
    Theme *theme = _arr_data[indexPath.row];
    
    cell.theme = theme;

    if (_selectedTheme) {
        if ([_selectedTheme.theme_id isEqualToNumber:theme.theme_id]) {
            cell.isSelected = YES;
        }else{
            cell.isSelected = NO;
        }
    }else{
        cell.isSelected = NO;
    }
    
    if([_theme_play.theme_id isEqualToNumber:cell.theme.theme_id]){
        cell.lb_title.textColor = [UIColor colorWithRed:0.090 green:0.706 blue:0.839 alpha:1.000];
    }else{
        cell.lb_title.textColor = [UIColor blackColor];
    }
    
    
    __weak __typeof(self)weakSelf = self;
    
    [cell.btn_tryListen setEnlargeEdgeWithTop:15.0f right:15.0f bottom:15.0f left:15.0f];
    [cell.btn_tryListen handleClickEvent:UIControlEventTouchUpInside withClickBlick:^{
        
        weakSelf.theme_play = cell.theme;
        [weakSelf.tableView reloadData];
        
        [weakSelf beginPlay:cell.theme];
        
    }];

    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Theme *theme = _arr_data[indexPath.row];
    __weak typeof(self ) weakself = self;
    if ([theme.status isEqual:@-1]) {
        UIAlertView *alertView = [[UIAlertView alloc]bk_initWithTitle:@"提醒" message:@"当前主题未下载，是否马上下载?"];
        [alertView bk_setCancelButtonWithTitle:@"取消" handler:nil];
        [alertView bk_addButtonWithTitle:@"下载" handler:^{
            [weakself downloadTheme:theme];
        }];
        [alertView show];
    }else if([theme.status isEqual:@0]){
        [self changeTheme:theme];
    }else if([theme.status isEqual:@1]){
        UIAlertView *alertView = [[UIAlertView alloc]bk_initWithTitle:@"提醒" message:@"当前主题有新的更新，是否马上下载?"];
        [alertView bk_setCancelButtonWithTitle:@"取消" handler:^{
            [weakself changeTheme:theme];
        }];
        [alertView bk_addButtonWithTitle:@"下载" handler:^{
            [weakself changeTheme:theme];
            [weakself downloadTheme:theme];
        }];
        [alertView show];
    }
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 10) {
        if (buttonIndex == 1) {
            
            ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
            } inView:self.view];
            
            NDDownloadAddParams *params = [[NDDownloadAddParams alloc] init];
            params.toy_id = _toy_id;
            params.content_type = @1;
            params.content_id = _tempTheme.theme_id;
            [NDDownLoadAPI downloadAddWithParams:params completionBlockWithSuccess:^{
                [hud hide];
                [ShowHUD showSuccess:NSLocalizedString(@"请求成功", nil) configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:self.view];
            } Fail:^(int code, NSString *failDescript) {
                [hud hide];
                [ShowHUD showError:NSLocalizedString(@"请求失败", nil) configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:self.view];
            }];
        }
    
    }

}


#pragma mark - 下载主题

-(void)downloadTheme:(Theme *)theme{
    __weak typeof(self) weakself = self;
    NDDownloadAddParams *params = [[NDDownloadAddParams alloc]init];
    params.content_type = @1;
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.content_id = theme.theme_id;
    [NDDownLoadAPI downloadAddWithParams:params completionBlockWithSuccess:^{
        [ShowHUD showSuccess:@"已发送下载主题指令" configParameter:^(ShowHUD *config) {
            
        } duration:1 inView:self.view];
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.0f inView:weakself.view];
    }];
}

-(void)downloadMail:(Theme *)theme success:(void(^)(NSURL *fileUrl))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    if (theme.localUrl.length>0) {
        success([NSURL fileURLWithPath:theme.localUrl]);
        return;
    }
    [NDBaseAPI downloadFile:[NSURL URLWithString:theme.preview_url] fileid:[theme.theme_id stringValue] downloadProgress:^(float progress) {
        
    } successBlock:^(NSURL *filepath) {
        theme.localUrl = filepath.path;
        success([NSURL fileURLWithPath:theme.localUrl]);
    } errorBlock:^(NSString *descript) {
        fail(YES,descript);
    }];
}

-(void) beginPlay:(Theme*) theme {
    if (nil == theme) {
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    if ([theme.localUrl length] != 0) {
        
        NSString *saveDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *savePath = [saveDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[theme.localUrl lastPathComponent]]];
        NSURL *fileUrl_play = [NSURL fileURLWithPath:savePath];
        
        [weakSelf playUrl:fileUrl_play];
        
    }else {
        
        [self downloadMail:theme success:^(NSURL *fileUrl) {
            
            NSString *saveDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *savePath = [saveDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[theme.localUrl lastPathComponent]]];
            NSURL *fileUrl_play = [NSURL fileURLWithPath:savePath];
            
            [weakSelf playUrl:fileUrl_play];
            
        }fail:^(BOOL notReachable, NSString *desciption) {
            
            
        }];
    }
}

-(void) playUrl:(NSURL *)url{
    
    //设置audio session的category
    [self stopPlay];
    
    if (self.mp3Player) {
        [self.mp3Player stop];
        self.mp3Player.delegate = nil;
        self.mp3Player = nil;
    }
    NSError *error = nil;
    NSLog(@"%@",url.path);
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    self.mp3Player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];;
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
        [self onPlayError];
    }
    self.mp3Player.delegate = self;
    [self.mp3Player stop];
    [self.mp3Player prepareToPlay];
    [self.mp3Player play];
}

#pragma mark - 停止播放

-(void) stopPlay{
    
    if (self.mp3Player.isPlaying) {
        [self.mp3Player stop];
        self.mp3Player.delegate = nil;
        self.mp3Player = nil;
    }

}


-(void)onPlayFinish{
    [self stopPlay];
    self.theme_play = nil;
    [self.tableView reloadData];

}

-(void)onPlayError{
    [self stopPlay];
    self.theme_play = nil;
    [self.tableView reloadData];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
     [self onPlayFinish];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    [self onPlayFinish];
    
}


#pragma mark - dealloc 

-(void)dealloc{
    
    NSLog(@"ToyThemeVC dealloc");
    [self stopPlay];
    
    for (Theme *theme in self.arr_data) {
        if (theme.localUrl.length > 0) {
            NSString *saveDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *savePath = [saveDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[theme.localUrl lastPathComponent]]];
            NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *downloadPath = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[theme.localUrl lastPathComponent]]];
            
            NSFileManager * fileManager = [[NSFileManager alloc]init];
            [fileManager removeItemAtPath:savePath error:nil];
            [fileManager removeItemAtPath:downloadPath error:nil];
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
