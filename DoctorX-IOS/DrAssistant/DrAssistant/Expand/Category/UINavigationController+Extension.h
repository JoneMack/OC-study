//
//  UINavigationController+Extension.h
//  drug
//
//  Created by tongqing on 15-4-20.
//  Copyright (c) 2015年 cat. All rights reserved.
//

/**
 *       使用方法：实现2个代理即可。
 *
 *
 */
#import <UIKit/UIKit.h>

@protocol UINavigationControllerShouldPop <NSObject>

/**
 *  捕捉系统返回按钮点击事件
 *
 *  @param nav 要捕捉的nav
 *
 *  @return yes为继续执行系统动作，no为不执行系统动作
 */
- (BOOL)navigationControllerShouldPop:(UINavigationController *)nav;

/**
 *  捕捉系统侧滑返回事件
 *
 *  @param nav 要捕捉的nav
 *
 *  @return yes为继续执行系统动作，no为不执行系统动作
 */
- (BOOL)navigationControllerShouldStartInteractivePopGestureRecognizer:(UINavigationController *)nav;

@end

@interface UINavigationController (Extension) <UIGestureRecognizerDelegate>

@end
