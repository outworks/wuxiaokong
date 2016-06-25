//
//  DownloadAlbumInfo.h
//  HelloToy
//
//  Created by ilikeido on 16/5/4.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  下载专辑详情
 */
@interface DownloadAlbumInfo : NSObject

@property(nonatomic,strong) NSNumber *album_id;//官方id
@property(nonatomic,strong) NSNumber *third_aid;//第三方id
@property(nonatomic,strong) NSString *name;//专辑名
@property(nonatomic,strong) NSString *icon;//图片
@property(nonatomic,strong) NSNumber *number;//歌曲数
@property(nonatomic,strong) NSNumber *download_count;//已下载歌曲数
@property(nonatomic,assign) int source;//来源  0:系统  1:用户上传  2:用户收藏  100:喜马拉雅
@property(nonatomic,strong) NSNumber * cnt;//播放次数
@property(nonatomic,strong) NSString *desc;//描述
@property(nonatomic,strong) NSNumber *album_type;   //专辑类型;


@end
