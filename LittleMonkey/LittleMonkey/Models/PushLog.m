//
//  PushLog.m
//  HelloToy
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "PushLog.h"
#import "LKDBHelper.h"

@implementation PushLog

-(NSString *)name{
    
    if (self.msg_from.intValue == 0) {
        
        return NSLocalizedString(@"MessageCenter", nil);
        
    }
    
    if (self.msg_from.intValue == 1) {
        
        return NSLocalizedString(@"FriendsNotice", nil);
        
    }
    
    if (self.msg_from.intValue == 431) {
        
        return NSLocalizedString(@"OfficialDynamic", nil);
        
    }
    if (self.msg_from.intValue == 432) {
        
        return NSLocalizedString(@"ParentingKnowledge", nil);
        
    }
    
    if (_name.length > 0) {
        
        return _name;
        
    }
    
    User *user =  [User searchSingleWithWhere:[NSString stringWithFormat:@"user_id=%@",self.msg_from] orderBy:nil];
    
    return user.nickname;
    
    return nil;
}

-(NSURL *)iconUrl{
    
    if (self.msg_from.intValue == 0) {
        
        return nil;
        
    }
    
    if (self.msg_from.intValue == 1) {
        
        return nil;
        
    }
    
    if (_iconUrl != nil) {
        
        return _iconUrl;
        
    }
    
    User *user =  [User searchSingleWithWhere:[NSString stringWithFormat:@"user_id=%@",self.msg_from] orderBy:nil];
    
    return [NSURL URLWithString:user.icon];
}

@end
