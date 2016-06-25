//
//  ImageFileInfo.h
//  Talker
//
//  Created by mac on 14-8-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageFileInfo : NSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *fileName;
@property(nonatomic,strong) NSString *mimeType;
@property(nonatomic,assign) long long filesize;
@property(nonatomic,strong) NSData *fileData;
@property(nonatomic,strong) UIImage *image;

-(id)initWithImage:(UIImage *)image;

@end
