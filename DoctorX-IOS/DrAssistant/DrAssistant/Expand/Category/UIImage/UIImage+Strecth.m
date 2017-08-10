//
//  UIImage+Strecth.m
//  DrAssistant
//
//  Created by hi on 15/8/29.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "UIImage+Strecth.h"

@implementation UIImage (Strecth)

+(UIImage *)imageNamed:(NSString *)name left:(NSInteger)left top:(NSInteger)top
{
    UIImage *image = [UIImage imageNamed:name];
    image = [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
    return image;
}

@end
