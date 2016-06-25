//
//  GroupDetial.m
//  HelloToy
//
//  Created by nd on 15/4/28.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "GroupDetail.h"
#import "Toy.h"
#import "User.h"
#import "LKDBHelper.h"

@implementation GroupDetail

-(void)save{
    NSInteger rowcount = [GroupDetail rowCountWithWhereFormat:@"group_id=%@",_group_id];
    if (rowcount>0) {
        [GroupDetail updateToDB:self where:[NSString stringWithFormat:@"group_id=%@",_group_id]];
        
    }else{
        
        [self saveToDB];
        
    }
}



+(Class)__toy_listClass{
    return [Toy class];
}

+(Class)__user_listClass{
    return [User class];
}

@end
