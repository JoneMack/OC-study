//
//  TKTextFieldAutolocateController.m
//  TouchToolkit
//
//  Created by Yu Guo on 12-11-26.
//  Copyright (c) 2012年 __MyCompany__. All rights reserved.
//

#import "TKTextFieldAutolocateController.h"
#import "TKHelper.h"
#import "UIView+TKHelper.h"
#import "UIScrollView+TKHelper.h"

#define kScrollViewScrollDur    0.25f

#define SWAP_2VARS(x,y,aTYPE) \
do {\
    aTYPE __temp = x;x = y;y = __temp;\
}while(0)

static void * kKeyboardControllerKeyValueObservingContext = &kKeyboardControllerKeyValueObservingContext;

typedef void (^AnimationCompletionBlock)(BOOL finished);

@implementation TKTextFieldAutolocateController {
    
    //当containerView.superview是UIScrollView的时候使用
    CGPoint originalOffset_;
    //当containerView.superview不是UIScrollView的时候使用
    CGRect originalRect_;
}

- (void)dealloc {
    [self unregisterForNotifications];
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)init {
    return [self initWithContainerView:nil];
}

- (id)initWithContainerView:(UIView*)containerView {
    if((self = [super init])) {
        self.containerView = containerView;
//        if ([self.containerView isKindOfClass:[UIScrollView class]]) {
//            UIScrollView *scrollView = (UIScrollView *)(self.containerView);
//            originalOffset_ = scrollView.contentOffset;
//        }
//        else if ([self.containerView.superview isKindOfClass:[UIScrollView class]]) {
//            UIScrollView *scrollView = (UIScrollView *)(self.containerView.superview);
//            originalOffset_ = scrollView.contentOffset;
//        }
//        else {
//            originalRect_ = self.containerView.frame;
//            NSLog(@"originalRect_:%@", NSStringFromCGRect(originalRect_));
//        }
        originalRect_ = self.containerView.frame;
               

//        NSLog(@"originalRect_:%@", NSStringFromCGRect(originalRect_));
    }
    return self;
}

- (void) reset {
    if (self.containerView) {
        [self.containerView endEditing:YES];
    }
}

- (void)unregisterForNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setContainerView:(UIView *)containerView {
    if (_containerView == containerView) {
        return;
    }
    
    [self unregisterForNotifications];
    
    if (_containerView) {
        [_containerView endEditing:YES];
        _containerView = nil;
    }
    
    if (containerView) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveKeyboardDidShowNotification:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveKeyboardWillChangeFrameNotification:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveKeyboardDidChangeFrameNotification:)
                                                     name:UIKeyboardDidChangeFrameNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveKeyboardWillHideNotification:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    _containerView = containerView;
}

- (void)didReceiveKeyboardDidShowNotification:(NSNotification*)notification {
    [self handleKeyboardNotification:notification completion:nil];
}

- (void)didReceiveKeyboardWillChangeFrameNotification:(NSNotification *)notification {
    [self handleKeyboardNotification:notification completion:nil];
}

- (void)didReceiveKeyboardDidChangeFrameNotification:(NSNotification *)notification {
    [self setKeyboardViewHidden:NO];
    
    [self handleKeyboardNotification:notification completion:nil];
}

- (void)didReceiveKeyboardWillHideNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSInteger animationCurveOption = (animationCurve << 16);
    double animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    

    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationCurveOption
                     animations:^{
                         self.containerView.frame = originalRect_;
                     }
                     completion:^(BOOL finished) {
//                         if (completion) {
//                             completion(finished);
//                         }
                     }];
}

- (void)handleKeyboardNotification:(NSNotification *)notification completion:(AnimationCompletionBlock)completion {
    NSDictionary *userInfo = [notification userInfo];
    
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSLog(@"keyboardEndFrame:%@", NSStringFromCGRect(keyboardEndFrame));
    
    if (CGRectIsNull(keyboardEndFrame)) {
        return;
    }
    
    UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSInteger animationCurveOption = (animationCurve << 16);
    double animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIView *firstView = [self firstViewOnRootWindow];
    
    CGRect keyboardEndFrameConverted = [firstView convertRect:keyboardEndFrame fromView:nil];
//    NSLog(@"keyboardEndFrameConverted:%@", NSStringFromCGRect(keyboardEndFrameConverted));
    
    
    
    __block UIView *targetTextField = nil;
    NSArray *textFields  = [self.containerView subviewsOfClassType:[UITextField class] orOtherClassType:[UITextView class]];
    [textFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *textField = (UIView*)obj;
        if (textField.isFirstResponder) {
            *stop = TRUE;
            targetTextField = textField;
        }
    }];
    
    
    CGRect rectInFirstView = [targetTextField convertRect:targetTextField.bounds toView:firstView];
    
//    NSLog(@"rectInFirstView:%@", NSStringFromCGRect(rectInFirstView));
    
    CGFloat distance = rectInFirstView.origin.y + rectInFirstView.size.height - keyboardEndFrameConverted.origin.y;
    
    if (distance > 0 ) {
        if ([self.containerView isKindOfClass:[UIScrollView class]]) {
        }
        else if ([self.containerView.superview isKindOfClass:[UIScrollView class]]) {
        }
        else {
            CGRect containerRect = self.containerView.frame;
            containerRect = [self.containerView.superview convertRect:containerRect toView:firstView];
            containerRect.origin.y -= distance;
            containerRect = [firstView convertRect:containerRect toView:self.containerView.superview];
            [UIView animateWithDuration:animationDuration
                                  delay:0.0
                                options:animationCurveOption
                             animations:^{
                                 self.containerView.frame = containerRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion(finished);
                                 }
                             }];
        }
    }
}

- (void)setKeyboardViewHidden:(BOOL)hidden {
//    self.keyboardView.hidden = hidden;
//    self.keyboardView.userInteractionEnabled = !hidden;
}


- (UIView *)firstViewOnRootWindow {
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    return window.rootViewController.view;
}

@end
