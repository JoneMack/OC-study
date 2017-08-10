//
//  CustomAnnotationView.m
//  lbsdemo
//
//  Created by xubojoy on 16/6/14.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import "CustomAnnotationView.h"
#import <QuartzCore/QuartzCore.h>
@implementation CustomAnnotationView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor=[ColorUtils colorWithHexString:bg_purple];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:22];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.layer.cornerRadius = 10;
        self.titleLabel.layer.masksToBounds = YES;
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:22]};
        self.titleLabel.text = title;
        CGSize retSize = [title boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 0)
                                                        options:
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                                     attributes:attribute
                                                        context:nil].size;
        self.titleLabel.frame = CGRectMake(0, 0, retSize.width+20, 50);
        [self addSubview:self.titleLabel];
        
    }
    return self;
}

#pragma mark -
#pragma mark draw

- (void)getDrawPath:(CGContextRef)context rect:(CGRect)rect
{
    CGRect rrect = rect;
    CGFloat radius = 10.0;

    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-Arror_height;

    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);

}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    
    CGContextSetFillColorWithColor(context, [ColorUtils colorWithHexString:bg_purple].CGColor);
    [self getDrawPath:context rect:self.bounds];
    CGContextFillPath(context);
    
    CGPathRef path = CGContextCopyPath(context);
    
    self.layer.shadowColor = [UIColor clearColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 1;
    
    //insert
    self.layer.shadowPath = path;
    
}


@end
