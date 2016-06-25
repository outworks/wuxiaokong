//
//  Mail.m
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "Mail.h"
#import "LKDBHelper.h"
#import "ShareValue.h"


@implementation Mail

-(void)save{
    self.own_id = [ShareValue sharedShareValue].user_id;
    self.group_id = [ShareValue sharedShareValue].group_id;
    NSInteger rowcount = [Mail rowCountWithWhereFormat:@"mail_id=%@",_mail_id];
    if (rowcount>0) {
        [Mail updateToDB:self where:[NSString stringWithFormat:@"mail_id=%@",_mail_id]];
    }else{
        [self saveToDB];
    }
}

-(Mail *)getNextMinMail{
    Mail *mail = [Mail searchSingleWithWhere:[NSString stringWithFormat:@"send_time<%@ and own_id =%@ and group_id =%@",self.send_time,[ShareValue sharedShareValue].user_id,[ShareValue sharedShareValue].group_id] orderBy:@"send_time desc"];
    return mail;
}

-(Mail *)getNextFlagMail{
    Mail *mail = [Mail searchSingleWithWhere:[NSString stringWithFormat:@"send_time>%@ and flag=1 and own_id =%@ and group_id =%@",self.send_time,[ShareValue sharedShareValue].user_id,[ShareValue sharedShareValue].group_id] orderBy:@"send_time desc"];
    return mail;
}

+(Mail *)getLastFlagMail{
    Mail *mail = [Mail searchSingleWithWhere:[NSString stringWithFormat:@"flag=1 and own_id =%@ and group_id =%@",[ShareValue sharedShareValue].user_id,[ShareValue sharedShareValue].group_id] orderBy:@"send_time desc"];
    return mail;
}

+(Mail *)getLastMail{
    Mail *mail = [Mail searchSingleWithWhere:[NSString stringWithFormat:@"own_id =%@ and group_id =%@",[ShareValue sharedShareValue].user_id,[ShareValue sharedShareValue].group_id] orderBy:@"send_time desc"];
    return mail;
}

+(NSArray *)localArrayFormMin:(NSNumber *)min toMax:(NSNumber *)max pagesize:(int)pagesize{
    NSString *sql = @"";
    if (min) {
        sql = [sql stringByAppendingFormat:@" send_time>=%@",min];
    }
    if (sql.length>0 && max) {
        sql = [sql stringByAppendingFormat:@" and "];
    }
    if(max){
        sql = [sql stringByAppendingFormat:@" send_time<%@",max];
    }
    
    if (sql.length>0) {
        sql = [sql stringByAppendingFormat:@" and "];
    }

    sql = [sql stringByAppendingFormat:@"own_id =%@ and group_id =%@",[ShareValue sharedShareValue].user_id,[ShareValue sharedShareValue].group_id];
    
    return [Mail searchWithWhere:sql orderBy:@"send_time desc" offset:0 count:pagesize];
}

@end
