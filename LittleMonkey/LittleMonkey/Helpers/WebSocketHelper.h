//
//  WebSocketHelper.h
//  Talker
//
//  Created by ilikeido on 15/5/8.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCSingletonTemplate.h"

@interface WebSocketHelper : NSObject

@property(nonatomic,strong) NSString *serverUrl;

SYNTHESIZE_SINGLETON_FOR_HEADER(WebSocketHelper)

-(void)startServer;

-(void)closeServer;

@end
