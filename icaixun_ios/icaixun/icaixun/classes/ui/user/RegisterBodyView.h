//
//  RegisterBodyView.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/31.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterBodyView : UIView <UITextFieldDelegate>


@property (nonatomic , strong) UINavigationController *navigationController;
@property (nonatomic , copy)   NSString *mobilePhone;
@property (nonatomic , copy)   NSString *checkCode;
@property (nonatomic , copy)   NSString *invitationCode;
@property (nonatomic , strong) User *user;

@property (strong, nonatomic) IBOutlet UIView *inputBlockView;

@property (strong, nonatomic) IBOutlet UITextField *inputMobilePhoneField;

@property (strong, nonatomic) IBOutlet UITextField *inputCheckCodeField;

@property (strong, nonatomic) IBOutlet UIButton *applyForCheckCodeBtn;

@property (strong, nonatomic) IBOutlet UITextField *invitationCodeField;

@property (strong, nonatomic) IBOutlet UIButton *nextBtn;


@property (nonatomic , strong) UIView *separatorLine;


- (IBAction)getCheckCode:(id)sender;

- (IBAction)nextStep:(id)sender;


-(instancetype) initWithNavigationController:(UINavigationController *) navigationController;

@end
