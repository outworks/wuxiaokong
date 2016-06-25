//
//  ToyWifiThirdVC.h
//  LittleMonkey
//
//  Created by Hcat on 16/6/5.
//  Copyright © 2016年 CivetCatsTeam. All rights reserved.
//

#import "HideTabSuperVC.h"

typedef NS_ENUM(NSInteger, ToyWifiType){
    ToyWifiSetType = 0,
    ToySetType
};

@interface ToyWifiThirdVC : HideTabSuperVC

@property(nonatomic,assign)ToyWifiType type;
@property(nonatomic,strong)NSString *wifiSSID;
@property(nonatomic,strong)NSString *wifiPWD;

@end
