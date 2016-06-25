//
//  MediaInfo.m
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "MediaInfo.h"
#import "LKDBHelper.h"


@implementation MediaInfo


-(void)save{
    NSInteger rowcount = [MediaInfo rowCountWithWhereFormat:@"media_id=%@",_media_id];
    if (rowcount>0) {
        [MediaInfo updateToDB:self where:[NSString stringWithFormat:@"media_id=%@",_media_id]];
    }else{
        [self saveToDB];
    }
}

@end
