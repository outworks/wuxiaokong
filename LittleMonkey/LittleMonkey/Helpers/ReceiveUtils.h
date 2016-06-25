//
//  ReceiveUtils.h
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiveUtils : NSObject

+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo;  // 处理收到的APNS消息

@end
