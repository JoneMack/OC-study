//
//  UserFirstLoginController.h
//  styler
//
//  Created by System Administrator on 13-5-16.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UserFirstLoginController : UIViewController<UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *noteTxt;
@property (weak, nonatomic) IBOutlet UIButton *submitBut;
@property (weak, nonatomic) IBOutlet UIButton *resendBut;
//用来显示按钮文字变化
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet UITextField *pwdIn;

@property int resetSecond;
@property (retain, nonatomic) NSTimer *timer;

@property int accountSessionFrom;
@property BOOL stayup;

@property BOOL isAllowSwapPop;

- (IBAction)republishInitPwd:(id)sender;
- (IBAction)submitFirstLogin:(id)sender;

-(id) initWithFrom:(int)from;
@end
