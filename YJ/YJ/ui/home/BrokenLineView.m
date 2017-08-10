//
//  BrokenLineView.m
//  YJ
//
//  Created by xubojoy on 2017/7/12.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import "BrokenLineView.h"
#define pi 3.14159265359
#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)
@implementation BrokenLineView

- (void)drawRect:(CGRect)rect {
    UIColor *color = [UIColor redColor];
    [color set];//设置线条颜色
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100)
                                                         radius:75
                                                     startAngle:DEGREES_TO_RADIANS(180)
                                                       endAngle:0
                                                      clockwise:YES];
    aPath.lineWidth = .5;
    aPath.lineCapStyle = kCGLineCapRound;//线条拐角
    aPath.lineJoinStyle = kCGLineCapRound;//终点处理
    [aPath stroke];
}

@end
