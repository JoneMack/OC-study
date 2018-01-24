//
//  PaintView.m
//  RuntimeTest
//
//  Created by xubojoy on 2018/1/22.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import "PaintView.h"

@implementation PaintView

- (void)drawRect:(CGRect)rect
{
//    [self.curImage drawAtPoint:CGPointMake(0, 0)];
//    CGPoint mid1 = midPoint1(self.previousPoint1, self.previousPoint2);
//    CGPoint mid2 = midPoint1(self.currentPoint, self.previousPoint1);
//
//    self.context = UIGraphicsGetCurrentContext();
//    [self.layer renderInContext:self.context];
//    CGContextMoveToPoint(self.context, mid1.x, mid1.y);
//    // 添加画点
//    CGContextAddQuadCurveToPoint(self.context, self.previousPoint1.x,   self.previousPoint1.y, mid2.x, mid2.y);
//    // 设置圆角
//    CGContextSetLineCap(self.context, kCGLineCapRound);
//    // 设置线宽
//    CGContextSetLineWidth(self.context, self.isErase? kEraseLineWidth:kLineWidth);
//    // 设置画笔颜色
//    CGContextSetStrokeColorWithColor(self.context, self.isErase?[UIColor   clearColor].CGColor:self.lineColor.CGColor);
//    CGContextSetLineJoin(self.context, kCGLineJoinRound);
//    // 根据是否是橡皮擦设置设置画笔模式
//    CGContextSetBlendMode(self.context, self.isErase ?   kCGBlendModeDestinationIn:kCGBlendModeNormal);
//    CGContextStrokePath(self.context);
//    [super drawRect:rect];
}
@end
