//
//  ToyStatus.m
//  HelloToy
//
//  Created by chenzf on 15/11/5.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "ToyStatus.h"

@implementation ToyStatus

- (void)setModechange:(NSDictionary *)modechange{
    _modechange = modechange;
    _mode = modechange[DATA_KEY_MODE];
    _mediaid = modechange[DATA_KEY_MEDIAID];
    _albumid = modechange[DATA_KEY_ALBUMID];
    _status  = modechange[DATA_KEY_STATUS];
}

//- (void)setElectricity:(NSString *)electricity{
//    _electricity = electricity;
//
//    if (_electricity) {
//    
//        if ([_electricity isEqualToString:@"-1"]) {
//            _electricity = @"充电中..";
//        }else{
//        
//            _electricity = [NSString stringWithFormat:@"%@%%",_electricity];
//        }
//
//    }
//}

@end
