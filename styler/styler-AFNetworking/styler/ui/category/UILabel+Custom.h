//
//  UILabel+Custom.h
//  styler
//
//  Created by wangwanggy820 on 14-6-28.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Custom)

-(void)setParagrahStyle:(NSDictionary *)contentDict titleColor:(UIColor *)titleColor contentColor:(UIColor *)contentColor;

-(float) realWidth;
@end
