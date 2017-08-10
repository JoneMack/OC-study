//
//  CustomAlertView.m
//  styler
//
//  Created by wangwanggy820 on 14-8-29.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

- (id)initWithFrame:(CGRect)frame titleText:(NSString *)titleText contentText:(NSString *)contentText
{
    self = [super initWithFrame:frame];
    if (self) {
        bg = [[UIView alloc] initWithFrame:frame];
        bg.backgroundColor = UIColor.grayColor;
        bg.alpha = 0.5;
        
        // Create a mask layer and the frame to determine what will be visible in the view.
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        CGRect maskRect = frame;
        
        // Create a path and add the rectangle in it.
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, nil, maskRect);
        
        // Set the path to the mask layer.
        [maskLayer setPath:path];
        
        // Release the path since it's not covered by ARC.
        CGPathRelease(path);
        
        // Set the mask of the view.
        bg.layer.mask = maskLayer;
        [self addSubview:bg];
        
        preView = [[UIView alloc] initWithFrame:CGRectMake(25, 160, 270, 170)];
        preView.backgroundColor = [UIColor whiteColor];
        preView.layer.cornerRadius = 5.0;
        [self addSubview:preView];
        
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(20, 40, 230, splite_line_height);
        line.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        [preView addSubview:line];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.frame =CGRectMake(0, 0, 270, 40);
        titleLab.text = titleText;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = [ColorUtils colorWithHexString:black_text_color];
        titleLab.font = [UIFont systemFontOfSize:big_font_size];
        [preView addSubview:titleLab];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(230, 0, 40, 40);
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:@"点击" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [preView addSubview:btn];
        
        UILabel *contentLab = [[UILabel alloc] init];
        contentLab.frame =CGRectMake(20, 40, 230, 130);
        contentLab.text = contentText;
        contentLab.font = [UIFont systemFontOfSize:default_font_size];
        contentLab.textColor = [ColorUtils colorWithHexString:gray_text_color];
        contentLab.textAlignment = NSTextAlignmentLeft;
        contentLab.numberOfLines = 0;
        
        //        设置content的行间距
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:contentLab.text];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:10];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [contentLab.text length])];
        [contentLab setAttributedText:attributedString1];
        [contentLab sizeThatFits:CGSizeMake(230, 130)];
        
        [preView addSubview:contentLab];
  
        
        
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
