//
//  PerfectInfoViewController.h
//  DrAssistant
//
//  Created by 刘亮 on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
// 完善个人信息

#import "BaseViewController.h"
#import "MMRadioButton.h"
#import "UIView+LJWKeyboardHandlerAddtion.h"
@interface PerfectInfoViewController : BaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;

@property (weak, nonatomic) IBOutlet UITextField *name;

@property (weak, nonatomic) IBOutlet MMRadioButton *womenBtn;
@property (weak, nonatomic) IBOutlet MMRadioButton *manBtn;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *numberID;
@property (weak, nonatomic) IBOutlet UITextField *telePhone;
@property (weak, nonatomic) IBOutlet UITextField *nativePlace;
@property (weak, nonatomic) IBOutlet MMRadioButton *marriedBtn;
@property (weak, nonatomic) IBOutlet MMRadioButton *sigleDogBtn;

@end
