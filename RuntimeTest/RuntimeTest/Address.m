//
//  Address.m
//  RuntimeTest
//
//  Created by xubojoy on 2018/3/6.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import "Address.h"

@implementation Address


- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"keyPath = %@,object = %@ ,change = %@, context = %s", keyPath, object, change, (char *)context);
}

@end
