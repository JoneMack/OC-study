//
//  Person.m
//  RuntimeTest
//
//  Created by xubojoy on 2017/11/29.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import "Plane.h"
@implementation Person
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    Method exchangeM = class_getInstanceMethod([self class], @selector(eat:));
//
//    class_addMethod([self class], sel, class_getMethodImplementation(self, @selector(eat:)),method_getTypeEncoding(exchangeM));
//
//    return YES;
//}

//- (void)eat{
//    NSLog(@"Person start eat ");
//}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature *mig = [super methodSignatureForSelector:aSelector];
    if (!mig) {
        if ([Plane instanceMethodSignatureForSelector:aSelector]) {
            mig = [Plane instanceMethodSignatureForSelector:aSelector];
        }
    }
    return mig;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    if ([Plane instanceMethodSignatureForSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:[Plane new]];
    }else{
        [super forwardInvocation:anInvocation];
    }
}





@end
