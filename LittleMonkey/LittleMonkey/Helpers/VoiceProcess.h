//
//  VoiceProcess.h
//  HelloToy
//
//  Created by nd on 15/5/14.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MLAudioRecorder.h"
#import "Mp3RecordWriter.h"
#import "AmrPlayerReader.h"
#import "MLAudioMeterObserver.h"

#import "NDMailAPI.h"
#import "VMail.h"

@protocol VoiceDelegate <NSObject>

@optional
-(void) onPlayFinish;
-(void) onPlayError;
-(void) onstopRecord;
-(void) stopPlaySuccess:(Mail *)mail;
-(void) stopPlayGreetingSuccess:(GreetingMail *)greetingMail;

-(void) onSendSuccess:(Mail*) mail;
-(void) onSendFail:(NSString*) fail;

-(void) onDownloadSuccess:(NSURL*) filePath;

- (void)onPlayingChangePlayMode:(BOOL)state;

@end


@interface VoiceProcess : NSObject <AVAudioPlayerDelegate>

@property(nonatomic,assign) id<VoiceDelegate> delegate;

@property (nonatomic, strong) Mp3RecordWriter *mp3Writer;
@property (nonatomic, strong) MLAudioRecorder *mp3Recorder;
@property (nonatomic, strong) MLAudioMeterObserver *meterObserver;
@property (nonatomic, strong) MLAudioPlayer *mlplayer;
@property (nonatomic, strong) AVAudioPlayer *mp3Player;
@property (nonatomic, strong) AmrPlayerReader *amrReader;


@property (nonatomic, strong) NSString* filePath;


+(VoiceProcess*) shareInstance;

-(void)downloadPlay:(NSURL *)url;

-(void) playUrl:(NSURL *)url;
-(void) stopPlay;
-(void) startRecord;
-(void) stopRecord;
-(void) finishRecorderAndPlayer;
-(BOOL) uploadVoiceWith:(NSNumber *)duration;
-(BOOL) uploadGreetingWith:(NSNumber *)duration; //上传祝福语

-(void) beginPlay:(Mail*) mail;     // 开始播放语音
-(void) beginPlayGreeting:(GreetingMail*) greetingMail; //开始播放祝福语
-(void) stopPlay:(Mail *)mail;      //停止播放语音
-(void) stopPlayGreetingMail:(GreetingMail *)greetingMail; //开始播放祝福语
-(void) beginPlayPrivateMail:(VMail *)mail;


-(void)downloadMail:(Mail *)mail success:(void(^)(NSURL *fileUrl))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
@end
