//
//  ToyWifiSecondVC.h
//  LittleMonkey
//
//  Created by Hcat on 16/6/5.
//  Copyright © 2016年 CivetCatsTeam. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "ToyWifiThirdVC.h"

@interface ToyWifiSecondVC : HideTabSuperVC

@property(nonatomic,assign)ToyWifiType type;
@property(nonatomic,strong)NSString *wifiSSID;
@property(nonatomic,strong)NSString *wifiPWD;

@end
