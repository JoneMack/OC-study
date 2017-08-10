//
//  ViewController.h
//  DrAssistant
//
//  Created by hi on 15/8/27.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTBViewController.h"
#import "UINavigationController+Extension.h"


@interface BaseViewController : UIViewController
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIBarButtonItem *backItem;


#pragma show msg

+ (id)simpleInstance ;

- (void)showWithStatus: (NSString *)string;
- (void)dismissToast;

- (void)showString:(NSString *)msg;
- (void)showSuccessToast:(NSString *)msg;
- (void)showErrorToast:(NSString *)msg;
- (void)showSuccessAlert:(NSString*)errorMessage;
- (void)showErrorAlert:(NSString*)errorMessage;
- (void)hideLeftBtn;
- (void)addLeftBtnAction;
- (void)saveButtonAction;
- (void) addRightBtnAction;
@end

