//
//  ND3RDMedia.h
//  HelloToy
//
//  Created by huanglurong on 16/4/20.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ND3RDMedia : NSObject

@property(nonatomic,strong) NSNumber *third_mid; //第三方媒体id
@property(nonatomic,strong) NSString *media_title; //媒体标题
@property(nonatomic,strong) NSString *media_icon; //媒体图标
@property(nonatomic,strong) NSString *media_url; //媒体地址

@end
