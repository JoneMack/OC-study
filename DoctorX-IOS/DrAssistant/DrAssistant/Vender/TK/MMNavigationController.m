//
//  MMNavigationController.m
//  MobileMarketing
//
//  Created by 郭煜 on 13-6-6.
//  Copyright (c) 2013年 郭煜. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MMNavigationController.h"
#import "UIImage+TKHelper.h"

@interface MMNavigationController ()

//@property (nonatomic, strong) CIContext * context;
//@property (nonatomic, strong) NSMutableArray * blurredImagesArray;
//@property (nonatomic, strong) UIImageView * blurredImageView;

@property (nonatomic, strong) UIImageView * blurredImageView;

@end

@implementation MMNavigationController

- (void)dealloc {
    NSLog(@"dealloc %@", NSStringFromClass([self class]));
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!animated) {
        [super pushViewController:viewController animated:animated];
    } else {
        CATransition* transition = [CATransition animation];
        
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        if (self.animationType) {
            transition.type = self.animationType;
            transition.duration = self.animationDuration;
            self.animationType = nil;
        }
        else {
            transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
            transition.duration = 0.5;
        }
        
        
        [self.view.layer addAnimation:transition forKey:nil];
        [self pushViewController:viewController animated:NO];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *resController;
    if (!animated) {
        resController = [super popViewControllerAnimated:animated];
    } else {
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.view.layer addAnimation:transition forKey:nil];
        resController = [self popViewControllerAnimated:NO];
    }
    return resController;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *resViewControllers;
    if (!animated) {
        resViewControllers = [super popToRootViewControllerAnimated:animated];
    } else {
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.view.layer addAnimation:transition forKey:nil];
        resViewControllers = [self popToRootViewControllerAnimated:NO];
    }
    return resViewControllers;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *resViewControllers;
    if (!animated) {
        resViewControllers = [super popToViewController:viewController animated:animated];
    } else {
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.view.layer addAnimation:transition forKey:nil];
        resViewControllers = [self popToViewController:viewController animated:NO];
    }
    return resViewControllers;
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    if (!animated) {
        [super setViewControllers:viewControllers animated:animated];
    } else {
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.view.layer addAnimation:transition forKey:nil];
        [self setViewControllers:viewControllers animated:NO];
    }
}

#pragma mark - 自动转动支持
//在iOS6上，即使设置了锁定了旋转方向，也可能继续会转动，特别是套用了UINavigationController
-(BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

#pragma mark - 私有方法调用
- (void)rotateViewControllerInterfaceOrientation:(UIInterfaceOrientation) toOrientation {
    //参考
    // http://stackoverflow.com/questions/181780/is-there-a-documented-way-to-set-the-iphone-orientation
    // http://openradar.appspot.com/radar?id=697
//    [[UIDevice currentDevice] performSelector:NSSelectorFromString(@"setOrientation:")
//                                   withObject:(id)toOrientation];
}

#pragma mark - 模糊
//-(void) showBlurredWithDuration:(NSTimeInterval)duration {
//    
//    self.context = [CIContext contextWithOptions:nil];
//    
//    self.blurredImagesArray = [NSMutableArray new];
//    
//    CGRect originalRect = self.view.bounds;
//    
//    // screenshot of background image view
//    UIImage * homeViewImage = nil;
//    if ([[UIScreen mainScreen] scale] == 2.0) {
//        UIGraphicsBeginImageContextWithOptions(originalRect.size, NO, 1.0);
//    } else {
//        UIGraphicsBeginImageContext(originalRect.size);
//    }
//    CGContextRef cgContext = UIGraphicsGetCurrentContext();
//    CGContextSetInterpolationQuality(cgContext, kCGInterpolationNone);
//    [[self.view layer] renderInContext:cgContext];
//    homeViewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    CIImage * inputImage = [CIImage imageWithCGImage:homeViewImage.CGImage];
//    
//    // build an array of images at different filter levels
//    for (NSInteger index = 0; index < 5; index++){
//        CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
//        [blurFilter setDefaults];
//        [blurFilter setValue:inputImage forKey:kCIInputImageKey];
//        CGFloat blurLevel = index * 0.45f;
//        [blurFilter setValue:@(blurLevel) forKey:@"inputRadius"];
//        CIImage *outputImage = [blurFilter valueForKey:@"outputImage"];
//        CGImageRef cgImage = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
//        [self.blurredImagesArray addObject:[UIImage imageWithCGImage:cgImage]];
//        CGImageRelease(cgImage);
//    }
//    
//    UIImageView * blurView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    blurView.backgroundColor = [UIColor blackColor];
//    blurView.animationImages = self.blurredImagesArray;
//    blurView.animationDuration = duration;
//    blurView.animationRepeatCount=1;
//    blurView.image = [self.blurredImagesArray lastObject];
//    [blurView startAnimating];
//    
//    self.blurredImageView = blurView;
//    [self.view addSubview:self.blurredImageView];
//}
//
//
//- (void) hideBlurredWithDuration:(NSTimeInterval)duration {
//    
//    if (nil == self.blurredImageView) {
//        return;
//    }
//    
//    NSArray * reversedImagesArray = [[self.blurredImagesArray reverseObjectEnumerator] allObjects];
//    
//    UIImageView * blurView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    blurView.animationImages = reversedImagesArray;
//    blurView.animationDuration = duration;
//    blurView.animationRepeatCount = 1;
//    blurView.image = [reversedImagesArray lastObject];
//    [blurView startAnimating];
//    
//    [self.blurredImageView removeFromSuperview];
//    
//    self.blurredImageView = blurView;
//    [self.view addSubview:self.blurredImageView];
//    
//    double delayInSeconds = duration + 0.1f;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self.blurredImageView removeFromSuperview];
//    });
//}

-(void) showBlurredWithDuration:(NSTimeInterval)duration {
    
    CGRect originalRect = self.view.bounds;
    
    // screenshot of background image view
    UIImage * homeViewImage = nil;
    if ([[UIScreen mainScreen] scale] == 2.0) {
        UIGraphicsBeginImageContextWithOptions(originalRect.size, NO, 1.0);
    } else {
        UIGraphicsBeginImageContext(originalRect.size);
    }
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(cgContext, kCGInterpolationNone);
    [[self.view layer] renderInContext:cgContext];
    homeViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *blurredImage = [homeViewImage blurryWithBlurLevel:0.1f];
    
    if (self.blurredImageView == nil) {
        self.blurredImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        self.blurredImageView.backgroundColor = [UIColor blackColor];
    }
    self.blurredImageView.image = blurredImage;
    self.blurredImageView.alpha = 0.0f;
    
    [self.view addSubview:self.blurredImageView];
    
    [UIView animateWithDuration:duration animations:^{
        self.blurredImageView.alpha = 1.0f;
    }];
}


- (void) hideBlurredWithDuration:(NSTimeInterval)duration {
    if (self.blurredImageView) {
        [UIView animateWithDuration:duration animations:^{
            self.blurredImageView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.blurredImageView removeFromSuperview];
        }];
    }
}




@end
