//
//  ND3RDAlbumMedia.h
//  HelloToy
//
//  Created by huanglurong on 16/4/20.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ND3RDAlbumMedia : NSObject

@property(nonatomic,strong)NSNumber *third_mid; //媒体编号
@property(nonatomic,strong)NSString *name; //媒体名称
@property(nonatomic,strong)NSString *icon; //收件人编号
@property(nonatomic,strong)NSString *url; //URL
@property(nonatomic,strong)NSNumber *download; //1: download, 0: not download

@end
