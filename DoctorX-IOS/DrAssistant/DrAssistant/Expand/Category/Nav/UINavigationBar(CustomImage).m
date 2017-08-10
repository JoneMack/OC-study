//
//  UINavigationBar(CustomImage).m
//  ESD
//
//  Created by hhx on 14-4-3.
//  Copyright (c) 2014年 zac. All rights reserved.
//

#import "UINavigationBar(CustomImage).h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationBar (CustomImage) 

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
     UIColor *nor_color = COLOR(0, 174, 191, 1.0);
    [self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], NSForegroundColorAttributeName,
                                      [UIFont systemFontOfSize:17.0], NSFontAttributeName,
                                      nil]];
    
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]
        || [self respondsToSelector:@selector(setBackgroundImage:forBarPosition:barMetrics:)])
    {
        [self setBarTintColor:nor_color];
    }
    else
    {
        [self setTintColor:nor_color];
    }
}

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    UIImage *image = [UIImage imageNamed: @"navcontrollerBar.png"]; 
//    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//}

@end
