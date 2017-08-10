//
//  SetPwdController.h
//  styler
//
//  Created by System Administrator on 13-5-22.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SetPwdController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveBut;
@property (weak, nonatomic) IBOutlet UITextField *oldPwdIn;
@property (weak, nonatomic) IBOutlet UITextField *pwdIn;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdIn;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;
@property (weak, nonatomic) IBOutlet UIView *line4;
@property (weak, nonatomic) IBOutlet UIView *changePwdView;



- (IBAction)savePwd:(id)sender;

@end
