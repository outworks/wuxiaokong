//
//  NDAPIShareVaule.m
//  Pods
//
//  Created by ilikeido on 14-12-5.
//
//

#import "NDAPIShareValue.h"

#define NDUSERDEFAULT_TOKEN @"NDUSERDEFAULT_TOKEN"
#define NDUSERDEFAULT_USERID @"NDUSERDEFAULT_USERID"

@implementation NDAPIShareValue

+(NDAPIShareValue *)standardShareValue{
    static NDAPIShareValue *_signleInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _signleInstance = [[NDAPIShareValue alloc]init];
    });
    return _signleInstance;
}

-(void)setToken:(NSString *)token{
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:NDUSERDEFAULT_TOKEN];
}

-(NSString *)token{
    return [[NSUserDefaults standardUserDefaults]stringForKey:NDUSERDEFAULT_TOKEN];
}

-(void)setUser_id:(NSString *)user_id{
    [[NSUserDefaults standardUserDefaults] setValue:user_id forKey:NDUSERDEFAULT_USERID];
}

-(NSString *)user_id{
    return [[NSUserDefaults standardUserDefaults]stringForKey:NDUSERDEFAULT_USERID];
}

@end
