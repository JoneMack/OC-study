//
//  MMTransitionAnimator.m
//  mobmarketing
//
//  Created by 郭煜 on 13-12-16.
//  Copyright (c) 2013年 Yu Guo. All rights reserved.
//

#import "MMTransitionAnimator.h"
#import "MMNavigationController.h"

@implementation MMTransitionAnimator

- (void)setPresentedSize:(CGSize)presentedSize {
    _presentedSize = presentedSize;
    
    float verison = [[[UIDevice currentDevice]systemVersion]floatValue];
    NSLog(@"version:%f", verison);
    if (verison < 8.0) {
        CGFloat value = _presentedSize.width;
        _presentedSize.width = _presentedSize.height;
        _presentedSize.height = value;
    }
}

- (CGRect)rectForDismissedState:(id<UIViewControllerContextTransitioning>)transitionContext
                forPresentation:(BOOL)isPresentation {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = nil;
    
    if (isPresentation) {
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    } else {
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    
    CGRect bounds = containerView.bounds;
    CGRect frame = CGRectZero;
    frame.size = self.presentedSize;
    frame.origin = CGPointMake((bounds.size.width - frame.size.width) / 2, (bounds.size.height - frame.size.height) / 2);

    return frame;
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.45;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.presenting) {
        
        MMNavigationController *navigationController = (MMNavigationController*)fromViewController;
        navigationController.view.userInteractionEnabled = NO;
        [navigationController showBlurredWithDuration:[self transitionDuration:transitionContext]];

        toViewController.view.frame = [self rectForDismissedState:transitionContext
                                                  forPresentation:self.presenting];
        toViewController.view.alpha = 0.0f;
        toViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:toViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]+0.05f animations:^{
            toViewController.view.alpha = 1.0f;
        }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                             toViewController.view.userInteractionEnabled = YES;
        }];
    }
    else {
        toViewController.view.userInteractionEnabled = YES;
        MMNavigationController *navigationController = (MMNavigationController*)toViewController;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        
        [navigationController hideBlurredWithDuration:[self transitionDuration:transitionContext]];
        
        fromViewController.view.userInteractionEnabled = NO;
        [UIView animateWithDuration:[self transitionDuration:transitionContext]+0.05f animations:^{
            fromViewController.view.alpha = 0.0f;
        }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                             fromViewController.view.userInteractionEnabled = YES;
        }];
    }
}

@end
