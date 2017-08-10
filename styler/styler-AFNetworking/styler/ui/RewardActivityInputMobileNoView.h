//
//  InputTelNoReceiveRewardView.h
//  styler
//
//  Created by wangwanggy820 on 14-9-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAction.h"

@interface RewardActivityInputMobileNoView : UIView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *rewardBgView;

@property (weak, nonatomic) IBOutlet UIButton *rewardCloseBtn;

@property (weak, nonatomic) IBOutlet UILabel *rewardContentLab;

@property (weak, nonatomic) IBOutlet UITextField *telNoTextField;

@property (weak, nonatomic) IBOutlet UIButton *rewardReceiveBtn;

-(id)initWithTitle:(NSString *)title userAction:(UserAction *)userAction withAmount:(int)amount;

- (IBAction)closeBtnClick:(id)sender;

- (IBAction)obtainRedEnvelope:(id)sender;


@end
