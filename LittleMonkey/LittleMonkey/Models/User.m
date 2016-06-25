//
//  User.m
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "User.h"
#import "LKDBHelper.h"

@implementation User

-(void)save{
    
    NSInteger rowcount = [User rowCountWithWhereFormat:@"user_id=%@",_user_id];
    
    if (rowcount>0) {
        [User updateToDB:self where:[NSString stringWithFormat:@"user_id=%@",_user_id]];
    }else{
        [self saveToDB];
    }
}

+(BOOL)dbWillInsert:(NSObject*)entity{
    
    User *temp = (User *)entity;
    
    NSInteger rowcount = [User rowCountWithWhereFormat:@"user_id=%@",temp.user_id];
    if (rowcount == 0) {
        return YES;
    }else {
        [User updateToDB:temp where:[NSString stringWithFormat:@"user_id=%@",temp.user_id]];
         return NO;
    }
}

@end
