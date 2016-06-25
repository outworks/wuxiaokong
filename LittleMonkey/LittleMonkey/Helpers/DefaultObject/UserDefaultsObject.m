//
//  UserDefaultsObject.m
//  HelloToy
//
//  Created by nd on 15/4/22.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "UserDefaultsObject.h"
#import "UserDefaultsMacro.h"

@implementation UserDefaultsObject

SYNTHESIZE_SINGLETON_FOR_CLASS(UserDefaultsObject)


-(void)setUser_id:(NSNumber *)user_id{
    
    [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:NSDEFAULT_USERID];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(NSNumber *)user_id{

    return [[NSUserDefaults standardUserDefaults] objectForKey:NSDEFAULT_USERID];
    
}

-(void)setGroup_id:(NSNumber *)group_id{
    
    [[NSUserDefaults standardUserDefaults] setObject:group_id forKey:NSDEFAULT_GROUPID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(NSNumber *)group_id{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:NSDEFAULT_GROUPID];
    
}

-(void)setGroup_owner_id:(NSNumber *)group_owner_id{
    
    [[NSUserDefaults standardUserDefaults] setObject:group_owner_id forKey:NSDEFAULT_GROUP_OWNER_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(NSNumber *)group_owner_id{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:NSDEFAULT_GROUP_OWNER_ID];
    
}

-(void)setToy_id:(NSNumber *)toy_id{
    
    [[NSUserDefaults standardUserDefaults] setObject:toy_id forKey:NSDEFAULT_TOYID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(NSNumber *)toy_id{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:NSDEFAULT_TOYID];
    
}

- (void)setMiPushId:(NSString *)miPushId{

    [[NSUserDefaults standardUserDefaults] setObject:miPushId forKey:NSDEFALUT_MIPUSHID];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (NSString *)miPushId{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:NSDEFALUT_MIPUSHID];
    
}


-(void)setCollection_id:(NSNumber *)collection_id{
    
    [[NSUserDefaults standardUserDefaults] setObject:collection_id forKey:NSDEFAULT_COLLECTION_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(NSNumber *)collection_id{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:NSDEFAULT_COLLECTION_ID];
    
}


- (void)setIsRememberPassword:(BOOL)isRememberPassword{
    
    [[NSUserDefaults standardUserDefaults] setBool:isRememberPassword forKey:NSDEFAULT_REMEMBERPASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isRememberPassword{
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:NSDEFAULT_REMEMBERPASSWORD];
    
}

- (void)setUserInfo:(NSMutableDictionary *)userInfo{
    
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:NSDEFAULT_USERINFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSMutableDictionary *)userInfo{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:NSDEFAULT_USERINFO];
    
}


- (void)setNetWork:(NSNumber *)netWork{

    [[NSUserDefaults standardUserDefaults] setObject:netWork forKey:NSDEFAULT_NETWORK];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (NSNumber *)netWork{

    return [[NSUserDefaults standardUserDefaults] objectForKey:NSDEFAULT_NETWORK];
    
}

- (void)setWechatId:(NSNumber *)wechatId{
    
    [[NSUserDefaults standardUserDefaults] setObject:wechatId forKey:NSDEFAULT_BINDPHONE_FIRSTLAUNCH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSNumber *)wechatId{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:NSDEFAULT_BINDPHONE_FIRSTLAUNCH];
    
}

- (void)setLasttime_chat:(NSNumber *)lasttime_chat
{
    [[NSUserDefaults standardUserDefaults] setObject:lasttime_chat forKey:NSDEFAULT_LASTTIME_CHAT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSNumber *)lasttime_chat{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:NSDEFAULT_LASTTIME_CHAT];
    
}

@end
