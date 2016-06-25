//
//  NSObject+LKExt.h
//  LKExt
//
//  Created by ilikeido on 15/4/25.
//  Copyright (c) 2015年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LKDATESTYLE_1970,
    LKDATESTYLE_1970_1000,
    LKDATESTYLE_STRING_DATE,
    LKDATESTYLE_STRING_SECOND,
} LKDATESTYLE;

@protocol NSObject_LKExt <NSObject>

+(NSDictionary *)_dictKey2PropertyNameMaps;

+(NSDictionary *)_arrayPropertyClassMaps;

+(LKDATESTYLE)_dateOutStyle;

@end

@interface NSObject(LKExt)

-(NSDictionary *)_LK2Dict;

@end

@interface NSDictionary(LKExt)

-(id)_Lk2Object:(Class)clazz;

@end

@interface NSDate(LKExt)

-(NSDate *)_Lk2localDate;

-(NSDate *)_Lk2GMTDate;

-(NSString *)_LKStringFormat:(NSString *)format;

+(NSDate *)_LKDateFromString:(NSString *)string withFormat:(NSString *)format;


@end