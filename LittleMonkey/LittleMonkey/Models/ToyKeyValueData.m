//
//  ToyKeyValueData.m
//  HelloToy
//
//  Created by chenzf on 15/11/13.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "ToyKeyValueData.h"
#import <objc/runtime.h>

@implementation ToyKeyValueData

- (id)init{
    self = [super init];
    if(self){
        _toyStatus = [[ToyStatus alloc] init];
    }
    
    return self;
}

- (void)setIsonline:(NSNumber *)isonline{
    _isonline = isonline;
    
    _toyStatus.isonline = [NSString stringWithFormat:@"%@",isonline];
}

- (void)setElems:(NSArray *)elems{
    _elems = elems;
    
    for(NSDictionary *dict in elems){
        
        NSDictionary *dicValue = dict[@"value"];
        
        for(NSString *key in dicValue.allKeys){
            if(key.length == 0){
                continue;
            }
            
            objc_property_t protpery_t = class_getProperty([ToyStatus class], [key UTF8String]);
            if(protpery_t){
                id value = dicValue[key];
                if(!value || [value isKindOfClass:[NSNull class]]){
                    continue;
                }
                
                [_toyStatus setValue:value forKey:key];
            }
        }
    }
}

@end
