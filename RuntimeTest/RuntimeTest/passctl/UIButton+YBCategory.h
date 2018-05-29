//
//  UIButton+YBCategory.h
//  RuntimeTest
//
//  Created by xubojoy on 2018/3/23.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YBCategory)
#pragma mark 按钮不可用
-(void)noUseButton;
#pragma mark 按钮可用
-(void)canUseButton;

-(void)setButtonCorner;
@end
