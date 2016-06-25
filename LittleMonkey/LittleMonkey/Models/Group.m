//
//  Group.m
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "Group.h"
#import "LKDBHelper.h"

@implementation Group

-(void)save{
    NSInteger rowcount = [Group rowCountWithWhereFormat:@"group_id=%@",_group_id];
    if (rowcount>0) {
        [Group updateToDB:self where:[NSString stringWithFormat:@"group_id=%@",_group_id]];
    }else{
        [self saveToDB];
    }
}

@end
