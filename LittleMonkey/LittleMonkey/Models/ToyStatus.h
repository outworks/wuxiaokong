//
//  ToyStatus.h
//  HelloToy
//
//  Created by chenzf on 15/11/5.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToyStatus : NSObject

typedef enum : NSUInteger {
    TOYMODE_STORY = 0,
    TOYMODE_MUSIC = 1,
    TOYMODE_TALK = 2,
    TOYMODE_JOY = 3,//伙伴模式
    TOYMODE_ALAMR = 4,//闹钟模式
    TOYMODE_FM = 5,//电台模式
    TOYMODE_SLEEP = 6,//休眠模式
    TOYMODE_VOICE = 7,//变声模式
    TOYMODE_WHISPER = 9,//私聊模式
    TOYMODE_NightLight = 10, //夜灯模式
} ToyChangeMode;

@property(nonatomic,strong) NSNumber *toy_id;       //玩具ID
@property(nonatomic,strong) NSDictionary *modechange;         //模式切换
@property(nonatomic,strong) NSString *mode;         //模式
@property(nonatomic,strong) NSString *mediaid;      //媒体ID
@property(nonatomic,strong) NSString *albumid;      //专辑ID
@property(nonatomic,strong) NSString *status;       //播放暂停状态
@property(nonatomic,strong) NSString *electricity;  //电量
@property(nonatomic,strong) NSString *volume;       //音量
@property(nonatomic,strong) NSString *light;        //亮度
@property(nonatomic,strong) NSString *isonline;     //是否在线(1-在线，0-不在线 2-休眠)
@property(nonatomic,strong) NSNumber *loopPlay;     //是否专辑循环
@property(nonatomic,strong) NSNumber *repeatPlay;   //是否语音循环
@property(nonatomic,strong) NSNumber *agility;      //灵敏度
@property(nonatomic,strong) NSNumber *ptt;          //直接应答
@property(nonatomic,strong) NSNumber *powerkey;     //电源短按定义


@end
