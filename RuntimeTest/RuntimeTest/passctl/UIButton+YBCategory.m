//
//  UIButton+YBCategory.m
//  RuntimeTest
//
//  Created by xubojoy on 2018/3/23.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import "UIButton+YBCategory.h"
#import "UIImage+YBBundleImage.h"
#import "UIColor+Expanded.h"
@implementation UIButton (YBCategory)
#pragma mark 按钮不可用
-(void)noUseButton{
    self.userInteractionEnabled = NO;
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"e3e6e9"]] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithHexString:@"c4c9cd"] forState:UIControlStateNormal];
}
#pragma mark 按钮可用
-(void)canUseButton{
    self.userInteractionEnabled = YES;
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"fd4155"]] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"e63c4d"]] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark 设置圆角
-(void)setButtonCorner{
    self.layer.cornerRadius = 3.0f;
    self.layer.masksToBounds = YES;
}



@end
