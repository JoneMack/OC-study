//
//  SDInputAutoRepositionController.h
//  SDLibrary
//
//  Created by Yu Guo on 12-11-26.
//  Copyright (c) 2012年 __MyCompany__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKTextFieldAutolocateController : NSObject

@property (nonatomic, weak) UIView *containerView;

- (id)initWithContainerView:(UIView*)containerView;
- (void)reset;

@end
