//
//  UIView+SDHelper.m
//  MinShengBankCreditCard
//
//  Created by Yu Guo on 12-9-10.
//  Copyright (c) 2012年 __MyCompnay__. All rights reserved.
//

#import "UIView+TKHelper.h"

@implementation UIView(TKHelper)

- (CGFloat)frameOriginX {
    return self.frame.origin.x;
}

- (void)setFrameOriginX:(CGFloat)originX {
    CGRect r = self.frame;
    r.origin.x = originX;
    self.frame = r;
}

- (CGFloat)frameOriginY {
    return self.frame.origin.y;
}

- (void)setFrameOriginY:(CGFloat)originY {
    CGRect r = self.frame;
    r.origin.y = originY;
    self.frame = r;
}

- (CGPoint)frameOrigin {
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)origin {
    CGRect r = self.frame;
    r.origin = origin;
    self.frame = r;
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)frameSize {
    CGRect r = self.frame;
    r.size = frameSize;
    self.frame = r;
}

- (CGFloat)frameSizeWidth {
    return self.frame.size.width;
}

- (void)setFrameSizeWidth:(CGFloat)frameSizeWidth {
    CGRect r = self.frame;
    r.size.width = frameSizeWidth;
    self.frame = r;
}

- (CGFloat)frameSizeHeight {
    return self.frame.size.height;
}

- (void)setFrameSizeHeight:(CGFloat)frameSizeHeight {
    CGRect r = self.frame;
    r.size.height = frameSizeHeight;
    self.frame = r;
}

- (NSArray*) subviewsOfClassType:(Class)viewClass orOtherClassType:(Class)viewClass1 {
//    if (nil == viewClass && nil == viewClass1) {
//        return nil;
//    }
    
    NSMutableArray *resSubviews = [NSMutableArray array];
    for (UIView *subView in [self subviews]) {
        if ([subView isKindOfClass:viewClass]) {
            [resSubviews addObject:subView];
        }
        NSArray *recurRes = [subView subviewsOfClassType:viewClass orOtherClassType:nil];
        if (recurRes) {
            [resSubviews addObjectsFromArray:recurRes];
        }
        
        if ([subView isKindOfClass:viewClass1]) {
            [resSubviews addObject:subView];
        }
        NSArray *recurRes1 = [subView subviewsOfClassType:nil orOtherClassType:viewClass1];
        if (recurRes1) {
            [resSubviews addObjectsFromArray:recurRes1];
        }
    }
    return [NSArray arrayWithArray:resSubviews];
}

- (void)resizeOnSameCenter:(CGSize)size {
    CGRect r = self.frame;
    CGPoint center = self.center;
    r.size = size;
    self.frame = r;
    self.center = center;
    
}

@end
