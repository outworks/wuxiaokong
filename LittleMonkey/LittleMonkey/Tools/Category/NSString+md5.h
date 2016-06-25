//
//  NSString+md5.h
//  HelloToy
//
//  Created by nd on 15/5/29.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (md5)
-(NSString *) md5HexDigest;
@end
