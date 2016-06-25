//
//  NSObject+LKExt.m
//  LKExt
//
//  Created by ilikeido on 15/4/25.
//  Copyright (c) 2015年 ilikeido. All rights reserved.
//

#import "NSObject+LKExt.h"
#import <objc/runtime.h>

@interface LKExt_NSObject : NSObject

+(NSDictionary *)classDefaultPropertyDict:(Class)clazz;

+(BOOL)isInt:(NSString *)typeName;

+(BOOL)isShort:(NSString *)typeName;

+(BOOL)isLong:(NSString *)typeName;

+(BOOL)isLongLong:(NSString *)typeName;

+(BOOL)isChar:(NSString *)typeName;

+(BOOL)isFloat:(NSString *)typeName;

+(BOOL)isDouble:(NSString *)typeName;

+(BOOL)isBOOL:(NSString *)typeName;

@end

@implementation LKExt_NSObject

+(NSString *)typeNameForPropertyTypeAttr:(NSString *)attr{
    NSArray *propertyTypeArray  = [attr componentsSeparatedByString:@","];
    NSString *typeString = [propertyTypeArray firstObject];
    if (typeString) {
        if ([typeString rangeOfString:@"@\""].location == 0 ) {
            NSString *className = [[typeString stringByReplacingOccurrencesOfString:@"@" withString:@""]stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            return className;
        }else{
            if (typeString.length == 1) {
                return typeString;
            }
        }
    }
    return nil;
}

+(NSDictionary *)classDefaultPropertyDict:(Class)clazz{
    if (clazz) {
        unsigned int outCount = 0;
        NSMutableDictionary * typeDict = [NSMutableDictionary dictionary];
        NSMutableDictionary * nameDict = [NSMutableDictionary dictionary];
        // 属性操作
        objc_property_t * properties = class_copyPropertyList(clazz, &outCount);
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *attr= property_getAttributes(property);
            if ( attr[0] != 'T' ){
                continue;
            }
            const char *propertyName = property_getName(property);
            NSString *name = [NSString stringWithFormat:@"%s",propertyName];
            const char * type = &attr[1];
            NSString *typeEncode = [NSString stringWithFormat:@"%s",type];
            NSString *typeName = [LKExt_NSObject typeNameForPropertyTypeAttr:typeEncode];
            if (typeName) {
                [typeDict setObject:typeName forKey:name];
                [nameDict setObject:name forKey:name];
            }
            
        }
        free(properties);
        return [NSDictionary dictionaryWithObjectsAndKeys:nameDict,@"nameDict",typeDict,@"typeDict" ,nil];
    }
    return nil;
}

+(NSDictionary *)_LKPropertyDicMap:(Class)clazz{
    static NSMutableDictionary * lk_propertyDic = nil;
    if (!lk_propertyDic) {
        lk_propertyDic = [[NSMutableDictionary alloc]init];
    }
    NSDictionary *dict = [lk_propertyDic objectForKey:NSStringFromClass(clazz)];
    if (!dict) {
        dict = [LKExt_NSObject classDefaultPropertyDict:clazz];
        [lk_propertyDic setValue:dict forKey:NSStringFromClass(clazz)];
    }
    return dict;
}

+(NSDictionary *)_LKPropertyNameDic:(Class)clazz{
    static NSDictionary * lk_propertyNameDic = nil;
    if (!lk_propertyNameDic) {
        lk_propertyNameDic = [[NSMutableDictionary alloc]init];
    }
    NSDictionary *dict = [lk_propertyNameDic objectForKey:NSStringFromClass(clazz)];
    if (!dict) {
        NSDictionary *propertyDic = [self _LKPropertyDicMap:clazz];
        if (propertyDic) {
            NSMutableDictionary *nameMapDict = [[propertyDic objectForKey:@"nameDict"]mutableCopy];
            if ([clazz respondsToSelector:@selector(_dictKey2PropertyNameMaps)]) {
                NSDictionary *nameDict = [clazz performSelector:@selector(_dictKey2PropertyNameMaps)];
                if (nameDict) {
                    for (NSString *key  in nameDict.allKeys) {
                        [nameMapDict setValue:[nameDict objectForKey:key] forKey:key];
                    }
                }
            }
            dict = nameMapDict;
            [lk_propertyNameDic setValue:nameMapDict forKey:NSStringFromClass(clazz)];
        }
    }
    return dict;
}

+(NSDictionary *)_LKPropertyTypeDic:(Class)clazz{
    NSDictionary * lk_propertyDic =  [self _LKPropertyDicMap:clazz];
    return [lk_propertyDic objectForKey:@"typeDict"];
}


+(NSDictionary *)_LKDefaultPropertyDic:(Class)clazz{
    if ([clazz isSubclassOfClass:[NSString class]]) {
        return nil;
    }
    if ([self isSubclassOfClass:[NSDictionary class]]) {
        return nil;
    }
    if ([self isSubclassOfClass:[NSNumber class]]) {
        return nil;
    }
    if ([self isSubclassOfClass:[NSData class]]) {
        return nil;
    }
    if ([self isSubclassOfClass:[NSNull class]]) {
        return nil;
    }
    return [LKExt_NSObject classDefaultPropertyDict:self.class];
}



+(BOOL)isInt:(NSString *)typeName{
    return [typeName isEqual:@"i"] || [typeName isEqual:@"I"];
}

+(BOOL)isShort:(NSString *)typeName{
    return [typeName isEqual:@"s"] || [typeName isEqual:@"S"];
}

+(BOOL)isLong:(NSString *)typeName{
    return [typeName isEqual:@"l"] || [typeName isEqual:@"L"];
}

+(BOOL)isLongLong:(NSString *)typeName{
    return [typeName isEqual:@"q"] || [typeName isEqual:@"Q"];
}

+(BOOL)isChar:(NSString *)typeName{
    return [typeName isEqual:@"c"] || [typeName isEqual:@"C"];
}

+(BOOL)isFloat:(NSString *)typeName{
    return [typeName isEqual:@"f"] ;
}

+(BOOL)isDouble:(NSString *)typeName{
    return [typeName isEqual:@"d"] ;
}

+(BOOL)isBOOL:(NSString *)typeName{
    return [typeName isEqual:@"B"] ;
}

+(BOOL)typeIsArray:(NSString *)typeName{
    if ([typeName isEqual:@"NSArray"]) {
        return YES;
    }
    if ([typeName isEqual:@"NSMutableArray"]) {
        return YES;
    }
    return NO;
}

+(BOOL)typeIsClass:(NSString *)typeName class:(Class)class{
    if (typeName.length >1) {
        Class class1 = NSClassFromString(typeName);
        if (class1 == class || [class1 isSubclassOfClass:class]) {
            return YES;
        }
    }
    return NO;
}


+(NSObject *)objectFromValue:(id)value asType:(NSString *)type{
    if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *number = value;
        if (type.length >1) {
            Class class = NSClassFromString(type);
            if ([class isSubclassOfClass:[NSString class]]) {
                return [number stringValue];
            }
            if ([class isSubclassOfClass:[NSDate class]]) {
                long long time = [number longLongValue];
                if (time%1000 == 0) {
                    time = time/1000;
                }
                NSDate *date =  [NSDate dateWithTimeIntervalSince1970:time];
                return date;
            }
        }
        if ([LKExt_NSObject isInt:type] || [LKExt_NSObject isFloat:type] || [LKExt_NSObject isChar:type] || [LKExt_NSObject isDouble:type] || [LKExt_NSObject isBOOL:type]) {
            return value;
        }
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSString *stringValue = value;
        if ([LKExt_NSObject typeIsClass:type class:[NSString class]]) {
            return stringValue;
        }
        if ([LKExt_NSObject typeIsClass:type class:[NSDate class]]) {
            NSString *dateStyle1 = @"yyyy-MM-dd";
            NSString *dateStyle2 = @"yyyy-MM-dd HH:mm:ss";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            if (stringValue.length == dateStyle2.length) {
                [dateFormatter setDateFormat:dateStyle2];
            }else if(stringValue.length == dateStyle1.length){
                [dateFormatter setDateFormat:dateStyle1];
            }
            NSDate *date = [dateFormatter dateFromString:stringValue];
            return date;
        }
        if ([LKExt_NSObject isInt:type]) {
            int value = [stringValue intValue];
            return [NSNumber numberWithInt:value];
        }
        if ([LKExt_NSObject isBOOL:type]) {
            BOOL value = [stringValue boolValue];
            return [NSNumber numberWithBool:value];
        }
        if ([LKExt_NSObject isDouble:type]) {
            double value = [stringValue doubleValue];
            return [NSNumber numberWithDouble:value];
        }
        if ([LKExt_NSObject isFloat:type]) {
            float value = [stringValue floatValue];
            return [NSNumber numberWithFloat:value];
        }
        if ([LKExt_NSObject isLongLong:type]) {
            long long value = [stringValue longLongValue];
            return [NSNumber numberWithLongLong:value];
        }
        if ([LKExt_NSObject isShort:type]) {
            double value = [stringValue doubleValue];
            return [NSNumber numberWithDouble:value];
        }
    }
    if ([LKExt_NSObject isInt:type] || [LKExt_NSObject isFloat:type] || [LKExt_NSObject isChar:type] || [LKExt_NSObject isDouble:type] || [LKExt_NSObject isBOOL:type]) {
        return [NSNumber numberWithDouble:0];
    }
    if(value && [value isKindOfClass:[NSDictionary class]]){
        Class class = NSClassFromString(type);
        if (class) {
            NSDictionary *temp = (NSDictionary *)value;
            NSObject *obj = [temp _Lk2Object:class];
            value = obj;
        }else{
            value = nil;
        }
    }
    return value;
}

@end


@implementation NSObject(LKExt)

-(NSDictionary *)_LK2Dict{
    if (self) {
    NSDictionary * lk_propertyNameDic = [LKExt_NSObject _LKPropertyNameDic:[self class]];
      NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
      NSArray *keys = lk_propertyNameDic.allKeys;
        for (NSString *key in keys) {
            NSString *propertyName = [lk_propertyNameDic objectForKey:key];
            id value = [self valueForKey:key];
            if ([value isKindOfClass:[NSArray class]] ) {
                NSMutableArray *result = [NSMutableArray array];
                for (NSObject *temp in value) {
                    NSDictionary *dict = [temp _LK2Dict];
                    [result addObject:dict];
                }
                value = result;
            }
            if (value) {
                if ([value isKindOfClass:[NSDate class]]) {
                    if ([self respondsToSelector:@selector(_dateOutStyle)]) {
                        LKDATESTYLE  _dateStyle = [self respondsToSelector:@selector(_dateOutStyle)];
                        switch (_dateStyle) {
                            case LKDATESTYLE_1970:{
                                long long time = [(NSDate *)value timeIntervalSince1970];
                                value = [NSNumber numberWithLongLong:time];
                                break;
                            }case LKDATESTYLE_1970_1000:{
                                long long time = [(NSDate *)value timeIntervalSince1970];
                                value = [NSNumber numberWithLongLong:time*1000];
                                break;
                            }case LKDATESTYLE_STRING_DATE:{
                                
                                break;
                            }
                            default:
                                break;
                        }
                    }
                    [resultDict setValue:value forKey:propertyName];
                }else if([value isKindOfClass:[NSString class]]){
                    [resultDict setValue:value forKey:propertyName];
                }else if([value isKindOfClass:[NSNumber class]]){
                    [resultDict setValue:value forKey:propertyName];
                }else if([value isKindOfClass:[NSDictionary class]]){
                    [resultDict setValue:value forKey:propertyName];
                }else{
                    NSDictionary * dic = [value _LK2Dict];
                    [resultDict setValue:dic forKey:propertyName];
                }
                
            }
            
        }
        return resultDict;
    }
    return nil;
}


@end

@implementation  NSDictionary(LKExt)

-(id)_Lk2Object:(Class)clazz{
    if ([clazz isSubclassOfClass:[NSString class]]) {
        return nil;
    }
    if ([clazz isSubclassOfClass:[NSDate class]]) {
        return nil;
    }
    if ([clazz isSubclassOfClass:[NSData class]]) {
        return nil;
    }
    id objectInstance = [[clazz alloc]init];
    NSDictionary *nameDict = [LKExt_NSObject _LKPropertyNameDic:clazz];
    NSDictionary *typeDict =[LKExt_NSObject _LKPropertyTypeDic:clazz];
    NSDictionary *classMap = nil;
    if([clazz respondsToSelector:@selector(_arrayPropertyClassMaps)]){
        classMap = [clazz performSelector:@selector(_arrayPropertyClassMaps)];
    }
    NSArray *allKeys = [nameDict allKeys];
    for (NSString *key in allKeys) {
        NSString *propertyName = [nameDict objectForKey:key];
        id value = [self objectForKey:propertyName];
        NSString *type = [typeDict objectForKey:key];
        if ([value isKindOfClass:[NSArray class]] && [LKExt_NSObject typeIsArray:type]) {
            Class entityClass = nil;
            NSMutableArray *result = [[NSMutableArray alloc]init];
            NSString *className = nil;
            if([clazz respondsToSelector:@selector(_arrayPropertyClassMaps)]){
                NSDictionary *arrayPropertyClassMap  = [clazz performSelector:@selector(_arrayPropertyClassMaps)];
                if(arrayPropertyClassMap){
                    classMap = arrayPropertyClassMap;
                }
            }
            if (classMap) {
                className = [classMap objectForKey:key];
                if (className) {
                    entityClass = NSClassFromString(className);
                }
            }else{
                NSString *selectorName = [NSString stringWithFormat:@"__%@Class",key];
                if([clazz respondsToSelector:NSSelectorFromString(selectorName)]){
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                   entityClass = [clazz performSelector:NSSelectorFromString(selectorName)];
                #pragma clang diagnostic pop
                }
            }
            if (entityClass) {
                NSArray *array = (NSArray *)value;
                for (id obj in array) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *tempDict = obj;
                        id entity = [tempDict _Lk2Object:entityClass];
                        [result addObject:entity];
                    }
                }
                value = result;
            }
            if (value) {
                id result = [LKExt_NSObject objectFromValue:value asType:type];
                [objectInstance setValue:result forKey:key];
            }
        }else{
            id result = [LKExt_NSObject objectFromValue:value asType:type];
            if (result) {
                [objectInstance setValue:result forKey:key];
            }
            
        }
    }
    return objectInstance;
}



//{
//    if (self) {
//        NSDictionary * nameDict = [LKExt_NSObject _LKPropertyNameDic:clazz];
//        NSArray *allkey = nameDict.allKeys;
//        NSDictionary *classMap = nil;
//        if ([clazz respondsToSelector:@selector(_arrayPropertyClassMaps)])
//            classMap = [clazz performSelector:@selector(_arrayPropertyClassMaps)];
//        }
//        NSDictionary * typeDict = [LKExt_NSObject _LKPropertyTypeDic:clazz];
//    }
//    return nil;
//}

@end

@implementation  NSDate(LKExt)

-(NSDate *)_Lk2localDate{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: self];
    
    NSDate *localeDate = [self  dateByAddingTimeInterval: interval];
    return localeDate;
}

-(NSDate *)_Lk2GMTDate{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: self];
    NSDate *GMTDate = [self  dateByAddingTimeInterval: -interval];
    return GMTDate;
}

-(NSString *)_LKStringFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

+(NSDate *)_LKDateFromString:(NSString *)string withFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:string];
}

@end