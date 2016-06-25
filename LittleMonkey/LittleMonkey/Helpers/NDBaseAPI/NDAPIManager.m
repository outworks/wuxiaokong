//
//  NDAPIManager.m
//  Pods
//
//  Created by ilikeido on 14-12-5.
//
//

#import "NDAPIManager.h"

#import "NDAPIShareValue.h"

@implementation NDAPIManager

+(void)startWithAppKey:(NSString *)appKey secretKey:(NSString *)secretKey{
    [NDAPIShareValue standardShareValue].app_key = appKey;
    [NDAPIShareValue standardShareValue].secret_key = secretKey;
}

@end
