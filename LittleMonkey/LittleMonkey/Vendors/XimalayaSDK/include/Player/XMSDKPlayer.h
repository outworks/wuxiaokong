//
//  XMSDKPlayer.h
//  libXMOpenPlatform
//
//  Created by nali on 15/7/13.
//  Copyright (c) 2015年 ximalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMSDK.h"
#import <CoreGraphics/CGBase.h>

typedef NS_ENUM(NSInteger, XMSDKPlayMode) {
    XMSDKPlayModeTrack = 0,
    XMSDKPlayModeLive
};


typedef NS_ENUM(NSInteger, XMSDKTrackPlayMode) {
    XMTrackPlayerModeList = 0,       // 列表 (默认)
    XMTrackModeSingle,         // 单曲循环
    XMTrackModeRandom,         // 随机顺序
    
    XMTrackPlayerModeEnd          // mark for rounded
};

@protocol XMTrackPlayerDelegate <NSObject>

@optional


#pragma mark - process notification
//播放时被调用，频率为1s，告知当前播放进度和播放时间
- (void)XMTrackPlayNotifyProcess:(CGFloat)percent currentSecond:(NSUInteger)currentSecond;
//播放时被调用，告知当前播放器的缓冲进度
- (void)XMTrackPlayNotifyCacheProcess:(CGFloat)percent;

#pragma mark - player state change
//播放列表结束时被调用
- (void)XMTrackPlayerDidPlaylistEnd;

//将要播放时被调用
- (void)XMTrackPlayerWillPlaying;
//已经播放时被调用
- (void)XMTrackPlayerDidPlaying;
//暂停时调用
- (void)XMTrackPlayerDidPaused;
//停止时调用
- (void)XMTrackPlayerDidStopped;
//结束播放时调用
- (void)XMTrackPlayerDidEnd;
//播放出错时调用
- (void)XMTrackPlayerDidErrorWithType:(NSInteger)type withData:(NSDictionary*)data;

@end

@protocol XMLivePlayerDelegate <NSObject>

@optional
#pragma mark - live radio

- (void)XMLiveRadioPlayerDidFailWithError:(NSError *)error;

- (void)XMLiveRadioPlayerNotifyCacheProgress:(CGFloat)percent;

- (void)XMLiveRadioPlayerNotifyPlayProgress:(CGFloat)percent currentTime:(NSInteger)currentTime;

- (void)XMLiveRadioPlayerDidEnd;

- (void)XMLiveRadioPlayerDidPaused;

- (void)XMLiveRadioPlayerDidPlaying;

- (void)XMLiveRadioPlayerDidStart;

- (void)XMLiveRadioPlayerDidStopped;

- (void)XMLivePlayerWillPlaying;

- (void)XMLivePlayerDidDataBufferStart;

- (void)XMLivePlayerDidDataBufferEnd;

@end


@interface XMSDKPlayer : NSObject


+ (XMSDKPlayer *)sharedPlayer;

@property (nonatomic,assign) id<XMTrackPlayerDelegate>    trackPlayDelegate;
@property (nonatomic,assign) id<XMLivePlayerDelegate>    livePlayDelegate;


// 默认使用低码率的url进行播放，如果需要使用高码率，请将usingHighQualityUrl 设置为YES；
@property (nonatomic,assign) BOOL usingHighQualityUrl;
/**
 * 设置播放器播放模式：专辑播放、电台播放
 */
- (void)setPlayMode:(XMSDKPlayMode)playMode;
/**
 * 设置播放器的音量,volume范围：0～1
 */
- (void)setVolume:(float)volume;

/**
 *  获得播放器缓存的路径，第三方可以自己统计缓存大小
 *
 */
- (unsigned long long)getTotalCacheSize;


#pragma mark Track Play Method
/**
 * 播放声音列表
 */
- (void)playWithTrack:(XMTrack *)track playlist:(NSArray *)playlist;

/**
 * 接着播上一次正在播放的专辑
 */
- (void)continuePlayFromAlbum:(NSInteger)albumID track:(NSInteger)trackID;

/**
 * 暂停当前播放
 */
- (void)pauseTrackPlay;
/**
 * 恢复当前播放
 */
- (void)resumeTrackPlay;
/**
 * 停止当前播放
 */
- (void)stopTrackPlay;

/**
 * 更新当前播放列表
 */

- (void)replacePlayList:(NSArray *)playlist;
/**
 * 播放下一首
 */
- (BOOL)playNextTrack;
/**
 * 播放上一首
 */
- (BOOL)playPrevTrack;
/**
 * 设置播放器自动播放下一首
 */
- (void)setAutoNexTrack:(BOOL)status;

/**
 * 返回当前播放列表
 */
- (NSArray *)playList;
/**
 * 返回下一首
 */
- (XMTrack *)nextTrack;
/**
 * 返回上一首
 */
- (XMTrack *)prevTrack;
/**
 * 设置播放器从特定的时间播放
 */
- (void)seekToTime:(CGFloat)percent;
/**
 * 清空缓存
 */
- (void)clearCacheSafely;
/**
 * 设置当前播放器的下一首选择模式：单曲循环、专辑列表循环、随机
 */
- (void)setTrackPlayMode:(XMSDKTrackPlayMode)trackPlayMode;
/**
 * h获取当前播放器的下一首选择模式：单曲循环、专辑列表循环、随机
 */
- (XMSDKTrackPlayMode)getTrackPlayMode;
/**
 * 返回当前播放的声音
 */
- (XMTrack*)currentTrack;

#pragma mark Live Play Method
/**
 * 开始播放直播电台
 */
- (void)startLivePlayWithRadio:(XMRadio*)radio;
/**
 * 停止当前电台播放
 */
- (void)pauseLivePlay;
/**
 * 恢复当前电台播放
 */
- (void)resumeLivePlay;
/**
 * 停止当前电台播放
 */
- (void)stopLivePlay;
/**
 * 播放直播电台当前时间之前的节目
 */
- (void)startHistoryLivePlayWithRadio:(XMRadio*)radio withProgram:(XMRadioSchedule*)program;
/**
 * 播放直播电台当前时间之前的节目列表
 */
- (void)startHistoryLivePlayWithRadio:(XMRadio*)radio withProgram:(XMRadioSchedule*)program inProgramList:(NSArray*)list;
/**
 * 设置播放器到指定的时间播放
 */
- (BOOL)seekHistoryLivePlay:(double)durtion;
/**
 * 播放下一个录播电台节目
 */
- (void)playNextProgram;
/**
 * 播放上一个录播电台节目
 */
- (void)playPreProgram;
/**
 * 清理缓存  和直播相同
 */
//- (void)clearCacheSafely;

/**
 * 返回当前正在播放的电台
 */
- (XMRadio*)currentPlayingRadio;
/**
 * 返回当前正在播放的节目
 */
- (XMRadioSchedule*)currentPlayingProgram;

@end
