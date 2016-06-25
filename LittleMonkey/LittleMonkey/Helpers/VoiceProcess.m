
//
//  VoiceProcess.m
//  HelloToy
//
//  Created by nd on 15/5/14.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "VoiceProcess.h"
#import "NDBaseAPI.h"


@interface VoiceProcess () {
    BOOL _hasRecord;
    AVAudioPlayer *_player;
}

@end


static VoiceProcess* _instance;

@implementation VoiceProcess

#pragma mark - init

+(VoiceProcess*) shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[VoiceProcess alloc] init];
    });
    return _instance;
}


-(id)init {
    if (self = [super init]) {
        [self initRecorderAndPlayer];
    }
    return self;
}


-(void) initRecorderAndPlayer {
    
    // record file store path
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    Mp3RecordWriter *mp3Writer = [[Mp3RecordWriter alloc]init];
    mp3Writer.filePath = [path stringByAppendingPathComponent:@"record.mp3"];
    mp3Writer.maxSecondCount = 60;
    mp3Writer.maxFileSize = 1024*256;
    self.mp3Writer = mp3Writer;
    
    // record volume observer
    MLAudioMeterObserver *meterObserver = [[MLAudioMeterObserver alloc]init];
    meterObserver.actionBlock = ^(NSArray *levelMeterStates,MLAudioMeterObserver *meterObserver){
        float volume = [MLAudioMeterObserver volumeForLevelMeterStates:levelMeterStates];
        NSLog(@"volume:%f",volume);
    };
    meterObserver.errorBlock = ^(NSError *error,MLAudioMeterObserver *meterObserver){
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"错误", nil) message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show];
    };
    self.meterObserver = meterObserver;
    
    // mp3 recorder
    MLAudioRecorder *recorder = [[MLAudioRecorder alloc]init];
    __weak __typeof(self)weakSelf = self;
    recorder.receiveStoppedBlock = ^{
        weakSelf.meterObserver.audioQueue = nil;
    };
    recorder.receiveErrorBlock = ^(NSError *error){
        weakSelf.meterObserver.audioQueue = nil;
        
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"错误", nil) message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定", nil), nil]show];
    };
    
    recorder.fileWriterDelegate = mp3Writer;
    self.filePath = mp3Writer.filePath;
    [recorder setDelegate:(id<MLAudioRecorderDelegate>)self];
    
    self.mp3Recorder = recorder;
    
    // init amr player
    MLAudioPlayer *mlplayer = [[MLAudioPlayer alloc]init];
    mlplayer.receiveErrorBlock = ^(NSError *error){
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error", nil) message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Sure", nil), nil]show];
    };
    mlplayer.receiveStoppedBlock = ^{
        
    };
    
    mlplayer.receiveCompleteBlock = ^{
        
    };
    
    self.mlplayer = mlplayer;
    
    AmrPlayerReader *amrReader = [[AmrPlayerReader alloc]init];
    
    self.mlplayer.fileReaderDelegate = amrReader;
    
    self.amrReader = amrReader;
    
}

#pragma mark -

-(BOOL)fileIsAmr:(NSString *)path{
    
    NSRange range = [path rangeOfString:@".amr" options:NSBackwardsSearch| NSBackwardsSearch];
    if (range.location == path.length - 4) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - private methods

-(void) playUrl:(NSURL *)url{
    
    //设置audio session的category
    [self stopPlay];
    
    if ([self fileIsAmr:url.path]) {
        self.amrReader.filePath = url.path;
        [self.mlplayer startPlaying];
    }else{
        if (self.mp3Player) {
            [self.mp3Player stop];
            self.mp3Player.delegate = nil;
            self.mp3Player = nil;
        }
        
        //初始化播放器的时候如下设置
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                                sizeof(sessionCategory),
                                &sessionCategory);
        
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                                 sizeof (audioRouteOverride),
                                 &audioRouteOverride);
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //默认情况下扬声器播放
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
        
        
        NSError *error = nil;
        NSLog(@"%@",url.path);
        
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        
        self.mp3Player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
            if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayError)]) {
                [self.delegate onPlayError];
            }
        }
        self.mp3Player.meteringEnabled = YES;
        self.mp3Player.delegate = self;
        [self.mp3Player prepareToPlay];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayingChangePlayMode:)]) {
            [self.delegate onPlayingChangePlayMode:YES];
        }
        
        [self.mp3Player play];
    }
}


#pragma mark - 停止播放

-(void) stopPlay{
    if (self.mp3Player.isPlaying) {
        [self.mp3Player stop];
        self.mp3Player.delegate = nil;
        self.mp3Player = nil;
    }
    if (self.mlplayer.isPlaying) {
        [self.mlplayer stopPlaying];
    }
}


#pragma mark - 开始录音

-(void) startRecord {
    [self stopRecord];
    [self.mp3Recorder startRecording];
    self.meterObserver.audioQueue = self.mp3Recorder->_audioQueue;
}

#pragma mark - 停止录音

-(void) stopRecord {
    [self.mp3Recorder stopRecording];
}

#pragma mark - 停止录音和播放

-(void) finishRecorderAndPlayer {
    [self stopRecord];
    [self stopPlay];
    
}

#pragma mark - 上传语音

-(BOOL) uploadVoiceWith:(NSNumber *)duration {
    
    NSString* path = self.filePath;
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (nil == data || data.length < 512) {
        
        return NO;
    }
    
    [NDBaseAPI uploadFile:data name:@"file" fileName:[NSString stringWithFormat:@"%f.mp3",[[NSDate date]timeIntervalSinceNow]] mimeType:@"audio/mpeg" ProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten,long long totalBytesExpectedToWrite) {
        
    } successBlock:^(NSString *filepath) {
        NDMailSendParams *params = [[NDMailSendParams alloc] init];
        params.url = filepath;
        params.group_id = [ShareValue sharedShareValue].group_id;
        params.duration = duration;
        params.mail_type = @0;
        params.content = nil;
        [NDMailAPI mailSendWithParams:params completionBlockWithSuccess:^(NDMailSendResult *data) {
            Mail *mail = [[Mail alloc] init];
            mail.mail_id =  [NSNumber numberWithInt:[[NSDate date]timeIntervalSince1970]];
            mail.send_id = [ShareValue sharedShareValue].user_id;
            mail.send_type = @0;
            mail.send_time = data.send_time;
            mail.duration = duration;
            mail.url = filepath;
            mail.isRead = YES;
            [mail save];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(onSendSuccess:)]) {
                [self.delegate onSendSuccess:mail];
            }
            
        } Fail:^(int code, NSString *failDescript) {
            if (self.delegate &&[self.delegate respondsToSelector:@selector(onSendFail:)]) {
                [self.delegate onSendFail:failDescript];
            }
        }];
        
    } errorBlock:^(BOOL NotReachable) {
        if (self.delegate &&[self.delegate respondsToSelector:@selector(onSendFail:)]) {
            [self.delegate onSendFail:NSLocalizedString(@"网络不给力", nil)];
        }
    }];
    return YES;
}


#pragma mark - 上传语音

-(BOOL) uploadGreetingWith:(NSNumber *)duration {
    
    NSString* path = self.filePath;
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (nil == data || data.length < 512) {
        
        return NO;
    }
    
    [NDBaseAPI uploadGreetingFile:data name:@"file" fileName:[NSString stringWithFormat:@"%f.mp3",[[NSDate date]timeIntervalSinceNow]] mimeType:@"audio/mpeg" ProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten,long long totalBytesExpectedToWrite) {
        
    } successBlock:^(NSString *filepath) {
        NDMailSendGreetingParams *params = [[NDMailSendGreetingParams alloc] init];
        params.url = filepath;
        params.duration = duration;
        [NDMailAPI mailSendGreetingWithParams:params completionBlockWithSuccess:^(NDMailSendGreetingResult *data) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(onSendSuccess:)]) {
                [self.delegate onSendSuccess:nil];
            }
            
        } Fail:^(int code, NSString *failDescript) {
            if (self.delegate &&[self.delegate respondsToSelector:@selector(onSendFail:)]) {
                [self.delegate onSendFail:failDescript];
            }
        }];
        
    } errorBlock:^(BOOL NotReachable) {
        if (self.delegate &&[self.delegate respondsToSelector:@selector(onSendFail:)]) {
            [self.delegate onSendFail:NSLocalizedString(@"网络不给力", nil)];
        }
    }];
    return YES;
}



#pragma mark - 开始播放语音
-(void)downloadPlay:(NSURL *)url{
    [NDBaseAPI downloadFile:url fileid:@"111" downloadProgress:^(float progress) {
        
    } successBlock:^(NSURL *filepath) {
        [self playUrl:filepath];
    } errorBlock:^(NSString *descript) {
        
    }];
}

-(void) beginPlay:(Mail*) mail {
    if (nil == mail) {
        return;
    }
    
    if ([mail.localUrl length] != 0) {
        
        NSString *saveDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *savePath = [saveDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[mail.localUrl lastPathComponent]]];
        NSURL *fileUrl_play = [NSURL fileURLWithPath:savePath];
        
        [self playUrl:fileUrl_play];
        
    }else {
        
        [self downloadMail:mail success:^(NSURL *fileUrl) {
            
            NSString *saveDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *savePath = [saveDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[mail.localUrl lastPathComponent]]];
            NSURL *fileUrl_play = [NSURL fileURLWithPath:savePath];
            
            [self playUrl:fileUrl_play];
            
        }fail:^(BOOL notReachable, NSString *desciption) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayError)]) {
                [self.delegate onPlayError];
            }
        }];
    }
}

#pragma mark - 开始播放祝福语音

-(void) beginPlayGreeting:(GreetingMail*) greetingMail {
    if (nil == greetingMail) {
        return;
    }
    
    if ([greetingMail.localUrl length] != 0) {
        
        NSString *saveDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *savePath = [saveDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[greetingMail.localUrl lastPathComponent]]];
        NSURL *fileUrl_play = [NSURL fileURLWithPath:savePath];
        
        [self playUrl:fileUrl_play];
        
    }else {
        
        [self downloadGreetingMail:greetingMail success:^(NSURL *fileUrl) {
            
            NSString *saveDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *savePath = [saveDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[greetingMail.localUrl lastPathComponent]]];
            NSURL *fileUrl_play = [NSURL fileURLWithPath:savePath];
            
            [self playUrl:fileUrl_play];
            
        }fail:^(BOOL notReachable, NSString *desciption) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayError)]) {
                [self.delegate onPlayError];
            }
        }];
    }
}


#pragma mark - 停止播放语音

-(void) stopPlay:(Mail *)mail{
    
    [self stopPlay];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(stopPlaySuccess:)]) {
        [self.delegate stopPlaySuccess:mail];
    }
}


-(void) stopPlayGreetingMail:(GreetingMail *)greetingMail{
    
    [self stopPlay];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(stopPlayGreetingSuccess:)]) {
        [self.delegate stopPlayGreetingSuccess:greetingMail];
    }
}


#pragma mark - 下载语音

-(void)downloadMail:(Mail *)mail success:(void(^)(NSURL *fileUrl))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    if (mail.localUrl.length>0) {
        success([NSURL fileURLWithPath:mail.localUrl]);
        return;
    }
    [NDBaseAPI downloadFile:[NSURL URLWithString:mail.url] fileid:[mail.mail_id stringValue] downloadProgress:^(float progress) {
        
    } successBlock:^(NSURL *filepath) {
        mail.localUrl = filepath.path;
        [mail save];
        success([NSURL fileURLWithPath:mail.localUrl]);
    } errorBlock:^(NSString *descript) {
        fail(YES,descript);
    }];
}


-(void)downloadGreetingMail:(GreetingMail *)greetingMail success:(void(^)(NSURL *fileUrl))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    if (greetingMail.localUrl.length>0) {
        success([NSURL fileURLWithPath:greetingMail.localUrl]);
        return;
    }
    [NDBaseAPI downloadFile:[NSURL URLWithString:greetingMail.url] fileid:[greetingMail.greeting_id stringValue] downloadProgress:^(float progress) {
        
    } successBlock:^(NSURL *filepath) {
        greetingMail.localUrl = filepath.path;
        
        success([NSURL fileURLWithPath:greetingMail.localUrl]);
    } errorBlock:^(NSString *descript) {
        fail(YES,descript);
    }];
}


#pragma mark - 开始播放私聊语音

-(void) beginPlayPrivateMail:(VMail*) mail {
    if (nil == mail) {
        return;
    }
    
    if ([mail.localUrl length] != 0) {
        
        NSString *saveDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *savePath = [saveDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[mail.localUrl lastPathComponent]]];
        NSURL *fileUrl_play = [NSURL fileURLWithPath:savePath];
        
        [self playUrl:fileUrl_play];
        
    }else {
        
        [self downloadPrivateMail:mail success:^(NSURL *fileUrl) {
            
            NSString *saveDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *savePath = [saveDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[mail.localUrl lastPathComponent]]];
            NSURL *fileUrl_play = [NSURL fileURLWithPath:savePath];
            
            [self playUrl:fileUrl_play];
            
        }fail:^(BOOL notReachable, NSString *desciption) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayError)]) {
                [self.delegate onPlayError];
            }
        }];
    }
}

#pragma mark - 私聊语音下载

-(void)downloadPrivateMail:(VMail *)mail success:(void(^)(NSURL *fileUrl))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    if (mail.localUrl.length>0) {
        success([NSURL fileURLWithPath:mail.localUrl]);
        return;
    }
    [NDBaseAPI downloadFile:[NSURL URLWithString:mail.url] fileid:[mail.mail_id stringValue] downloadProgress:^(float progress) {
        
    } successBlock:^(NSURL *filepath) {
        mail.localUrl = filepath.path;
        success([NSURL fileURLWithPath:mail.localUrl]);
    } errorBlock:^(NSString *descript) {
        fail(YES,descript);
    }];
}






#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayFinish)]) {
        [self.delegate onPlayFinish];
    }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayFinish)]) {
        [self.delegate onPlayFinish];
    }
    
}

- (void)mlAudioPlayerDidFinishPlaying:(MLAudioPlayer *)player successfully:(BOOL)flag{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayFinish)]) {
        [self.delegate onPlayFinish];
    }
}

- (void)recordError:(NSError *)error{
    
    NSLog(@"%@",error.localizedDescription);
}


- (void)recordStopped{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onstopRecord)]) {
        [self.delegate onstopRecord];
    }
}



@end
