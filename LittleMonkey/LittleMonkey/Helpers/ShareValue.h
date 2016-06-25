//
//  ShareValue.h
//  HelloToy
//
//  Created by nd on 15/4/21.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "GroupDetail.h"
#import "Toy.h"

typedef NS_ENUM(NSUInteger, ToyState) {
    ToyStateUnKnowState = 100,
    ToyStateOnlineState = 101,
    ToyStateUnOnlineState = 102,
    ToyStateDormancyState = 103,
    ToyStatePartnerState = 104,
    ToyStateTalkState = 105,
    ToyStateStoryState = 109,
    ToyStateMusicState = 106,
    ToyStateBianShenState = 107,
    ToyStateKitTalkState = 108,
};


typedef NS_ENUM(NSUInteger, PlayState) {
    PlayStateUnKnowState = 200,
    PlayStateStopState = 201,
    PlayStatePlayState = 202,
};

@interface ShareValue : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(ShareValue) //单例

@property(nonatomic,strong) NSNumber * user_id;                         //用户ID
@property(nonatomic,strong) NSNumber * group_id;                        //群ID
@property(nonatomic,strong) NSNumber * group_owner_id;                  // 群主ID

@property(nonatomic,strong) User *user;                                 //用户信息
@property(nonatomic,strong) GroupDetail *groupDetail;                   //当前群信息
@property(nonatomic,strong) Toy *toyDetail;                             //当前玩具信息

@property(nonatomic,strong) NSDictionary *launchOptions;                // appDelegate
@property(nonatomic,strong) NSData *deviceToken;                        //appDelegateDeviceToken;

@property(nonatomic,strong) NSString *miPushId; //小米推送ID


@property(nonatomic,strong) NSNumber *netWork;                          // 判断是否未外网  1 为外网  0为内网

@property(nonatomic,strong) NSNumber * collection_id; //收藏
@property(nonatomic,strong) NSMutableArray *mArr_collections; //收藏


@property(nonatomic,strong) NSString *cur_ablumId;          //当前播放的专辑
@property(nonatomic,strong) NSString *cur_mediaId;          //当前播放的歌曲
@property(nonatomic,strong) NSString *cur_statues;          //当前歌曲播放状态
@property(nonatomic,assign) ToyState cur_toyState;         //当前玩具状态
@property(nonatomic,assign) BOOL downloadVCShowing;

@end
