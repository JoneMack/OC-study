//
//  TKRadioButton.h
//  TouchToolKit
//
//  Created by 郭煜 on 13-7-23.
//  Copyright (c) 2013年 郭煜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKRadioButton : UIButton

@property (nonatomic, copy) NSString *uncheckedImageNamed;
@property (nonatomic, copy) NSString *checkedImageNamed;
@property (nonatomic, strong)UIImage *uncheckedImage;
@property (nonatomic, strong)UIImage *checkedImage;
@property (nonatomic, strong)UIFont *uncheckedFont;
@property (nonatomic, strong)UIFont *checkedFont;
@property (nonatomic, strong)UIColor *checkedTitleColor;
@property (nonatomic, strong)UIColor *uncheckedTitleColor;

@property (nonatomic, weak) IBOutlet TKRadioButton *siblingRadioButton;
@property (nonatomic, assign, getter = isChecking) BOOL checking;
@property (nonatomic, assign, getter = doesApplyToBackground) BOOL applyToBackground;
@property (nonatomic, strong) id userData;

- (void)sharedInit;

@end
