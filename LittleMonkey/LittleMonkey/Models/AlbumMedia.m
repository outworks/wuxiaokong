//
//  AlbumMedia.m
//  HelloToy
//
//  Created by nd on 15/4/29.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "AlbumMedia.h"
#import "LKDBHelper.h"

@implementation AlbumMedia

-(void)save{
    NSInteger rowcount = [AlbumMedia rowCountWithWhereFormat:@"media_id=%@",_media_id];
    if (rowcount>0) {
        [AlbumMedia updateToDB:self where:[NSString stringWithFormat:@"media_id=%@",_media_id]];
    }else{
        [self saveToDB];
    }
}


@end
