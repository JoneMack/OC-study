//
//  HelloClass.m
//  RuntimeTest
//
//  Created by xubojoy on 2018/3/13.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import "HelloClass.h"
#import <objc/runtime.h>
#import "RuntimeMethodHelper.h"


void functionForMethod(id self, SEL _cmd){
    NSLog(@"hello");
}

Class functionForClassMethod(id self, SEL _cmd){
    NSLog(@"hi");
    return [HelloClass class];
}

@interface HelloClass()

{
    
    RuntimeMethodHelper *_helper;
    
}

@end

@implementation HelloClass

- (instancetype)init{
    self = [super init];
    if (self) {
        _helper = [RuntimeMethodHelper new];
        
    }
    return self;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    NSLog(@"resolveInstanceMethod");
//    NSString *selString = NSStringFromSelector(sel);
//    if ([selString isEqualToString:@"hello"]) {
//
//    }
    
    if (sel_isEqual(sel, @selector(hello))) {
        class_addMethod(self, @selector(hello), (IMP)functionForMethod, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}



+ (BOOL)resolveClassMethod:(SEL)sel{
    NSLog(@"resolveClassMethod");
    if (sel_isEqual(sel, @selector(hi))) {
        Class metaClass = objc_getMetaClass("HelloClass");
        class_addMethod(metaClass, @selector(hi), (IMP)functionForClassMethod, "v@:");
        return YES;
    }
    return [super resolveClassMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector{
    NSLog(@"forwardingTargetForSelector");
    NSString *selectorString = NSStringFromSelector(aSelector);
    if ([selectorString isEqualToString:@"hello"]) {
        return _helper;
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end
