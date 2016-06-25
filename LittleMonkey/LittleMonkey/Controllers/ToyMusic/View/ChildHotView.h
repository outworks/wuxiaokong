//
//  ChildHotView.h
//  HelloToy
//
//  Created by huanglurong on 16/4/14.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChildHotViewBlock)();

@interface ChildHotView : UIView

@property (nonatomic,copy) ChildHotViewBlock block;


@end
