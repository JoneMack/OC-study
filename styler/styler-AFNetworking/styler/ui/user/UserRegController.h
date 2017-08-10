//
//  UserRegController.h
//  styler
//
//  Created by System Administrator on 13-5-14.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//
#define view_offset_for_input 20

#import <UIKit/UIKit.h>
#import "HeaderView.h"

@interface UserRegController : UIViewController<UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *userInfoWrapper;
@property (nonatomic, weak) IBOutlet UITextField *nameIn;
@property (nonatomic, weak) IBOutlet UITextField *mobileIn;
@property (weak, nonatomic) IBOutlet UIImageView *regInfoBGView;

//注册
@property (nonatomic, weak) IBOutlet UIButton *submitBut;
//注释下边的解释
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIButton *promptBtn;

//////////底部设置
@property (weak, nonatomic) IBOutlet UIButton *sinaLog;
@property (weak, nonatomic) IBOutlet UIImageView *socialLogBgView;
@property (weak, nonatomic) IBOutlet UIView *socialLogView;
@property (strong, nonatomic) UIImage * avatarImage;
//底部文字
@property (weak, nonatomic) IBOutlet UILabel *regLable;
@property (weak, nonatomic) IBOutlet UILabel *weoboLable;
@property(strong, nonatomic) HeaderView *header;
@property int accountSessionFrom;
@property BOOL stayup;

- (IBAction)regSubmit:(id)sender;

-(id)initWithFrom:(int)from;

@end
