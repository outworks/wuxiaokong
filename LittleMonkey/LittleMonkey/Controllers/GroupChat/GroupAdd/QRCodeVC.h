//
//  ScendCodeVC.h
//  HelloToy
//
//  Created by nd on 15/11/13.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabSuperVC.h"

@protocol QRCodeVCDelegate;


@interface QRCodeVC : HideTabSuperVC

@property(nonatomic,weak)id<QRCodeVCDelegate> delegate;

@property(nonatomic,strong) NSString *content;

@end

@protocol QRCodeVCDelegate <NSObject>

@required

-(void)scanReturn:(NSString *)result QRCodeVC:(QRCodeVC *)codeVc;

-(void)scanError;

@end
