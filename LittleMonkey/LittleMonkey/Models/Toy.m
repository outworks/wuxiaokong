//
//  Toy.m
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "Toy.h"
#import "LKDBHelper.h"

@implementation Toy

-(void)save{
    NSInteger rowcount = [Toy rowCountWithWhereFormat:@"toy_id=%@",[_toy_id stringValue]];
    if (rowcount>0) {
        [Toy updateToDB:self where:[NSString stringWithFormat:@"toy_id=%@",[_toy_id stringValue]]];
        
    }else{
        [self saveToDB];
    }
}

+(BOOL)dbWillInsert:(NSObject*)entity{
    Toy *temp = (Toy *)entity;
    NSInteger rowcount = [Toy rowCountWithWhereFormat:@"toy_id=%@",[temp.toy_id stringValue]];
    
    if (rowcount == 0) {
        return YES;
    }else {
        [Toy updateToDB:temp where:[NSString stringWithFormat:@"toy_id=%@",[temp.toy_id stringValue]]];
        return NO;
    }
}

-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[Toy class]]) {
        Toy *comp = (Toy *) object;
        return [self.toy_id isEqual:comp.toy_id ];
    }
    return NO;
}

@end
