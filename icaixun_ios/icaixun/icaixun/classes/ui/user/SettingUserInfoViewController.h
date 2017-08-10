//
//  SettingUserInfoViewController.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/10.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingUserInfoViewController : UIViewController <UITextFieldDelegate , UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>


@property (nonatomic , strong) HeaderView *headerView;

@property (strong, nonatomic) IBOutlet UIView *bodyView;

@property (strong, nonatomic) IBOutlet UIView *contentBlockView;

@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;


@property (strong, nonatomic) IBOutlet UITextField *userNameField;

@property (strong, nonatomic) IBOutlet UIImageView *boyRadio;

@property (strong, nonatomic) IBOutlet UIImageView *girlRadio;

@property (strong, nonatomic) IBOutlet UIButton *saveBtn;

- (IBAction)saveUserInfo:(id)sender;


@end
