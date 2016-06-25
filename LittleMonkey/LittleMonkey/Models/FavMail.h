//
//  FavMail.h
//  HelloToy
//
//  Created by nd on 15/12/1.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavMail : NSObject

@property (nonatomic,strong) NSNumber *fav_id;  //收藏编号ID
@property (nonatomic,strong) NSString *desc;    //描述
@property (nonatomic,strong) NSString *addtime; //添加时间

@end
