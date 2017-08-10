//
//  MyAccoutController.h
//  DrAssistant
//
//  Created by 刘亮 on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
// 个人主页

#import <UIKit/UIKit.h>

@protocol AccountbuttonAction <NSObject>

- (void)editButtonAction;

- (void)myNewsButtonAction;

- (void)shareButtonAction;

- (void)settingButtionAction;
- (void)tongjiButtonAction;
- (void)QRCodeButtonAction;

@end

@interface MyAccoutController : UIView

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImg;
@property (weak, nonatomic) IBOutlet UIImageView *renZhengImage;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UIView *tojingJiView;
@property (weak, nonatomic) IBOutlet UILabel *renZhengLab;
@property (nonatomic,assign) id<AccountbuttonAction> delegete;
- (IBAction)tongjiButtonAction:(id)sender;

@end
