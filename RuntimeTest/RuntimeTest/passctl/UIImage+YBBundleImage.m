//
//  UIImage+YBBundleImage.m
//  RuntimeTest
//
//  Created by xubojoy on 2018/3/23.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import "UIImage+YBBundleImage.h"

@implementation UIImage (YBBundleImage)
+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
