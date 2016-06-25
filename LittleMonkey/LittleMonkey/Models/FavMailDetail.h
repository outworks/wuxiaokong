//
//  FavMailDetail.h
//  HelloToy
//
//  Created by nd on 15/12/1.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavMailDetail : NSObject

@property (nonatomic,strong) NSNumber *fav_id;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSArray  *mails;
@property (nonatomic,strong) NSString *addtime;

@end
