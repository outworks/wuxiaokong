//
//  ChildCommonCell.m
//  HelloToy
//
//  Created by huanglurong on 16/4/19.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "ChildCommonCell.h"
#import "ChildMoreView.h"
#import "UIImageView+WebCache.h"
#import "PureLayout.h"


#import "MedioImageView.h"

@interface ChildCommonCell ()<FSAudioControllerDelegate>

@property (weak, nonatomic) IBOutlet MedioImageView *imgV_icon;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;


@property (weak, nonatomic) IBOutlet UIButton *btn_more;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_download;



@end



@implementation ChildCommonCell



- (id)initWithCoder:(NSCoder *)code{

    self = [super initWithCoder:code];
    
    if (self) {
          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadStatusChangeAction:) name:NOTIFICATION_REMOTE_DOWNLOAD object:nil];
    
    }

    return self;
    
}
    
-(void)initFSPlay{
    if (!audioController_cell) {
        audioController_cell = [[FSAudioController alloc] init];
        audioController_cell.delegate = self;
        [audioController_cell setVolume:0.5];
        
        __weak ChildCommonCell *weakSelf = self;
        
        audioController_cell.onStateChange = ^(FSAudioStreamState state) {
            switch (state) {
                case kFsAudioStreamRetrievingURL:{
                    
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                    NSLog(@"kFsAudioStreamRetrievingURL");
                    break;
                }
                case kFsAudioStreamStopped:{
                    
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    NSLog(@"kFsAudioStreamStopped");
                    break;
                }
                case kFsAudioStreamBuffering: {
                    
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                    NSLog(@"kFsAudioStreamBuffering");
                    
                    break;
                }
                    
                case kFsAudioStreamSeeking:{
                    NSLog(@"kFsAudioStreamBuffering");
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                    
                    break;
                }
                case kFsAudioStreamPlaying:{
                    NSLog(@"kFsAudioStreamPlaying");
                    break;
                }
                case kFsAudioStreamFailed:{
                    NSLog(@"kFsAudioStreamFailed");
                    break;
                }
                case kFsAudioStreamPlaybackCompleted:{
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"播放完刷新" object:nil userInfo:nil];
                    
                    NSLog(@"kFsAudioStreamPlaybackCompleted");
                    break;
                }
                case kFsAudioStreamRetryingStarted:{
                    NSLog(@"kFsAudioStreamRetryingStarted");
                    break;
                }
                case kFsAudioStreamRetryingSucceeded:{
                    NSLog(@"kFsAudioStreamRetryingSucceeded");
                    break;
                }
                case kFsAudioStreamRetryingFailed:{
                    NSLog(@"kFsAudioStreamRetryingFailed");
                    break;
                }
                default:
                    break;
            }
        };
        
        audioController_cell.onFailure = ^(FSAudioStreamError error, NSString *errorDescription) {
            NSString *errorCategory;
            
            switch (error) {
                case kFsAudioStreamErrorOpen:
                    errorCategory = @"Cannot open the audio stream: ";
                    break;
                case kFsAudioStreamErrorStreamParse:
                    errorCategory = @"Cannot read the audio stream: ";
                    break;
                case kFsAudioStreamErrorNetwork:
                    errorCategory = @"Network failed: cannot play the audio stream: ";
                    break;
                case kFsAudioStreamErrorUnsupportedFormat:
                    errorCategory = @"Unsupported format: ";
                    break;
                case kFsAudioStreamErrorStreamBouncing:
                    errorCategory = @"Network failed: cannot get enough data to play: ";
                    break;
                default:
                    errorCategory = @"Unknown error occurred: ";
                    break;
            }
        };
        
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _layout_download.constant = 0.0f;
    [self layoutIfNeeded];
    [self updateConstraints];
    self.isGedan = NO;

    
//    self.imgV_icon.layer.cornerRadius = 44/2;
//    self.imgV_icon.layer.masksToBounds = YES;
//    self.imgV_icon.layer.borderWidth = 1.0f;
//    self.imgV_icon.layer.borderColor = [[UIColor clearColor] CGColor];

    // Initialization code
}

-(void)downloadStatusChangeAction:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    NSNumber *media_id = [dict objectForKey:@"media_id"];
    if ([_downloadStatus.media_id isEqualToNumber:media_id]) {
        _downloadStatus.download = @1;
        [self setDownloadStatus:_downloadStatus];
        [self.lb_title setTextColor:[UIColor redColor]];
        __weak typeof(self) weakself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.lb_title setTextColor:[UIColor blackColor]];
        });
    }
    if ([_albumMedia.media_id isEqualToNumber:media_id]) {
        _albumMedia.status = @1;
        [self setAlbumMedia:_albumMedia];
        [self.lb_title setTextColor:[UIColor redColor]];
        __weak typeof(self) weakself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.lb_title setTextColor:[UIColor blackColor]];
        });
    }
    if ([_downloadMediaInfo.media_id isEqualToNumber:media_id]) {
        _downloadMediaInfo.status = @1;
        [self setDownloadMediaInfo:_downloadMediaInfo];
        [self.lb_title setTextColor:[UIColor redColor]];
        __weak typeof(self) weakself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.lb_title setTextColor:[UIColor blackColor]];
        });
    }
    
}



- (IBAction)btnMoreAction:(id)sender {
    
    if (_isLocal) {
        
    
    }else{
    
        [ShowHUD showWarning:@"请先下载媒体" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
    }
    
    
}


- (void)btnTryListen:(NSNumber *)media_id WithUrl:(NSString *)url{

    NSNumber *media_id_current;
    [self initFSPlay];
    if (_album_xima) {
        media_id_current = @(_album_xima.trackId);
    }
    
    if (_albumMedia) {
        media_id_current = _albumMedia.media_id;
    }
    
    if (_toyPlay) {
        media_id_current = _toyPlay.media_id;
    }
    
    if (_downloadMediaInfo) {
        media_id_current = _downloadMediaInfo.media_id;
    }
    
    if (audioController_cell.isPlaying == YES) {
        
        if ([media_id isEqualToNumber:media_id_current]) {
            [audioController_cell stop];
        
        }else{
            [audioController_cell stop];
            
            FSPlaylistItem *item = [[FSPlaylistItem alloc] init];
            item.title = url;
            item.url = [NSURL URLWithString:url];
            audioController_cell.url = item.url;
            [audioController_cell play];
            
        }
        
    }else{
        
        if ([media_id isEqualToNumber:media_id_current]) {
            
            [audioController_cell stop];
            
        }else{
            
            [audioController_cell stop];
            
            FSPlaylistItem *item = [[FSPlaylistItem alloc] init];
            item.title = url;
            item.url = [NSURL URLWithString:url];
            
            audioController_cell.url = item.url;
            [audioController_cell play];
            
        }
    }
    
   
    for (UIView* next = [self superview]; next; next = next.superview) {
        if ([next isKindOfClass:[UITableView class]]) {
            [(UITableView *)next reloadData];
        }
        
    }
    
}

- (void)setPlayMediaId:(NSNumber *)playMediaId{

    _playMediaId = playMediaId;
    
    NSNumber *media_id_current;
    
    if (_album_xima) {
        media_id_current = @(_album_xima.trackId);
    }
    
    if (_albumMedia) {
        media_id_current = _albumMedia.media_id;
    }
    
    if (_toyPlay) {
        media_id_current = _toyPlay.media_id;
    }
    
    if (_downloadMediaInfo) {
        media_id_current = _downloadMediaInfo.media_id;
    }
    
    if (_playMediaId) {
        if ([_playMediaId isEqualToNumber:media_id_current]) {
            self.isPlay = YES;
        }else{
            self.isPlay = NO;
        }
    }else{
        self.isPlay = NO;
    }


}


- (void)setIsPlay:(BOOL)isPlay{

    _isPlay = isPlay;
    
    [_imgV_icon playing:_isPlay];
}


- (void)setAlbum_xima:(XMTrack *)album_xima{

    if (album_xima) {
    
        _album_xima = album_xima;
    
        [_imgV_icon setImageWithURL:[NSURL URLWithString:_album_xima.coverUrlMiddle] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        _lb_title.text = _album_xima.trackTitle;
        
    }
    
}


- (void)setDownloadStatus:(MediaDownloadStatus *)downloadStatus{

    if (downloadStatus) {
     
        _downloadStatus = downloadStatus;
        
        if ([_downloadStatus.download isEqualToNumber:@0]) {
            
            _isLocal = NO;
            
            [_btn_status setImage:[UIImage imageNamed:@"child_下载"] forState:UIControlStateNormal];
            [_btn_status setTitle:@"下载到玩具" forState:UIControlStateNormal];
            _btn_status.userInteractionEnabled = YES;
            
            
        }else if ([_downloadStatus.download isEqualToNumber:@1]){
        
            _isLocal = YES;
            [_btn_status setImage:[UIImage imageNamed:@"child_功能菜单"] forState:UIControlStateNormal];
            [_btn_status setTitle:@"功能选择" forState:UIControlStateNormal];
            _btn_status.userInteractionEnabled = YES;
            
        }else{
        
            _isLocal = NO;
            
            [_btn_status setImage:[UIImage imageNamed:@"child_下载中"] forState:UIControlStateNormal];
            [_btn_status setTitle:@"玩具下载中" forState:UIControlStateNormal];
            _btn_status.userInteractionEnabled = NO;
            
        }
        
    }
}



- (void)setAlbumMedia:(AlbumMedia *)albumMedia{

    if (albumMedia) {
        
        _albumMedia = albumMedia;
        [_imgV_icon setImageWithURL:[NSURL URLWithString:_albumMedia.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        _lb_title.text = _albumMedia.name;
        

        switch (albumMedia.download.intValue) {
            case 0:
                [_btn_status setImage:[UIImage imageNamed:@"child_下载"] forState:UIControlStateNormal];
                 [_btn_status setTitle:@"下载到玩具" forState:UIControlStateNormal];
                _btn_status.userInteractionEnabled = YES;
                
                break;
            case 1:
                [_btn_status setImage:[UIImage imageNamed:@"child_功能菜单"] forState:UIControlStateNormal];
                [_btn_status setTitle:@"功能选择" forState:UIControlStateNormal];
                _btn_status.userInteractionEnabled = YES;
                
                break;
            case 2:
                [_btn_status setImage:[UIImage imageNamed:@"child_下载中"] forState:UIControlStateNormal];
                [_btn_status setTitle:@"玩具下载中" forState:UIControlStateNormal];
                _btn_status.userInteractionEnabled = NO;
                break;
            default:
                break;
        }
         _isLocal = YES;
        
    }

}

- (void)setToyPlay:(ToyPlay *)toyPlay{
    
    if (toyPlay) {
        
        _toyPlay = toyPlay;
        [_imgV_icon setImageWithURL:[NSURL URLWithString:_toyPlay.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        _lb_title.text = _toyPlay.name;
        
        _btn_status.userInteractionEnabled = YES;
        
        [_btn_status setImage:[UIImage imageNamed:@"child_功能菜单"] forState:UIControlStateNormal];
        [_btn_status setTitle:@"功能选择" forState:UIControlStateNormal];
         _isLocal = YES;
        
    }

}


- (void)setDownloadMediaInfo:(DownloadMediaInfo *)downloadMediaInfo{
    
    if (downloadMediaInfo) {

        _downloadMediaInfo = downloadMediaInfo;
        
        [_imgV_icon setImageWithURL:[NSURL URLWithString:_downloadMediaInfo.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        _lb_title.text = _downloadMediaInfo.name;
        
        
        
        if ([_downloadMediaInfo.download isEqualToNumber:@1]) {
            
            [_btn_status setImage:[UIImage imageNamed:@"child_功能菜单"] forState:UIControlStateNormal];
            [_btn_status setTitle:@"功能选择" forState:UIControlStateNormal];
            _btn_status.userInteractionEnabled = YES;
            
            _isLocal = YES;
            
        }else{
        
            [_btn_status setImage:[UIImage imageNamed:@"child_下载中"] forState:UIControlStateNormal];
            [_btn_status setTitle:@"玩具下载中" forState:UIControlStateNormal];
            _btn_status.userInteractionEnabled = NO;
            
            _isLocal = NO;
            
            [self layoutIfNeeded];
        }
        
        
    }

}

-(void)setHideMore:(BOOL)hideMore{
    _hideMore = hideMore;
    [_btn_more setHidden:YES];
    _layout_download.constant = 0;
    [self updateConstraints];
}

-(void)setHideStuats:(BOOL)hideStuats{
    _hideStuats = hideStuats;
    [_btn_status setHidden:YES];
}


- (IBAction)btnStatusAciton:(id)sender {
    
    NSLog(@"play");
    
    if (_isLocal) {
        
        __weak typeof(self) weakSelf = self;
        
        _block_more = ^(){
            
            UIViewController *vc;
            
            for (UIView* next = [weakSelf superview]; next; next = next.superview) {
                UIResponder* nextResponder = [next nextResponder];
                if ([nextResponder isKindOfClass:[UIViewController class]]) {
                    vc = (UIViewController*)nextResponder;
                    break;
                }
            }
            
            ChildMoreView *childMoreView = [ChildMoreView initCustomView];
            childMoreView.isGedan = weakSelf.isGedan;

            if (weakSelf.albumInfo) {
                childMoreView.albumInfo = weakSelf.albumInfo;
            }
            
            if (weakSelf.albumMedia) {
                
                childMoreView.albumMedia = weakSelf.albumMedia;
                
            }else if (weakSelf.downloadMediaInfo){
                
                childMoreView.downloadMediainfo = weakSelf.downloadMediaInfo;
                
            }else if (weakSelf.toyPlay){
                
                childMoreView.toyPlay = weakSelf.toyPlay;
                
            }else if (weakSelf.album_xima){
                
                AlbumMedia *t_albumMedia = [[AlbumMedia alloc] init];
                t_albumMedia.media_id = weakSelf.downloadStatus.media_id;
                t_albumMedia.name = weakSelf.album_xima.trackTitle;
                t_albumMedia.icon = weakSelf.album_xima.coverUrlSmall;
                t_albumMedia.url = weakSelf.album_xima.playUrl32;
                t_albumMedia.duration = @(weakSelf.album_xima.duration);
                
                childMoreView.albumMedia = t_albumMedia;
            
            }
            
            [childMoreView judgeCollection:[ShareValue sharedShareValue].mArr_collections];
            [vc.view addSubview:childMoreView];
            [childMoreView autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [childMoreView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            [childMoreView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
            [childMoreView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
            [childMoreView layoutIfNeeded];
            
            [childMoreView show];
            
        };
        
        self.block_more();
        
    }else{
    
        if (_block_down) {
            self.block_down(self);
        }
        
    }
    
    
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [audioController_cell stop];
    audioController_cell = nil;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
