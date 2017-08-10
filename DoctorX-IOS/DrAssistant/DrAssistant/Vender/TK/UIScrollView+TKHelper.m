//
//  UIScrollView+TKHelper.m
//  TouchToolKit
//
//  Created by 郭煜 on 13-6-8.
//  Copyright (c) 2013年 郭煜. All rights reserved.
//

#import "UIScrollView+TKHelper.h"

@implementation UIScrollView(TKHelper)

- (void)setContentOffset:(CGPoint)contentOffset animationDuration:(NSTimeInterval)animationDuration
{
    [UIView animateWithDuration:animationDuration animations:^{
        [self setContentOffset:contentOffset];
    }];
}

@end
