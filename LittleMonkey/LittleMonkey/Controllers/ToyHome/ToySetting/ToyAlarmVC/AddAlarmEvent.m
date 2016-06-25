//
//  AddAlarmEvent.m
//  HelloToy
//
//  Created by nd on 15/10/16.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "AddAlarmEvent.h"
#import "VoiceProcess.h"
#import "NDAlarmAPI.h"

#define KSpeakTimeUp 40.f

@interface AddAlarmEvent ()<VoiceDelegate,AVAudioPlayerDelegate>{

    MBProgressHUD *_hud;
    
}

@property (nonatomic,assign) NSTimeInterval touchTime;  //判断点击时间
@property (nonatomic,strong) NSTimer *speakTime;        //录音倒计时
@property (nonatomic,assign) BOOL isSpeakTimeUp;        //判断录音倒计时是否到达
@property (nonatomic,assign) BOOL isSpeaking;           //判断是否在录音
@property (nonatomic,assign) BOOL isListen;             //判断是否在试听
@property (nonatomic,strong) NSString *alarm_url;       //闹铃url
@property (nonatomic,strong) GCDTimer *progress_timer;

@property (nonatomic,assign) BOOL isEditor;

@end

@implementation AddAlarmEvent

#pragma mark - viewLife

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"自定义闹铃", nil);
    
    self.isEditor = NO;
    self.isListen = NO;
    
    
    
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [VoiceProcess shareInstance].delegate = self;
    
}

#pragma mark -
#pragma mark set&&get

- (void)setIsEditor:(BOOL)isEditor{

    if (isEditor == _isEditor) {
        return;
    }
    
    _isEditor = isEditor;
    
    __weak typeof(self) weakSelf = self;
    
    if (_isEditor == NO) {
    
        [_tf_edit resignFirstResponder];
        weakSelf.v_edit.hidden = YES;
        
         [self showLeftBarButtonItemWithImage:@"icon_back" target:self action:@selector(handleBtnBackClicked)];
        self.navigationItem.rightBarButtonItem = nil;
    
    }else{
    
        [_tf_edit becomeFirstResponder];
         weakSelf.v_edit.hidden = NO;
        
        [self showLeftBarButtonItemWithTitle:NSLocalizedString(@"取消", nil) target:self action:@selector(handleBtnCannelClicked)];
        [self showRightBarButtonItemWithTitle:NSLocalizedString(@"保存", nil) target:self action:@selector(handleSaveClicked)];
    
    }

}

#pragma mark -
#pragma mark init

- (void)initUI{
    
    self.v_edit.hidden = YES;
    
    [_btn_play setEnabled:NO];
    [_btn_editor setEnabled:NO];
    
    _lb_state.text = NSLocalizedString(@"按住录音", nil);
    _progressView.transform = CGAffineTransformMakeScale(1.0f,3.0f);
    _progressView.layer.cornerRadius = _progressView.frame.size.height/2;
    _progressView.layer.masksToBounds = YES;
    [_tf_edit addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}


#pragma mark -
#pragma mark Private


-(void)progressForSpeaking{
    
    __block  float statusType = 0;
    __weak AddAlarmEvent *weakSelf = self;
    _progress_timer = [[GCDTimer alloc] initInQueue:[GCDQueue mainQueue]];
    [_progress_timer event:^{
        [weakSelf.progressView setProgress:statusType/KSpeakTimeUp animated:YES];
        
        statusType++;
        
        if (statusType == KSpeakTimeUp) {
            statusType = KSpeakTimeUp;
        }
        
    } timeInterval:1.f * NSEC_PER_SEC];
    
    [_progress_timer start];
}

-(void)progressForSpeaked{
    
    if (_progress_timer) {
        [_progress_timer destroy];
        [_progress_timer dispatchRelease];
        _progress_timer = nil;
    }
    
}


- (BOOL) uploadVoiceWith:(NSNumber *)duration {
    
    __weak typeof(self) weakSelf = self;
    
    NSString* path = [VoiceProcess shareInstance].filePath;
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (nil == data || data.length < 512) {
        return NO;
    }
    
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    _hud.progress = 0.0;
    [_hud setMode:MBProgressHUDModeAnnularDeterminate];
    _hud.labelText = NSLocalizedString(@"上传中...", nil);
    [self.view addSubview:_hud];
    [_hud show:YES];
    
    [NDBaseAPI uploadImageFile:data name:@"file" fileName:[NSString stringWithFormat:@"%f.mp3",[[NSDate date]timeIntervalSinceNow]] mimeType:@"audio/mpeg" ProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten,long long totalBytesExpectedToWrite) {
        
        [[GCDQueue mainQueue] execute:^{
            
            _hud.progress = (float)totalBytesExpectedToWrite/totalBytesWritten;
        }];
        
    } successBlock:^(NSString *filepath) {
        
        [_hud removeFromSuperview];
        _hud = nil;
        
        [weakSelf.btn_play setEnabled:YES];
        [weakSelf.btn_editor setEnabled:YES];
        
        weakSelf.alarm_url = filepath;
        
    } errorBlock:^(BOOL NotReachable) {
        
        [_hud removeFromSuperview];
        _hud = nil;
        
        [ShowHUD showError:NSLocalizedString(@"上传失败", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
    }];
    
    return YES;
}




#pragma mark -
#pragma mark buttonAction

//==================== 返回 =====================//

- (void)handleBtnBackClicked{

    [super handleBtnBackClicked];

}

//==================== 取消 =====================//

- (void)handleBtnCannelClicked{

    if (_isEditor) {
        self.isEditor = NO;
    }
    
}

//==================== 保存 =====================//

- (void)handleSaveClicked{

    __weak typeof(self) weakSelf = self;
    
    if ([_tf_edit.text isEqualToString:@""]) {
        
        [ShowHUD showWarning:NSLocalizedString(@"请输入闹铃名称", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return ;
    }
    
    NDAlarmAddEventParams *params = [[NDAlarmAddEventParams alloc] init];
    params.url = _alarm_url;
    params.desc = _tf_edit.text;
    [NDAlarmAPI alarmAddEventWithParams:params completionBlockWithSuccess:^(NSDictionary *data){
        
        [ShowHUD showSuccess:NSLocalizedString(@"添加成功", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
        weakSelf.isEditor = NO;
        [weakSelf handleBtnBackClicked];
        
    } Fail:^(int code, NSString *failDescript) {
        
        [ShowHUD showError:NSLocalizedString(@"添加失败", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
    }];
    
}

//==================== 编辑 =====================//

- (IBAction)handleBtnEditorClicked:(id)sender {
    
    if (_isListen == YES) {
        
        [[VoiceProcess shareInstance] stopPlay];
        _isListen = NO;
        
    }
    
    self.isEditor = YES;

}

//==================== 试听 =====================//

- (IBAction)handleBtnPlayClicked:(id)sender {
    
    if (_isListen == NO) {
        
        [[VoiceProcess shareInstance] playUrl:[NSURL fileURLWithPath:[VoiceProcess shareInstance].filePath]];
        _isListen = YES;
        
    }else{
        
        [[VoiceProcess shareInstance] stopPlay];
        _isListen = NO;
    }
    
    
}


#pragma mark -


- (IBAction)onRecordDown:(id)sender {
    
    NSLog(@"onRecordDown");
    
    if (_isListen == YES) {
        
        [[VoiceProcess shareInstance] stopPlay];
        _isListen = NO;
        
    }
    
    
    __weak typeof(self) weakSelf = self;
    
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (!granted) {
                
                UIAlertView *t_alerView = [[UIAlertView alloc] initWithTitle:@"无法录音" message:@"请在iPhone的“设置-隐私-麦克风”选项中,允许哈喽访问你的手机麦克风" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                [t_alerView show];

                return ;
            }else{
                
                weakSelf.isSpeaking = YES;
                
                weakSelf.touchTime = (double)[[NSDate date]timeIntervalSince1970];
                
                [self changeShowInside:nil];
                [self progressForSpeaking];
                
                if ( !weakSelf.speakTime && weakSelf.speakTime.isValid == NO ) {
                    
                    weakSelf.isSpeakTimeUp = NO;
                    
                    weakSelf.speakTime = [NSTimer scheduledTimerWithTimeInterval:KSpeakTimeUp target:self selector:@selector(speakTimeUp) userInfo:nil repeats:NO];
                }
                
                [[VoiceProcess shareInstance] performSelector:@selector(startRecord) withObject:nil afterDelay:0.3];
                
            }
        }];
    }
    
}

-(void)speakTimeUp{
    
    [self onRecordUp:nil];
    _isSpeakTimeUp = YES;
    
}

- (IBAction)changeShowInside:(id)sender {
    
    _lb_state.text = NSLocalizedString(@"手指离开按钮，取消录音", nil);
    
    _btn_record.highlighted = YES;
    
}

- (IBAction)changeShowOutside:(id)sender {
    
    _lb_state.text = NSLocalizedString(@"松开手指，取消录音", nil);
    
    _btn_record.highlighted = NO;
}


- (IBAction)onRecordUp:(id)sender {
    
    NSLog(@"onRecordUp");

    if (_speakTime.isValid == YES) {
        [_speakTime invalidate];
        _speakTime = nil;
    }
    
    if (_isSpeakTimeUp == YES) {
        
        return;
        
    }
    
    [self progressForSpeaked];
    

    NSTimeInterval curTime = (double)[[NSDate date]timeIntervalSince1970];
    NSTimeInterval sub = curTime - _touchTime;

    [[VoiceProcess shareInstance] performSelector:@selector(stopRecord) withObject:nil afterDelay:0.3];
    
    if (sub < 1.0) {
        
        [ShowHUD showWarning:NSLocalizedString(@"录音时间太短了", nil) configParameter:^(ShowHUD *config) {
        } duration:1.f inView:self.view];
        
    }else{
        
        [self performSelector:@selector(uploadVoiceWith:) withObject:[NSNumber numberWithInt:sub] afterDelay:0.6];
        
    }
    
    
    
}

- (IBAction)onRecordOutSide:(id)sender {
    
    if (_speakTime.isValid == YES) {
        [_speakTime invalidate];
        _speakTime = nil;
    }
    
    _btn_record.highlighted = NO;
    
    [self progressForSpeaked];
    [_progressView setProgress:0 animated:YES];
    
    [[VoiceProcess shareInstance] stopRecord];
    
}

#pragma mark - voiceProcessDelegate

-(void) onstopRecord{
    
    NSLog(@"onstopRecord");
    _lb_state.text = NSLocalizedString(@"按住录音", nil);
    _isSpeaking = NO;
   
}

-(void) onPlayFinish{
    
    _isListen = NO;
    
    
}


#pragma mark - UITextViewDelegate



- (void)textFieldDidChange:(UITextField *)textField
{
    
    /* ============ 限制输入长度 ============ */
    if (textField == _tf_edit) {
        
        if (textField.text.length > 10) {
            
            textField.text = [textField.text substringToIndex:10];
            
        }
        
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    /* ============ 限制输入长度 ============ */
    
    if (textField == _tf_edit ) {
        
        if (string.length == 0){
            
            return YES;
            
        }
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        if (existedLength - selectedLength + replaceLength > 10) {
            
            return NO;
            
        }
        
    }
    
    return YES;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - dealloc

- (void)dealloc{
    
    [_tf_edit removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [VoiceProcess shareInstance].delegate = nil;
    
    NSLog(@"AddAlarmEvent dealloc");
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
