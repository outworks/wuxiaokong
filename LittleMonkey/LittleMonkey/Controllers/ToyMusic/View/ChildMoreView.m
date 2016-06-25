//
//  ChildMoreView.m
//  HelloToy
//
//  Created by huanglurong on 16/4/22.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildMoreView.h"
#import "PureLayout.h"
#import "NDAlbumAPI.h"
#import "NDToyAPI.h"
#import "ChildAddToAlbumVC.h"
#import "NDAlarmAPI.h"
#import "TimerAddVCL.h"
#import "ChildMusicVC.h"




@interface ChildMoreView (){

    ShowHUD *_hud;
}

@property (strong,nonatomic) NSArray *arr_view;
@property (nonatomic,assign) BOOL isLikeed;
@property (nonatomic,assign) BOOL isDowned;



@property (weak, nonatomic) IBOutlet UIImageView *imageV_bg;
@property (weak, nonatomic) IBOutlet UIView *v_bottom;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;

@property (weak, nonatomic) IBOutlet UIButton *btn_first;
@property (weak, nonatomic) IBOutlet UILabel *lb_first;

@property (weak, nonatomic) IBOutlet UIButton *btn_secend;
@property (weak, nonatomic) IBOutlet UILabel *lb_secend;

@property (weak, nonatomic) IBOutlet UIButton *btn_third;
@property (weak, nonatomic) IBOutlet UILabel *lb_third;

@property (weak, nonatomic) IBOutlet UIButton *btn_fourth;
@property (weak, nonatomic) IBOutlet UILabel *lb_fourth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_bottom;


@end


@implementation ChildMoreView


+ (ChildMoreView *)initCustomView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ChildMoreView" owner:self options:nil];
    return [nibView objectAtIndex:0];
    
}

-(void)awakeFromNib{
    _arr_view = [[NSArray alloc] initWithObjects:_btn_first,_btn_third,_btn_fourth, nil];
    [_arr_view autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:20.0 insetSpacing:YES matchedSizes:YES];
    _layout_bottom.constant = -165;
    [self layoutIfNeeded];
    

}

- (IBAction)tapAction:(id)sender {
    
   [self hide];
    
}

#pragma mark - public

-(void)show{
    
    [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
        _imageV_bg.alpha = 0.5f;
    } completion:^(BOOL finished){
        
    }];
    
    [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
        _layout_bottom.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished){
        
    }];
    
}

-(void)hide{
    [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
        _imageV_bg.alpha = 0.5f;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.5 animations:^{   //老封面渐隐效果
            _layout_bottom.constant = -165;
            [self layoutIfNeeded];

        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    }];
}

#pragma mark - set&&get 

- (void)setAlbumMedia:(AlbumMedia *)albumMedia{

    if (albumMedia) {
        
        _albumMedia = albumMedia;
        _lb_title.text = _albumMedia.name;
        self.isDowned = YES;
        
    }
}

- (void)setToyPlay:(ToyPlay *)toyPlay{

    if (toyPlay) {
        
        _toyPlay = toyPlay;
        
        AlbumMedia *t_media = [[AlbumMedia alloc] init];
        t_media.media_id = _toyPlay.media_id;
        t_media.media_type = _toyPlay.media_type;
        t_media.name = _toyPlay.name;
        t_media.icon = _toyPlay.icon;
        t_media.url = _toyPlay.url;
        t_media.duration = _toyPlay.duration;
        self.albumMedia = t_media;
      
        _lb_title.text = _toyPlay.name;
    
    }

}

- (void)setDownloadMediainfo:(DownloadMediaInfo *)downloadMediainfo{

    if (downloadMediainfo) {
        
        _downloadMediainfo = downloadMediainfo;
        AlbumMedia *t_media = [[AlbumMedia alloc] init];
        t_media.media_id = _downloadMediainfo.media_id;
        t_media.media_type = _downloadMediainfo.media_type;
        t_media.name = _downloadMediainfo.name;
        t_media.icon = _downloadMediainfo.icon;
        t_media.url = _downloadMediainfo.url;
        t_media.duration = _downloadMediainfo.duration;
        self.albumMedia = t_media;
        
        _lb_title.text = downloadMediainfo.name;
        
    }
    
}

#pragma mark - 

- (void)setAlbumInfo:(AlbumInfo *)albumInfo{

    if (albumInfo) {
        
        _albumInfo = albumInfo;
        

    }
}

- (void)setIsGedan:(BOOL)isGedan{
    
    _isGedan = isGedan;
    
    if (_isGedan) {
        
        [_btn_first setImage:[UIImage imageNamed:@"child_remove"] forState:UIControlStateNormal];
        _lb_first.text = @"移除";
        
    }
    
}



- (void) setIsDowned:(BOOL)isDowned{
    
    _isDowned = isDowned;
    
    if (_isDowned) {
        
        [_btn_third setImage:[UIImage imageNamed:@"child_play"] forState:UIControlStateNormal];
        _lb_third.text = @"点播";
        
    }else{
    
        [_btn_third setImage:[UIImage imageNamed:@"child_download"] forState:UIControlStateNormal];
        _lb_third.text = @"下载";
    
    }

}


- (void)setIsLikeed:(BOOL)isLikeed{

    _isLikeed = isLikeed;
    
    if (_isLikeed) {
    
        [_btn_secend setImage:[UIImage imageNamed:@"child_like"] forState:UIControlStateNormal];
        _lb_secend.text = @"喜欢";
        
    }else{
    
        [_btn_secend setImage:[UIImage imageNamed:@"喜欢3"] forState:UIControlStateNormal];
        _lb_secend.text = @"喜欢";
    
    }
    
}



#pragma mark - buttonAciton

- (IBAction)btnFirstAciton:(id)sender {
    
    if (_isGedan) {
        
        NDAlbumDelMediaParams *params =[[NDAlbumDelMediaParams alloc] init];
        params.album_id = _albumInfo.album_id;
        params.media_id = self.albumMedia.media_id;
        [NDAlbumAPI albumDelMediaWithParams:params completionBlockWithSuccess:^{
            [ShowHUD showSuccess:@"媒体移除成功" configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:ApplicationDelegate.window];
            
            [self hide];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"移除媒体通知" object:nil];
        } Fail:^(int code, NSString *failDescript) {
            
            [ShowHUD showError:@"移除媒体失败" configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:ApplicationDelegate.window];
            
        }];
        
    }else{
        
        ChildAddToAlbumVC *t_vc = [[ChildAddToAlbumVC alloc] init];
        t_vc.albumMedia = self.albumMedia;
        
        UINavigationController *toyGuideNav = [[UINavigationController alloc]initWithRootViewController:t_vc];
        
        [ApplicationDelegate.tabBarController presentViewController:toyGuideNav animated:YES completion:^{
            
        }];
    }

}

- (IBAction)btnSecondAction:(id)sender {
    
    if (_isLikeed) {

        [self handleUnCollectionBtnActionInCell];
        
    }else{
        
        [self handleCollectionBtnActionInCell];
    
    }

}

- (IBAction)btnThirdAction:(id)sender {
    
    if (_isDowned) {
        
        [self handlePlayBtnActionInCell];
        
    }else{
        
        
    }
    
}

- (IBAction)btnFourthAction:(id)sender {
    
    __weak typeof(self) weakSelf =  self;
    
    NDAlarmAddEventParams *params = [[NDAlarmAddEventParams alloc] init];
    params.url = self.albumMedia.url;
    params.desc = self.albumMedia.name;
    [NDAlarmAPI alarmAddEventWithParams:params completionBlockWithSuccess:^(NSDictionary *data){
        
        NSNumber *event_id = [data objectForKey:@"event_id"];
        
        TimerAddVCL *vcl = [[TimerAddVCL alloc]init];
        vcl.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
        Alarm *t_alarm =  [[Alarm alloc] init];
        t_alarm.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
        t_alarm.tag = @"";
        t_alarm.enable = @1;
        t_alarm.event = event_id;
        t_alarm.event_name = weakSelf.albumMedia.name;
        
        vcl.alarm = t_alarm;
    
        UINavigationController *toyGuideNav = [[UINavigationController alloc]initWithRootViewController:vcl];
        [ApplicationDelegate.tabBarController presentViewController:toyGuideNav animated:YES completion:^{
            
        }];
        
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:@"添加失败" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
    }];
    
    
}


- (void)judgeCollection:(NSArray *)collection{
    
    if(collection && [collection count] > 0){
        
        for (int i = 0; i<[collection count]; i++) {
            
            AlbumMedia *media = collection[i];
            if ([media.media_id isEqualToNumber:self.albumMedia.media_id]) {
                self.isLikeed = YES;
                break;
            }
            
            if(i == [collection count] -1){
                self.isLikeed = NO;
            }
            
        }
        
    }else{
        
        self.isLikeed = NO;
        
    }
    
}

- (void)judgeToyPlayCollection:(NSArray *)collection{
    
    if(collection && [collection count] > 0){
        
        for (int i = 0; i<[collection count]; i++) {
            
            AlbumMedia *media = collection[i];
            if ([media.media_id isEqualToNumber:self.toyPlay.media_id]) {
                self.isLikeed = YES;
                break;
            }
            
            if(i == [collection count] -1){
                self.isLikeed = NO;
            }
            
        }
        
    }else{
        self.isLikeed = NO;
    }
    
}

/*--------------- 点播 --------------*/

- (void) handlePlayBtnActionInCell{
    

    if (![ShareValue sharedShareValue].toyDetail) {
        
        [ShowHUD showWarning:NSLocalizedString(@"当前无玩具", nil) configParameter:^(ShowHUD *config) {
        } duration:1.0f inView:ApplicationDelegate.window];
        
        return;
    }
    
    NDToyPlayMediaParams *params = [[NDToyPlayMediaParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.media_id = self.albumMedia.media_id;
    params.media_type = self.albumMedia.media_type;
    
    _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
    } inView:ApplicationDelegate.window];
    
    [NDToyAPI toyPlayMediaWithParams:params completionBlockWithSuccess:^{
        
        if (_hud) [_hud hide];
        
        [ShowHUD showSuccess:NSLocalizedString(@"点播成功", nil) configParameter:^(ShowHUD *config) {} duration:1.0f inView:ApplicationDelegate.window];
        
    } Fail:^(int code, NSString *failDescript) {
        
        if (_hud) [_hud hide];
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {} duration:1.0f inView:ApplicationDelegate.window];
        
    }];
    
}

/*--------------- 收藏 --------------*/

- (void) handleCollectionBtnActionInCell{
    
//    if ([[ShareValue sharedShareValue].mArr_collections count] >= 20) {
//        
//        [ShowHUD showWarning:NSLocalizedString(@"NotCollectTooMore", nil) configParameter:^(ShowHUD *config) {
//        } duration:1.5f inView:ApplicationDelegate.window];
//        
//        return ;
//    }

    
    _hud = [ShowHUD showText:nil configParameter:^(ShowHUD *config) {
    } inView:ApplicationDelegate.window];
    
    NDAlbumAddMediaParams *params = [[NDAlbumAddMediaParams alloc] init];
    params.album_id = [ShareValue sharedShareValue].collection_id;
    params.media_id = self.albumMedia.media_id;
    [NDAlbumAPI albumAddMediaWithParams:params completionBlockWithSuccess:^{
        
        if(_hud) [_hud hide];
        
        //[MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        self.isLikeed = YES;
        
        [ShowHUD showSuccess:NSLocalizedString(@"喜欢成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.0f inView:ApplicationDelegate.window];
        
        if ([ShareValue sharedShareValue].mArr_collections) {
            
            [[ShareValue sharedShareValue].mArr_collections addObject:self.albumMedia];
            
        }
        
        
        /*-------------- 发通知，通知收藏页面更新视图 -------------- */
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFCATION_UPDATACOLLECTION object:nil userInfo:nil];
        
    } Fail:^(int code, NSString *failDescript) {
        
        if(_hud) [_hud hide];
        
        //[MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.0f inView:ApplicationDelegate.window];
    }];
    
}

/*--------------- 取消收藏 --------------*/

- (void) handleUnCollectionBtnActionInCell{
    

    _hud = [ShowHUD showText:nil configParameter:^(ShowHUD *config) {
    } inView:ApplicationDelegate.window];
    
    NDAlbumDelMediaParams *params = [[NDAlbumDelMediaParams alloc] init];
     params.album_id = [ShareValue sharedShareValue].collection_id;
    params.media_id = self.albumMedia.media_id;
    
    [NDAlbumAPI albumDelMediaWithParams:params completionBlockWithSuccess:^{
        
        if (_hud) [_hud hide];
        
        self.isLikeed = NO;
     
        if ([ShareValue sharedShareValue].mArr_collections && [[ShareValue sharedShareValue].mArr_collections count] > 0) {
            
            [[ShareValue sharedShareValue].mArr_collections enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSLog(@"%i-%@",idx,obj);
                
                AlbumMedia *t_media = (AlbumMedia *)obj;
                
                if ([t_media.media_id isEqualToNumber:self.albumMedia.media_id]) {
                    [[ShareValue sharedShareValue].mArr_collections removeObjectAtIndex:idx];
                    
                    *stop = YES;
                }
                
            }];
        }
        
    
        [ShowHUD showSuccess:NSLocalizedString(@"取消喜欢成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.0f inView:ApplicationDelegate.window];
        
        /*-------------- 发通知，通知收藏页面更新视图 -------------- */
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFCATION_UPDATACOLLECTION object:nil userInfo:nil];
        
    } Fail:^(int code, NSString *failDescript) {
        
        if (_hud) [_hud hide];
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.0f inView:ApplicationDelegate.window];
        
    }];
    
}

#pragma mark - ButtonActions


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
