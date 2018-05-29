//
//  Student.m
//  
//
//  Created by xubojoy on 2018/3/8.
//

#import "Student.h"

@implementation Student
- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"=========%@", NSStringFromClass([self class]));
        NSLog(@"=========%@", NSStringFromClass([self.superclass class]));
    }
    return self;
}
@end
