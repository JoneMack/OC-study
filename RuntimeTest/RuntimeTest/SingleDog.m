//
//  SingleDog.m
//  RuntimeTest
//
//  Created by xubojoy on 2017/11/29.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import "SingleDog.h"
#import <objc/runtime.h>
@implementation SingleDog

//+ (instancetype)zg_modelFromDic:(NSDictionary *)dataDic {
//    id model = [[self alloc] init];
//    unsigned int count = 0;
//
//    objc_property_t *properties = class_copyPropertyList([self class], &count);
//    if (count == 0) {
//        return model;
//    }
//    for (int i = 0;i < count; i++) {
//        objc_property_t property = properties[i];
//        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
//        id value = dataDic[propertyName];
//        [model setValue:value forKey:propertyName];
//    }
//    free(properties);
//    return model;
//}

+ (instancetype)zg_modelFromDic:(NSDictionary *)dataDic {
    id model = [[self alloc] init];
    unsigned int count = 0;
    
    Ivar *ivarsA = class_copyIvarList(self, &count);
    if (count == 0) {
        return model;
    }
    for (int i = 0;i < count; i++) {
        Ivar iv = ivarsA[i];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(iv)];
        ivarName = [ivarName substringFromIndex:1];
        id value = dataDic[ivarName];
        [model setValue:value forKey:ivarName];
    }
    free(ivarsA);
    return model;
}

@end
