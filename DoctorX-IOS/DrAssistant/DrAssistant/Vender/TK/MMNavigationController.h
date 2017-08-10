//
//  MMNavigationController
//
//  Created by Yu Guo on 12-9-5.
//  Copyright (c) 2012年 __MyCompany__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMNavigationController : UINavigationController


@property (nonatomic, copy) NSString *animationType;//@"rippleEffect"
@property (nonatomic, assign) CFTimeInterval animationDuration;

- (void)rotateViewControllerInterfaceOrientation:(UIInterfaceOrientation) toOrientation;

-(void) showBlurredWithDuration:(NSTimeInterval)duration;
- (void) hideBlurredWithDuration:(NSTimeInterval)duration;

@end
