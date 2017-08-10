//
//  InputTelNoReceiveRewardView.m
//  styler
//
//  Created by wangwanggy820 on 14-9-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "RewardActivityInputMobileNoView.h"
#import "RewardActivityStore.h"
#import "UserStore.h"

#define tel_text_field_height    40
#define tel_text_field_place_holder  @"输入手机号领取红包"
#define reward_BgView_y          -40

@implementation RewardActivityInputMobileNoView
{
    UserAction *unLoadUserAction;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       
    }
    return self;
}

-(id)initWithTitle:(NSString *)title userAction:(UserAction *)userAction withAmount:(int)amount{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"RewardActivityInputMobileNoView" owner:self options:nil] objectAtIndex:0];

//        self.bounds = [UIApplication sharedApplication].keyWindow.bounds;
        self.frame = [[UIApplication sharedApplication].keyWindow frame];
        self.backgroundColor = [ColorUtils colorWithHexString:gray_text_color alpha:0.4];
        
        self.rewardBgView.center = [[UIApplication sharedApplication].keyWindow center];
        CALayer *layer  = self.rewardBgView.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:5.0];
        
        unLoadUserAction = userAction;

        self.telNoTextField.backgroundColor = [UIColor whiteColor];
        self.telNoTextField.placeholder = tel_text_field_place_holder;
        self.telNoTextField.textAlignment = NSTextAlignmentLeft;
        self.telNoTextField.delegate = self;
        self.telNoTextField.keyboardAppearance = UIKeyboardAppearanceDefault;//键盘外观
        self.telNoTextField.returnKeyType = UIReturnKeyDone;//键盘return键设置成 标有Send的蓝色按钮
        self.telNoTextField.keyboardType = UIKeyboardTypeNumberPad;//设置键盘只有数字输入法
        CGRect telFieldFrame = self.telNoTextField.frame;
        telFieldFrame.size.height = tel_text_field_height;
        self.telNoTextField.frame = telFieldFrame;
        
        self.rewardContentLab.font = [UIFont systemFontOfSize:bigger_font_size];
        self.rewardContentLab.textAlignment = NSTextAlignmentCenter;
        self.rewardContentLab.textColor = [ColorUtils colorWithHexString:white_text_color];
        self.rewardContentLab.numberOfLines = 0;
        int start = [title rangeOfString:[NSString stringWithFormat:@"%d",amount]].location;
        int length = [title rangeOfString:[NSString stringWithFormat:@"%d",amount]].length;
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:title];
        [attributedText addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:biggest_font_size]
                               range:NSMakeRange(start, length)];
        self.rewardContentLab.attributedText = attributedText;
        
        
        self.rewardReceiveBtn.backgroundColor = [ColorUtils colorWithHexString:red_select_color];
        CALayer *btnlayer  = self.rewardReceiveBtn.layer;
        [btnlayer setMasksToBounds:YES];
        [btnlayer setCornerRadius:5.0];
        self.rewardReceiveBtn.titleLabel.font = [UIFont systemFontOfSize:bigger_font_size];
        [self.rewardReceiveBtn setTitleColor:[ColorUtils colorWithHexString:white_text_color] forState:UIControlStateNormal];
        

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

- (IBAction)closeBtnClick:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.rewardBgView.frame;
        frame.origin.y = -self.rewardBgView.frame.size.height;
        self.rewardBgView.frame = frame;
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self setHidden:YES];
        [self removeFromSuperview];
        [SVProgressHUD dismiss];
    }];

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}


#pragma mark 领取红包
- (IBAction)obtainRedEnvelope:(id)sender {
    
    if(self.telNoTextField.text.length != 11){
        [SVProgressHUD showSuccessWithStatus:@"请输入正确的手机号码.." duration:1.0];
        return ;
    }
    [self endEditing:YES];
    [self unloadCustomerObtainRedEnvelope];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.rewardBgView.frame;
        frame.origin.y = -self.rewardBgView.frame.size.height;
        self.rewardBgView.frame = frame;
    } completion:^(BOOL finished) {
        NSString *content = [NSString stringWithFormat:@"手机号:%@" , self.telNoTextField.text];
        [MobClick event:log_event_name_obtain_red_envelope
             attributes:[NSDictionary dictionaryWithObjectsAndKeys:content,@"领取红包",nil]];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeFromSuperview];
        [SVProgressHUD showWithStatus:network_status_loading maskType:SVProgressHUDMaskTypeGradient];
    }];
    
}

-(void) unloadCustomerObtainRedEnvelope{
    
    [RewardActivityStore postNewCustomer:^(NSError *err) {
        if (err == nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_reward_activity_after_input_mobile_no
                                                                object:unLoadUserAction];
        }
    } mobileNo:self.telNoTextField.text actionId:unLoadUserAction.id];
}

-(void) keyboardOnScreen:(NSNotification *)notification {
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    float keyBoardHeight = rawFrame.size.height;
    float windowHeight = [UIApplication sharedApplication].keyWindow.bounds.size.height;
    float cardHeight = self.rewardBgView.bounds.size.height;
    float pushUpHeight = keyBoardHeight - (windowHeight - cardHeight)/2;
    
    if (pushUpHeight>0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.rewardBgView.frame;
            frame.origin.y = frame.origin.y- pushUpHeight;
            self.rewardBgView.frame = frame;
        }];
    }
}

-(void) keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        self.rewardBgView.center = [UIApplication sharedApplication].keyWindow.center;
    } completion:^(BOOL finished) {
        
    }];
}

-(NSString *)getPageName{
    return page_name_reward_activity_input_mobile_no;
}


@end
