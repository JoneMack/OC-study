//
//  MovieModel.m
//  RuntimeTest
//
//  Created by xubojoy on 2017/11/29.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import "MovieModel.h"
#import <objc/runtime.h>
@implementation MovieModel
/**
 *  归档
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count;
    
    // 获得指向当前类的所有属性的指针
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        // 获取指向当前类的一个属性的指针
        objc_property_t property = properties[i];
        // 获取C字符串属性名
        const char *name = property_getName(property);
        // C字符串转OC字符串
        NSString *propertyName = [NSString stringWithUTF8String:name];
        // 通过关键词取值
        NSString *propertyValue = [self valueForKeyPath:propertyName];
        // 编码属性
        [aCoder encodeObject:propertyValue forKey:propertyName];
    }
    free(properties);
}


/**
 解档
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        unsigned int count;
        // 获得指向当前类的所有属性的指针
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i++) {
            // 获取指向当前类的一个属性的指针
            objc_property_t property = properties[i];
            // 获取C字符串的属性名
            const char *name = property_getName(property);
            // C字符串转OC字符串
            NSString *propertyName = [NSString stringWithUTF8String:name];
            // 解码属性值
            NSString *propertyValue = [aDecoder decodeObjectForKey:propertyName];
            [self setValue:propertyValue forKey:propertyName];
        }
        // 记得释放
        free(properties);
    }
    
    return self;
}


@end
