//
//  ToyHomeVC.m
//  LittleMonkey
//
//  Created by huanglurong on 16/5/25.
//  Copyright © 2016年 NDHcat. All rights reserved.
//

#import "ToyHomeVC.h"
#import "ToySettingVC.h"

/************* 请求接口 *************/

#import "NDToyAPI.h"
#import "NDMediaAPI.h"
#import "NDAlbumAPI.h"

/************* 第三方 *************/

#import <RESideMenu/UIViewController+RESideMenu.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "PureLayout.h"
#import "LK_NSDictionary2Object.h"
#import "UIButton+Block.h"
#import "FXBlurView.h"

#import "ChildMusicVC.h"
#import "GroupChatDetailVC.h"
#import "WCGraintCircleLayer.h"

#import "NDAlarmAPI.h"
#import "TimerAddVCL.h"
#import "ChildAddToAlbumVC.h"

@interface ToyHomeVC ()

@property (weak, nonatomic) IBOutlet UILabel *lb_toyNickname;

@property (weak, nonatomic) IBOutlet UIButton *btn_after;
@property (weak, nonatomic) IBOutlet UIButton *btn_before;
@property (weak, nonatomic) IBOutlet UIButton *btn_play;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;
@property (weak, nonatomic) IBOutlet UILabel *lb_mediaName;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_bg;
@property (weak, nonatomic) IBOutlet FXBlurView *v_blur;

@property (weak, nonatomic) IBOutlet UIButton *btn_add;
@property (weak, nonatomic) IBOutlet UIButton *btn_musicBack;
@property (weak, nonatomic) IBOutlet UIButton *btn_alarm;
@property (weak, nonatomic) IBOutlet UIButton *btn_shengyin;



@property (strong, nonatomic) IBOutlet UIView *v_voice;
@property (weak, nonatomic) IBOutlet UISlider *voinceSlider;
@property (weak, nonatomic) IBOutlet UIView *v_cover;


@property (weak, nonatomic) IBOutlet UIView *v_music;

@property (weak, nonatomic) IBOutlet UIView *v_status;

@property (weak, nonatomic) IBOutlet UIButton *btn_light;
@property (weak, nonatomic) IBOutlet UIButton *btn_playToy;
@property (weak, nonatomic) IBOutlet UIButton *btn_talk;
@property (weak, nonatomic) IBOutlet UIButton *btn_story;
@property (weak, nonatomic) IBOutlet UIButton *btn_musicToy;

@property (weak, nonatomic) IBOutlet UIImageView *imgV_light;
@property (weak, nonatomic) IBOutlet UIImageView *imgV_playToy;
@property (weak, nonatomic) IBOutlet UIImageView *imgV_talk;
@property (weak, nonatomic) IBOutlet UIImageView *imgV_story;
@property (weak, nonatomic) IBOutlet UIImageView *imgV_musicToy;

@property (weak, nonatomic) IBOutlet UIImageView *imgV_onLine;


@property (weak, nonatomic) IBOutlet UILabel *lb_statusLink;
@property (weak, nonatomic) IBOutlet UILabel *lb_statusTip;


@property (weak, nonatomic) IBOutlet UILabel *lb_status;
@property (weak, nonatomic) IBOutlet UILabel *lb_electricity;

@property (weak, nonatomic) IBOutlet UIButton *btn_chat;
@property (weak, nonatomic) IBOutlet UIButton *btn_music;

@property (weak, nonatomic) IBOutlet UIView *v_unLink;
@property (weak, nonatomic) IBOutlet UIView *v_unlinkClock;

@property(strong,nonatomic) CABasicAnimation *rotationAnimation;




/********      玩具属性   **********/

@property (nonatomic,assign) ToyState toyState;    //玩具模式状态
@property (nonatomic,strong) ToyStatus *toyStatus; //玩具属性状态
@property (nonatomic,assign) PlayState playState; //播放音乐状态

@property (nonatomic,strong) AlbumInfo  *cur_albumInfo;     //当前播放专辑
@property (nonatomic,strong) AlbumMedia *cur_albumMedia;    //当前播放歌曲

@property (nonatomic,strong) GCDTimer *timer;               //定时器，用于更新电量情况

@property (nonatomic,assign) NSInteger voinceValue;


@end

@implementation ToyHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    
    [NotificationCenter addObserver:self selector:@selector(notifyToyModeChanged:) name:NOTIFICATION_REMOTE_DATAS object:nil];
    [NotificationCenter addObserver:self selector:@selector(electricityAction:) name:NOTIFICATION_REMOTE_ELECTRICITY object:nil];
    [NotificationCenter addObserver:self selector:@selector(notifyToyModeChanged:) name:NOTIFCATION_APPBECOME object:nil];
    
    [self initView];
    [self initData];
    
    [self queryToyVolumeWithKeys:@[DATA_KEY_VOLUME]];
    
    [ShareFun clearPlayData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([ShareValue sharedShareValue].toyDetail) {
        self.lb_toyNickname.text = [ShareValue sharedShareValue].toyDetail.nickname;
    }else{
        self.lb_toyNickname.text = NSLocalizedString(@"悟小空玩具", nil);
    }
    
}

#pragma mark - privateMethods

-(void)startAnimate{
    self.rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    self.rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    self.rotationAnimation.duration = 3.0;
    self.rotationAnimation.cumulative = YES;
    self.rotationAnimation.repeatCount = INT_MAX;
    self.rotationAnimation.removedOnCompletion = NO;
    [_imageV_icon.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
}

-(void)stopAnimate{
    [_imageV_icon.layer removeAllAnimations];
}

- (void)initView{

    if ([ShareValue sharedShareValue].toyDetail) {
        self.lb_toyNickname.text = [ShareValue sharedShareValue].toyDetail.nickname;
    }else{
        self.lb_toyNickname.text = NSLocalizedString(@"悟小空玩具", nil);
    }
    
    _imageV_icon.layer.borderWidth = 2.f;
    _imageV_icon.layer.borderColor =[RGB(230, 230, 230) CGColor];
    _imageV_icon.layer.masksToBounds = YES;
    _btn_play.layer.masksToBounds = YES;
    self.v_blur.blurRadius = 30.0;
    _imageV_bg.clipsToBounds = YES;
    NSArray *arr_view = [[NSArray alloc] initWithObjects:_btn_musicBack, _btn_add,_btn_alarm,_btn_shengyin, nil];
    [arr_view autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:20.0 insetSpacing:YES matchedSizes:YES];
    [self.view layoutIfNeeded];
    
    _voinceSlider.maximumValue = 100.0;
    _voinceSlider.minimumTrackTintColor = RGB(240, 83, 79);
    _voinceSlider.maximumTrackTintColor = RGB(230, 230, 230);
    [_voinceSlider setThumbImage:[UIImage imageNamed:@"icon_voince_adjust"] forState:UIControlStateNormal];
    [_voinceSlider setThumbImage:[UIImage imageNamed:@"icon_voince_adjust"] forState:UIControlStateHighlighted];
    [_voinceSlider addTarget:self action:@selector(voinceSliderValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    _v_voice.frame = CGRectMake(0, SCREEN_HEIGHT+_v_voice.frame.size.height, [UIScreen mainScreen].bounds.size.width, _v_voice.frame.size.height);
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:_v_voice];
    
//    WCGraintCircleLayer * sub1 = [[WCGraintCircleLayer alloc] initGraintCircleWithBounds:CGRectMake(0, 0, self.v_unlinkClock.frame.size.width, self.v_unlinkClock.frame.size.height) Position:CGPointMake(self.v_unlinkClock.frame.size.width/2, self.v_unlinkClock.frame.size.height/2) FromColor:RGB(227, 227, 227) ToColor:UIColorFromRGB(0xe4ae04) LineWidth:5.0];
//    [self.v_unlinkClock.layer addSublayer:sub1];
    
    
}

- (void)initData{
    
    self.toyState = ToyStateUnKnowState;
}

#pragma mark - set&&get
- (void)setPlayState:(PlayState)playState{
    
    _playState = playState;
    
    switch (_playState) {
        case PlayStateUnKnowState:{
            break;
        }
        case PlayStateStopState:{
            [_btn_play setImage:[UIImage imageNamed:@"btn_toyHome_parse"] forState:UIControlStateNormal];
            [_btn_play setImage:[UIImage imageNamed:@"btn_toyHome_parse"] forState:UIControlStateHighlighted];
            break;
        }
        case PlayStatePlayState:{
            [_btn_play setImage:[UIImage imageNamed:@"btn_toyHome_play"] forState:UIControlStateNormal];
            [_btn_play setImage:[UIImage imageNamed:@"btn_toyHome_play"] forState:UIControlStateHighlighted];
            
            
            break;
        }
        default:
            break;
    }
    
}

-(void)updataMusicPlayerBtn{
    
    if (!_toyStatus.mediaid || [_toyStatus.mediaid isEqual:@"0"] || ![_toyStatus.isonline isEqual:@"1"]) {
        
        _v_music.hidden = YES;
        _v_status.hidden = NO;
        
    }else{
    
        if ([self isPlayOneMedia]) {
            _v_music.hidden = NO;
            _v_status.hidden = YES;
        }
    
    }
}

- (void)setToyState:(ToyState)toyState{
    
    __weak typeof(self) weakSelf = self;
    
    _toyState = toyState;
    [ShareValue sharedShareValue].cur_toyState = toyState;
    switch (_toyState) {
            
        case ToyStateUnOnlineState:{
            
            _v_unLink.hidden = YES;
            //[self startAnimation];
            [self setModelOnLine:NO withStatus:0];
            
            _lb_status.text = @"未连接";
            
            self.lb_statusLink.text = @"正在搜索悟小空...";
            self.lb_statusTip.text = @"小提示: 小空是不是关机或者进入休眠状态了？";
            
            
            [ShareFun clearPlayData];
            
            if (self.timer) {
                
                [self.timer destroy];
                [self.timer dispatchRelease];
                
            }
        
            _timer = [[GCDTimer alloc] initInQueue:[GCDQueue globalQueue]];
            
            [_timer event:^{
                
                [weakSelf queryToyElectricity];
                
            } timeInterval:5 * 60 * NSEC_PER_SEC];
            
            [_timer start];
            
            self.playState  = PlayStateUnKnowState;
            
            break;
        }
        case ToyStateOnlineState:{
            
            _v_unLink.hidden = YES;
            
            [self setModelOnLine:YES withStatus:0];
            
            _lb_status.text = @"已连接";
            
            [ShareFun clearPlayData];
            
            if (self.timer) {
                [self.timer destroy];
                [self.timer dispatchRelease];
            }
            
            _timer = [[GCDTimer alloc] initInQueue:[GCDQueue globalQueue]];
            
            [_timer event:^{
                
                [weakSelf queryToyElectricity];
            
            } timeInterval:5 * 60 * NSEC_PER_SEC];
            
            [_timer start];
            
            break;
        }
        case ToyStateDormancyState:{
            
            _v_unLink.hidden = YES;
            //[self startAnimation];
            
            [self setModelOnLine:NO withStatus:0];
            
            self.lb_statusLink.text = @"正在搜索悟小空...";
            self.lb_statusTip.text = @"小提示: 小空是不是关机或者进入休眠状态了？";
            
            
            _lb_status.text = @"未连接";
          
            [ShareFun clearPlayData];
            
            if (self.timer) {
                [self.timer destroy];
                [self.timer dispatchRelease];
            }
            
            _timer = [[GCDTimer alloc] initInQueue:[GCDQueue globalQueue]];
            
            [_timer event:^{
                
                [weakSelf queryToyElectricity];

            } timeInterval:5 * 60 * NSEC_PER_SEC];
            
            [_timer start];
            
            
        
            self.playState  = PlayStateUnKnowState;
            
            break;
        }
            
        case ToyStatePartnerState:{
            
            _v_unLink.hidden = YES;
            
            [self setModelOnLine:YES withStatus:2];
            
            _lb_status.text = @"已连接";
            self.lb_statusLink.text = @"玩耍模式";
            self.lb_statusTip.text = @"轻拍顶部按钮可以收听天气 长按顶部按钮是变声功能,摇一摇，听搞怪声音";
            
            if ([self isPlayOneMedia]) {
                
                if(_toyStatus.status){
                    
                    if ([_toyStatus.status isEqualToString:@"1"]) {
                        
                        self.playState = PlayStatePlayState;
                       
                    }else{
                        
                        self.playState = PlayStateStopState;
                       
                    }
                    
                }
                
            }else{
                
                self.playState = PlayStateUnKnowState;
                
            }
            [self loadMusicDetail];
            
            break;
        }
            
            
        case ToyStateTalkState:{
            
            _v_unLink.hidden = YES;
            [self setModelOnLine:YES withStatus:3];
            
            _lb_status.text = @"已连接";
            self.lb_statusLink.text = @"语音对讲模式";
            self.lb_statusTip.text = @"轻拍顶部按钮收听最近一个音频，长按顶部按钮开始对讲功能放开后发送";
           
            if ([self isPlayOneMedia]) {
                
                if(_toyStatus.status){
                    
                    if ([_toyStatus.status isEqualToString:@"1"]) {
                        
                        self.playState = PlayStatePlayState;
                        
                    }else{
                        
                        self.playState = PlayStateStopState;
                        
                    }
                    
                }
                
            }else{
                
                self.playState = PlayStateUnKnowState;
                
            }
            
            [self loadMusicDetail];
            
            break;
        }
            
        case ToyStateMusicState:{
            
            _v_unLink.hidden = YES;
            [self setModelOnLine:YES withStatus:4];
            
            _lb_status.text = @"已连接";
            self.lb_statusLink.text = @"音乐模式";
            self.lb_statusTip.text = @"轻拍顶部按钮收听下一曲，长按顶部按钮切换专辑，摇一摇暂停，在摇一摇继续播放媒体";
    
            if(_toyStatus.status){
                
                if ([_toyStatus.status isEqualToString:@"1"]) {
                    
                    self.playState = PlayStatePlayState;
                     [self startAnimate];
                }else{
                    
                    self.playState = PlayStateStopState;
                     [self stopAnimate];
                }
                
            }
            
            [self loadMusicDetail];
            
            break;
        }
        case ToyStateStoryState:{
            
            _v_unLink.hidden = YES;
            
              [self setModelOnLine:YES withStatus:5];
            _lb_status.text = @"已连接";
            self.lb_statusLink.text = @"故事模式";
            self.lb_statusTip.text = @"轻拍顶部按钮收听下一曲，长按顶部按钮切换专辑，摇一摇暂停，在摇一摇继续播放媒体";
            
            if(_toyStatus.status){
                
                if ([_toyStatus.status isEqualToString:@"1"]) {
                    [self startAnimate];
                    self.playState = PlayStatePlayState;
                }else{
                    [self stopAnimate];
                    self.playState = PlayStateStopState;
                }
                
            }
            
            [self loadMusicDetail];
            
            break;
        }
        case ToyStateBianShenState:{
            
            _v_unLink.hidden = YES;
            //[self stopAnimation];
            [self setModelOnLine:YES withStatus:2];
            _lb_status.text = @"已连接";
            self.lb_statusLink.text = @"玩耍模式";
            self.lb_statusTip.text = @"轻拍顶部按钮可以收听天气 长按顶部按钮是变声功能,摇一摇，听搞怪声音";
        
            if ([self isPlayOneMedia]) {
                
                if(_toyStatus.status){
                    
                    if ([_toyStatus.status isEqualToString:@"1"]) {
                        
                        self.playState = PlayStatePlayState;
                    }else{
                        
                        self.playState = PlayStateStopState;
                    }
                    
                }
                
                [self loadMusicDetail];
                
            }else{
                
                self.playState = PlayStateUnKnowState;
                
            }
            
            break;
        }
        case ToyStateKitTalkState:{
            
            _v_unLink.hidden = YES;
            //[self stopAnimation];
            
            _lb_status.text = @"已连接";
            self.lb_statusLink.text = @"私聊模式";
            self.lb_statusTip.text = @"悟小空正处于私聊模式，让您的宝贝和其他小伙伴愉快的聊天吧";
            
            if ([self isPlayOneMedia]) {
                
                if(_toyStatus.status){
                    
                    if ([_toyStatus.status isEqualToString:@"1"]) {
                        
                        self.playState = PlayStatePlayState;
                        
                    }else{
                        
                        self.playState = PlayStateStopState;
                        
                    }
                    
                }
                
                [self loadMusicDetail];
                
            }else{
                
                self.playState = PlayStateUnKnowState;
                
            }
            
            break;
        }
        case ToyStateUnKnowState:{
            
            _v_unLink.hidden = YES;
            //[self startAnimation];
            
            [self setModelOnLine:NO withStatus:0];
            
            if ([ShareValue sharedShareValue].toyDetail) {
                
                [self queryToyDataWithKeys:@[DATA_KEY_MODECHANGE]];
                
                _lb_status.text = @"未连接";
                self.lb_statusLink.text = @"正在搜索悟小空...";
                self.lb_statusTip.text = @"小提示: 小空是不是关机或者进入休眠状态了？";
            
            }
            
            break;
        }
            
        case ToyStateNightLightState:{
            
            _v_unLink.hidden = YES;
            
            [self setModelOnLine:YES withStatus:1];
            
            _lb_status.text = @"已连接";
            self.lb_statusLink.text = @"夜灯模式";
            self.lb_statusTip.text = @"轻拍顶部按钮可开关灯，长按顶部按钮变换灯的颜色";
            
            if ([self isPlayOneMedia]) {
                
                if(_toyStatus.status){
                    
                    if ([_toyStatus.status isEqualToString:@"1"]) {
                        
                        self.playState = PlayStatePlayState;
                        
                    }else{
                        
                        self.playState = PlayStateStopState;
                        
                    }
                    
                }
                
            }else{
                
                self.playState = PlayStateUnKnowState;
                
            }
            [self loadMusicDetail];
            
            
        
        }
            break;
        default:
            break;
    }
    [self updataMusicPlayerBtn];
    
}


- (void)setModelOnLine:(BOOL)onLine withStatus:(NSInteger)tag{

    _imgV_light.hidden = YES;
    _imgV_playToy.hidden = YES;
    _imgV_talk.hidden = YES;
    _imgV_musicToy.hidden = YES;
    _imgV_story.hidden = YES;
    
    if (onLine) {
        
        [_imgV_onLine setImage:[UIImage imageNamed:@"okface"]];
     
        switch (tag) {
            case 1:
                _imgV_light.hidden = NO;
                [self startAnimation:_imgV_light];
                
                break;
            case 2:
                _imgV_playToy.hidden = NO;
                [self startAnimation:_imgV_playToy];
                
                break;
            case 3:
                _imgV_talk.hidden = NO;
                [self startAnimation:_imgV_talk];
                
                break;
            case 4:
                _imgV_musicToy.hidden = NO;
                [self startAnimation:_imgV_musicToy];
                
                break;
            case 5:
                _imgV_story.hidden = NO;
                [self startAnimation:_imgV_story];
                
                break;
                
            default:
                break;
        }
        
        
    }else {
        
        [_imgV_onLine setImage:[UIImage imageNamed:@"noface"]];
    
    
    }
    
}


#pragma mark - function

/************** 查询玩具音量 ***************/

- (void)queryToyVolumeWithKeys:(NSArray *)keys{
    
    __weak typeof(self) weakSelf = self;
    
    NDToyDataKeyValueParams *params = [[NDToyDataKeyValueParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.keys = keys;
    
    [NDToyAPI toyDataKeyValueParams:params completionBlockWithSuccess:^(ToyStatus *data) {
        
        if(data.volume.intValue >=0 && data.volume.intValue <= 100){
            
            weakSelf.voinceValue = data.volume.intValue;
            weakSelf.voinceSlider.value = weakSelf.voinceValue;
            
        }
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }];
}

/*********** 查询玩具模式 ************/

- (void)queryToyDataWithKeys:(NSArray *)keys{
    
    __weak typeof(self) weakSelf = self;
    
    NDToyDataKeyValueParams *params = [[NDToyDataKeyValueParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.keys = keys;
    
    ShowHUD *hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {} inView:self.view];
    
    [NDToyAPI toyDataKeyValueParams:params completionBlockWithSuccess:^(ToyStatus *data) {
        [hud hide];
        weakSelf.toyStatus.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
        weakSelf.toyStatus = data;
        
        if ([weakSelf.toyStatus.isonline intValue] == 0) {
            
            self.toyState = ToyStateUnOnlineState;
            
        }else if ([weakSelf.toyStatus.isonline intValue] == 1){
            
            self.toyState = ToyStateOnlineState;
            
            [weakSelf toyStatusAnalyseWithData:weakSelf.toyStatus];
            
        }else if ([weakSelf.toyStatus.isonline intValue] == 2){
            
            self.toyState = ToyStateDormancyState;
            
        }
        [weakSelf updataMusicPlayerBtn];
        
    } Fail:^(int code, NSString *failDescript) {
        
        [hud hide];
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
    }];
}

/************** 模式切换处理 ****************/

- (void)toyStatusAnalyseWithData:(ToyStatus *)data{
    
    if(data){
        
        switch (data.mode.intValue) {
            case 0:
                
                /********** 对讲模式 ***********/
                
                self.toyState = ToyStateTalkState;
                break;
                
            case 1:
                self.toyState = ToyStateMusicState;
                break;
            case 2:
                
                /********** 音频模式 ***********/
                
                self.toyState = ToyStateStoryState;
                break;
            case 3:
                
                /********** 音频模式 ***********/
                
                self.toyState = ToyStatePartnerState;
                break;
            case 9:
                
                /********** 小伙伴模式 ***********/
                
                self.toyState = ToyStatePartnerState;
                break;
            case 7:
                
                /********** 变声模式 ***********/
                
                self.toyState = ToyStateBianShenState;
                break;
            case 6:
                
                /********** 密语模式 ***********/
                
                self.toyState = ToyStateKitTalkState;
                break;
            case 10:
                /********** 夜灯模式 ***********/
                
                self.toyState = ToyStateNightLightState;
                break;
            default:
                break;
        }
        
    }
    [self setToyState:self.toyState];
    
}

/************** 请求玩具电量 ****************/

- (void)queryToyElectricity{
    
    __weak typeof(self) weakSelf = self;
    
    NDToyElectricityParams *params = [[NDToyElectricityParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    [NDToyAPI toyElectricityWithParams:params completionBlockWithSuccess:^(NDToyElectricityResult *data) {
        
        if (weakSelf.toyStatus) {
            
            [weakSelf handleElectrictityState:data.electricity];
            
        }
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }];
    
}

/************** 请求当前播放媒体信息 ****************/

- (void)loadMusicDetail{
    
    __weak typeof(self) weakSelf = self;
    //[weakSelf stopAnimation];
    if ([self isPlayOneMedia]) {
        
        
        _btn_play.hidden = YES;
        _btn_after.hidden = YES;
        _btn_before.hidden = YES;
        
        [[GCDQueue globalQueue] execute:^{
            [weakSelf queryMediaInfoWithMediaId:[NSNumber numberWithLongLong:[_toyStatus.mediaid longLongValue]]];
        }];
        [weakSelf startAnimate];
        
    }else{
        
        _btn_play.hidden = NO;
        _btn_after.hidden = NO;
        _btn_before.hidden = NO;
        
        if ([_toyStatus.status isEqual:@"0"]) {
            
            [self setPlayState:PlayStatePlayState];
            
        }else{
            
            [self setPlayState:PlayStateStopState];
        }
        [[GCDQueue globalQueue] execute:^{
            
            [weakSelf queryAlbumInfoWithAlbumId:[NSNumber numberWithLongLong:[_toyStatus.albumid longLongValue]]];
            
        }];

    
        [[GCDQueue globalQueue] execute:^{
            [weakSelf queryMediaInfoWithMediaId:[NSNumber numberWithLongLong:[_toyStatus.mediaid longLongValue]]];
        }];
        
    }
    
}


- (void)queryChangeModel:(NSInteger)model{

    NDToyChangeModeParams *params = [[NDToyChangeModeParams alloc]init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.mode = @(model);
    [NDToyAPI toyChangeModeWithParams:params completionBlockWithSuccess:^(NDToyChangeModeResult *result) {
        
        [ShowHUD showSuccess:NSLocalizedString(@"ChangeSuccessful", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }];
    


}


/************* 查询专辑详情 *************/

- (void)queryAlbumInfoWithAlbumId:(NSNumber *)album_id{
    if (album_id.intValue == 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    NDAlbumInfoByIdParams *params = [[NDAlbumInfoByIdParams alloc] init];
    params.album_id = album_id;
    
    [NDAlbumAPI albumInfoByIdWithParams:params completionBlockWithSuccess:^(AlbumInfo *data) {
        
        weakSelf.cur_albumInfo = data;
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
    }];
}

/************* 查询媒体详情 *************/

- (void)queryMediaInfoWithMediaId:(NSNumber *)media_id{
    
    if (media_id.intValue == 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    NDMediaQueryByIdParams *params = [[NDMediaQueryByIdParams alloc] init];
    params.media_id = media_id;
    
    [NDMediaAPI mediaQueryByIdWithParams:params completionBlockWithSuccess:^(AlbumMedia *data) {
        weakSelf.cur_albumMedia = data;
        
        weakSelf.lb_mediaName.text = weakSelf.cur_albumMedia.name;
        if (data.icon) {
            [weakSelf.imageV_bg sd_setImageWithURL:[NSURL URLWithString:data.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
            [weakSelf.imageV_icon sd_setImageWithURL:[NSURL URLWithString:data.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        }else{
            [weakSelf.imageV_bg sd_setImageWithURL:[NSURL URLWithString:weakSelf.cur_albumInfo.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
            [weakSelf.imageV_icon sd_setImageWithURL:[NSURL URLWithString:weakSelf.cur_albumInfo.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        }
    
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
    }];
}

/************* 播放或暂停功能函数 *************/

- (void)changedToyPlayWithOffset:(NSNumber *)offset{
    
    __weak typeof(self) weakSelf = self;
    
    NDToyControlPlayParams *params = [[NDToyControlPlayParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.offset = offset;
    
    PlayState t_playState = _playState;
    
    [NDToyAPI toyControlPlayWithParams:params completionBlockWithSuccess:^{
        
        
        if ([offset isEqualToNumber:@0]) {
            
            if (t_playState == PlayStatePlayState) {
                
                weakSelf.playState = PlayStateStopState;
                [ShareValue sharedShareValue].cur_statues = @"0";
                
                [ShowHUD showSuccess:NSLocalizedString(@"播放成功", nil) configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:self.view];
                
                
            }else if (t_playState == PlayStateStopState){
                
                weakSelf.playState = PlayStatePlayState;
                [ShareValue sharedShareValue].cur_statues = @"1";
                
                [ShowHUD showSuccess:NSLocalizedString(@"暂停成功", nil) configParameter:^(ShowHUD *config) {
                } duration:1.5f inView:self.view];
                
            }

            
        }else{
            
            [ShowHUD showSuccess:NSLocalizedString(@"切换成功", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:ApplicationDelegate.window];
            
        }
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
    }];
}


/************* 判断点播模式 *************/

- (BOOL)isPlayOneMedia{
    
    return _toyStatus.albumid && _toyStatus.mediaid&&[_toyStatus.albumid isEqualToString:@"0"] && ![_toyStatus.mediaid isEqualToString:@"0"];
    
}

/************* 修改玩具音量 *************/

- (void)changeToyVolume:(NSInteger)value{
    
    NDToyChangeSettingParams *params = [[NDToyChangeSettingParams alloc] init];
    params.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
    params.key = Def_ToySetKey_Volume;
    params.value = [NSString stringWithFormat:@"%d",(int)value];
    
    [NDToyAPI toyChangeSettinWithParams:params completionBlockWithSuccess:^{
        
        [ShowHUD showSuccess:NSLocalizedString(@"设置成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
    }];
    
}
/************* 调节音量消失的动画 *************/

- (void)updateNickNameViewHiddenAnimateIfNeed
{
    __weak ToyHomeVC *weakSelf = self;
    //vNickName消失
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.v_cover.hidden = YES;
        CGRect frame = weakSelf.v_voice.frame;
        frame.origin.y = SCREEN_HEIGHT+frame.size.height;
        weakSelf.v_voice.frame = frame;
    }];
    
}

- (void)startAnimation:(UIImageView *)imageView
{
    //    [_img_music.layer removeAllAnimations];
    [self stopAnimation:imageView];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    //执行时间
    animation.duration = 2;
    //执行次数
    animation.repeatCount = INT_MAX;
    animation.removedOnCompletion = NO;
    [imageView.layer addAnimation:animation forKey:@"animation"];
}

-(void)stopAnimation:(UIImageView *)imageView{
    
    [imageView.layer removeAllAnimations];
}


#pragma mark - ButtonAction

/************** 玩具设置 ****************/

- (IBAction)handleToySetAction:(id)sender {

    ToySettingVC *t_vc = [[ToySettingVC alloc] init];
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

/************** 玩具列表 ****************/

- (IBAction)handleToyListAction:(id)sender {
    
    [self presentLeftMenuViewController:nil];
    
}


/************** 玩具音乐 ****************/

- (IBAction)handleToyMusicAction:(id)sender {
    
//    ChildMusicVC *vc = [[ChildMusicVC alloc]init];
//    vc.canBack = YES;
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//    [self.navigationController presentViewController:nav animated:YES completion:^{
//        
//    }];
    
    ChildMusicVC *vc = [[ChildMusicVC alloc]init];
    vc.canBack = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

/************** 玩具聊天 ****************/

- (IBAction)handleToyChatAction:(id)sender {
    
    GroupChatDetailVC *groupChatDetailVC = [[GroupChatDetailVC alloc]init];
    groupChatDetailVC.groupDetail = [ShareValue sharedShareValue].groupDetail;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:groupChatDetailVC];
    [ApplicationDelegate.tabBarController presentViewController:nav animated:YES completion:^{
        
    }];
    
}

/************** 玩具播放或者暂停 ****************/

- (IBAction)handleToyPlayAction:(id)sender {
    
    if (self.playState == PlayStatePlayState) {
        [self changedToyPlayWithOffset:@0];
    }else{
        [self changedToyPlayWithOffset:@0];
    }
    
    
}

/************** 玩具下一首 ****************/

- (IBAction)handleToyAfterAction:(id)sender {
    
    [self changedToyPlayWithOffset:@1];
    
}

/************** 玩具上一首 ****************/

- (IBAction)handleToyBeforeAction:(id)sender {
    
    [self changedToyPlayWithOffset:@(-1)];
    
}

/************** 玩具添加到 ****************/

- (IBAction)handleToyAddAction:(id)sender {
    
    ChildAddToAlbumVC *t_vc = [[ChildAddToAlbumVC alloc] init];
    t_vc.albumMedia = self.cur_albumMedia;
    
    UINavigationController *toyGuideNav = [[UINavigationController alloc]initWithRootViewController:t_vc];
    
    [ApplicationDelegate.tabBarController presentViewController:toyGuideNav animated:YES completion:^{
        
    }];
    
}

/************** 玩具喜欢 ****************/

- (IBAction)handleToyLikeAction:(id)sender {
    
   
    
}

/************** 玩具闹铃 ****************/

- (IBAction)handleToyAlarmAction:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    
    NDAlarmAddEventParams *params = [[NDAlarmAddEventParams alloc] init];
    params.url = self.cur_albumMedia.url;
    params.desc = self.cur_albumMedia.name;
    [NDAlarmAPI alarmAddEventWithParams:params completionBlockWithSuccess:^(NSDictionary *data){
        
        NSNumber *event_id = [data objectForKey:@"event_id"];
        
        TimerAddVCL *vcl = [[TimerAddVCL alloc]init];
        vcl.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
        Alarm *t_alarm =  [[Alarm alloc] init];
        t_alarm.toy_id = [ShareValue sharedShareValue].toyDetail.toy_id;
        t_alarm.tag = @"";
        t_alarm.enable = @1;
        t_alarm.event = event_id;
        t_alarm.event_name = weakSelf.cur_albumMedia.name;
        
        vcl.alarm = t_alarm;
        
        UINavigationController *toyGuideNav = [[UINavigationController alloc]initWithRootViewController:vcl];
        [ApplicationDelegate.tabBarController presentViewController:toyGuideNav animated:YES completion:^{
            
        }];
        
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:@"添加失败" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
    }];
    
}

/************** 玩具音量大小 ****************/

- (IBAction)handleToyShengyinAction:(id)sender {
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^() {
                         CGRect frame = _v_voice.frame;
                         frame.origin.y = SCREEN_HEIGHT - _v_voice.frame.size.height;
                         _v_voice.frame = frame;
                         [UIView animateWithDuration:0.2 animations:^{
                             _v_cover.hidden = NO;
                         } completion:^(BOOL finished) {
                         }];
                         
                     } completion:^(BOOL finished) {
                     }];
    
}

/************** 调节玩具音量大小 ****************/

- (void)voinceSliderValueChanged:(id)sender{
    
    UISlider *slider = (UISlider *)sender;
    _voinceValue = (NSInteger)slider.value;
    NSLog(@"%f",slider.value);
    [self changeToyVolume:_voinceValue];
    
}

/************** 点击蒙层 ****************/

- (IBAction)handleCoverClick:(id)sender {
    [self updateNickNameViewHiddenAnimateIfNeed];
}


/************** 点击音乐返回 ****************/

- (IBAction)handleMusicBackClick:(id)sender {
    
    _v_music.hidden = YES;
    _v_status.hidden = NO;
    
}

/************** 点击各个模式切换按钮 ****************/

- (IBAction)btnModelChangeClick:(id)sender {
    
    
    UIButton * btn = sender;
    NSInteger tag = btn.tag;
    
    switch (tag) {
        case 71:
            
            [self queryChangeModel:TOYMODE_NightLight];
            
            break;
        case 72:
            
            [self queryChangeModel:TOYMODE_JOY];
            break;
        case 73:
            
            [self queryChangeModel:TOYMODE_TALK];
            break;
        case 74:
            
            if (self.toyState == ToyStateMusicState) {
                
                _v_music.hidden = NO;
                _v_status.hidden = YES;
                
            }else{
                [self queryChangeModel:TOYMODE_MUSIC];
            }
            
            break;
        case 75:
            
            if (self.toyState == ToyStateStoryState) {
                
                _v_music.hidden = NO;
                _v_status.hidden = YES;
                
            }else{
                [self queryChangeModel:TOYMODE_STORY];
            }
            break;
            
        default:
            break;
    }
    
}




#pragma mark - NOTIFICATION

- (void)notifyToyModeChanged:(NSNotification *)note{
    
    NSDictionary *dict = note.userInfo;
    if(dict){
        
        if ([ShareValue sharedShareValue].toyDetail) {
            if (![[dict objectForKey:@"toy_id"] isEqualToNumber:[ShareValue sharedShareValue].toyDetail.toy_id]) {

                return;
            }
        }
       
        
        NSString *key = dict[@"key"];
        NSDictionary *value = dict[@"value"];
        _cur_albumInfo = nil;
        if([key isEqualToString:DATA_KEY_MODECHANGE]){
            
            if(value.count > 0){
                __weak typeof(self) weakself = self;
                [[GCDQueue mainQueue] execute:^{
                    ToyStatus *toyStatus = [value objectByClass:[ToyStatus class]];
                    _toyStatus.mode =toyStatus.mode;
                    _toyStatus.mediaid = toyStatus.mediaid;
                    _toyStatus.albumid = toyStatus.albumid;
                    _toyStatus.status = toyStatus.status;
                    
                    [ShareValue sharedShareValue].cur_ablumId = _toyStatus.albumid;
                    [ShareValue sharedShareValue].cur_mediaId = _toyStatus.mediaid;
                    [ShareValue sharedShareValue].cur_statues = _toyStatus.status;//暂停状态
                    [weakself updataMusicPlayerBtn];
                
                    [weakself toyStatusAnalyseWithData:toyStatus];
                }];
                
            }
            
        }else if ([key isEqualToString:DATA_KEY_ALIVE]){
            
            if(value.count > 0){
                
                NSNumber *alive = value[DATA_KEY_ALIVE];
                
                /************** 0-关机 1-开机 2休眠 ****************/
                __weak typeof(self) weakself = self;
                if ([alive intValue] == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakself.toyState = ToyStateUnOnlineState;
                        weakself.toyStatus.isonline = @"0";
                        [weakself updataMusicPlayerBtn];
                    });
                    
                }else if ([alive intValue] == 1){
                    [self queryToyDataWithKeys:@[DATA_KEY_MODE]];
                }else if ([alive intValue] == 2){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakself.toyState = ToyStateDormancyState;
                        weakself.toyStatus.isonline = @"2";
                        [weakself updataMusicPlayerBtn];
                    });
                }
                
            }
            
        }else if ([key isEqualToString:DATA_KEY_WAKEUP]){
           
            if(value.count > 0){
                
                if (self.toyState == ToyStateUnOnlineState || self.toyState == ToyStateDormancyState) {
                    [self queryToyDataWithKeys:@[DATA_KEY_MODE]];
                }
                
            }
            
        }
        
    }
    
}



/**************** 电量通知 *****************/

- (void)electricityAction:(NSNotification *)note{
    
    NSDictionary *t_dic = [note userInfo];
    
    if (t_dic) {
        
        NSNumber *electricity = [t_dic objectForKey:@"electricity"];
        NSNumber *toy_id      = [t_dic objectForKey:@"toy_id"];
        
        if ([ShareValue sharedShareValue].toyDetail) {
            if ([toy_id isEqualToNumber:[ShareValue sharedShareValue].toyDetail.toy_id]) {
                [self handleElectrictityState:electricity];
            }
        }
    
    }
    
}

- (void)handleElectrictityState:(NSNumber *)electricity{
    
    self.toyStatus.electricity = [electricity stringValue];

    if ([self.toyStatus.electricity isEqualToString:@"-1"]) {
        
        _lb_electricity.text = NSLocalizedString(@"充电中", nil);
    
    }else{
        
        _lb_electricity.text = [NSString stringWithFormat:@"%@%%",self.toyStatus.electricity];
        
    }
    
}



#pragma mark - AKTabBar Method

// 常态图片名称
- (NSString *)tabImageName{
   
    return @"icon_tab_toyHome";
}

// 点击态图片名称
- (NSString *)tabSelectedImageName{
    
    return @"icon_tab_toyHome_selected";
}

// 标题
- (NSString *)tabTitle{
    return NSLocalizedString(@"悟小空", nil);
}


#pragma mark -dealloc

- (void)dealloc{
    [_v_voice removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"ToyHomeVC Dealloc");
    
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
