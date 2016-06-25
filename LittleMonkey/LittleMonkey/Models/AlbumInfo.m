//
//  AlbumInfo.m
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "AlbumInfo.h"
#import "LKDBHelper.h"

@implementation AlbumInfo

-(void)save{
    NSInteger rowcount = [AlbumInfo rowCountWithWhereFormat:@"album_id=%@",_album_id];
    if (rowcount>0) {
        [AlbumInfo updateToDB:self where:[NSString stringWithFormat:@"album_id=%@",_album_id]];
    }else{
        [self saveToDB];
    }
}

@end
