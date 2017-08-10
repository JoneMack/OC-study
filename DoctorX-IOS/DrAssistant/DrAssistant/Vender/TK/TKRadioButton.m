//
//  TKRadioButton.m
//  TouchToolKit
//
//  Created by 郭煜 on 13-7-23.
//  Copyright (c) 2013年 郭煜. All rights reserved.
//

#import "TKRadioButton.h"
#import "UIImage+TKHelper.h"

@interface TKRadioButton()

@end

@implementation TKRadioButton

- (void)dealloc {
#if !__has_feature(objc_arc)
    [_checkedImage release];
    [_uncheckedImage release];
    [_checkedImageNamed release];
    [_uncheckedImageNamed release];
    
    [super dealloc];
#endif
}

//- (id)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self performSelector:@selector(sharedInit) withObject:nil afterDelay:0.0f];
//    }
//    return self;
//}

- (void)awakeFromNib {
    [self sharedInit];
}

- (void)sharedInit {
    if (nil == self.uncheckedImage) {
        if (self.uncheckedImageNamed) {
            self.uncheckedImage = [UIImage imageNamed:_uncheckedImageNamed];
        }
    }
    
    if (nil == self.checkedImage) {
        if (self.checkedImageNamed) {
            self.checkedImage = [UIImage imageNamed:_checkedImageNamed];
        }
    }
    if (nil == self.checkedImage && nil != self.uncheckedImage) {
        self.checkedImage = [self.uncheckedImage tintedImageWithColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    }
    
    [self addTarget:self action:@selector(onSelfTouched:) forControlEvents:UIControlEventTouchUpInside];

    [self setChecking:_checking];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setChecking:(BOOL)checking {
    _checking = checking;
    
    if (_checking) {
        if (self.doesApplyToBackground) {
            [self setBackgroundImage:self.checkedImage forState:UIControlStateNormal];
            [self setBackgroundImage:self.checkedImage forState:UIControlStateHighlighted];
        }
        else {
            [self setImage:self.checkedImage forState:UIControlStateNormal];
            [self setImage:self.checkedImage forState:UIControlStateHighlighted];
        }
        if (self.checkedFont) {
            self.titleLabel.font = self.checkedFont;
        }
        if (self.checkedTitleColor) {
            [self setTitleColor:self.checkedTitleColor forState:UIControlStateNormal];
            [self setTitleColor:self.checkedTitleColor forState:UIControlStateHighlighted];
        }
        
        NSSet *allTargets = [self allTargets];
        for(id target in allTargets) {
            NSArray *actions = [self actionsForTarget:target forControlEvent:UIControlEventValueChanged];
            for (NSString *selString in actions) {
                SEL actSelector = NSSelectorFromString(selString);
                NSMethodSignature *actSignature = [target methodSignatureForSelector:actSelector];
                if (actSignature) {
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:actSignature];
                    if ([actSignature numberOfArguments] == 2) {
                        [invocation setSelector:actSelector];
                        [invocation setTarget:target];
                        [invocation invoke];
                    }
                    else if ([actSignature numberOfArguments] == 3) {
                        [invocation setSelector:actSelector];
                        [invocation setTarget:target];
                        
                        __unsafe_unretained NSObject *obj = self;
                        [invocation setArgument:&obj atIndex:2];
                        [invocation invoke];
                    }
                }
            }
        }
        
        for (TKRadioButton *radioButton = self.siblingRadioButton;
             radioButton && radioButton != self;
             radioButton = radioButton.siblingRadioButton)
        {
            [radioButton setChecking:NO];
        }
    }
    else {
        if (self.doesApplyToBackground) {
            [self setBackgroundImage:self.uncheckedImage forState:UIControlStateNormal];
            [self setBackgroundImage:self.uncheckedImage forState:UIControlStateHighlighted];
        }
        else {
            [self setImage:self.uncheckedImage forState:UIControlStateNormal];
            [self setImage:self.uncheckedImage forState:UIControlStateHighlighted];
        }
        if (self.uncheckedFont) {
            self.titleLabel.font = self.uncheckedFont;
        }
        if (self.uncheckedTitleColor) {
            [self setTitleColor:self.uncheckedTitleColor forState:UIControlStateNormal];
            [self setTitleColor:self.uncheckedTitleColor forState:UIControlStateHighlighted];
        }
    }
}

- (IBAction)onSelfTouched:(id)sender
{
    if (!_checking) [self setChecking:YES];
}

@end
