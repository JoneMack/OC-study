//
//  UserLoginViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/15.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserLoginViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITextField *mobileNo;

@property (strong, nonatomic) IBOutlet UITextField *pwd;


@property (strong, nonatomic) IBOutlet UIButton *login;

@property (strong, nonatomic) IBOutlet UIButton *closeLogin;

@property (strong, nonatomic) IBOutlet UIButton *sendCheckCode;

@property (strong, nonatomic) NSTimer *countTimer;

@property (nonatomic , assign) int leftCount;

@property int accountSessionFrom;

- (IBAction)userLogin:(id)sender;






- (IBAction)sendCheckCode:(id)sender;
- (IBAction)popView:(id)sender;



@end
