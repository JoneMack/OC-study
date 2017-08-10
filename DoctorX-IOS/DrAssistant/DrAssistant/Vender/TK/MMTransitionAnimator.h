//
//  MMTransitionAnimator.h
//  mobmarketing
//
//  Created by 郭煜 on 13-12-16.
//  Copyright (c) 2013年 Yu Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL presenting;
@property (nonatomic, assign) CGSize presentedSize;

@end
