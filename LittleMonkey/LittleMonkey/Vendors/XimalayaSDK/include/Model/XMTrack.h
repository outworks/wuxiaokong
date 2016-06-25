//
//	XMTrack.h
//
//	Create by 王瑞 on 24/8/2015
//	Copyright © 2015. All rights reserved.
//

//	 

#import <UIKit/UIKit.h>
#import "XMAnnouncer.h"
#import "XMSubordinatedAlbum.h"

@interface XMTrack : NSObject

@property (nonatomic, strong) XMAnnouncer * announcer;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSString * coverUrlLarge;
@property (nonatomic, strong) NSString * coverUrlMiddle;
@property (nonatomic, strong) NSString * coverUrlSmall;
@property (nonatomic, assign) NSInteger createdAt;
@property (nonatomic, assign) NSInteger downloadCount;
@property (nonatomic, assign) NSInteger downloadSize;
@property (nonatomic, strong) NSString * downloadUrl;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger trackId;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, assign) NSInteger orderNum;
@property (nonatomic, assign) NSInteger playCount;
@property (nonatomic, assign) NSInteger playSize24M4a;
@property (nonatomic, assign) NSInteger playSize32;
@property (nonatomic, assign) NSInteger playSize64;
@property (nonatomic, assign) NSInteger playSize64M4a;
@property (nonatomic, strong) NSString * playUrl24M4a;
@property (nonatomic, strong) NSString * playUrl32;
@property (nonatomic, strong) NSString * playUrl64;
@property (nonatomic, strong) NSString * playUrl64M4a;
@property (nonatomic, assign) NSInteger source;
@property (nonatomic, strong) XMSubordinatedAlbum * subordinatedAlbum;
@property (nonatomic, strong) NSString * trackIntro;
@property (nonatomic, strong) NSString * trackTags;
@property (nonatomic, strong) NSString * trackTitle;
@property (nonatomic, assign) NSInteger updatedAt;

@property   (nonatomic, assign) BOOL  playing;
@property   (nonatomic, assign) BOOL  pause;

@property (nonatomic, strong) NSDate *startPlayTime;

@property   (nonatomic, assign) CGFloat   listenedTime;
@property   (nonatomic, assign) CGFloat   listenedPosition;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end