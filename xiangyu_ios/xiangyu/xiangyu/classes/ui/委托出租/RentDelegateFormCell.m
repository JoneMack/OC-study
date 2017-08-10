//
//  RentDelegateFormCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/20.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "RentDelegateFormCell.h"
#import "OwnerDepositStore.h"
#import "UserStore.h"

@implementation RentDelegateFormCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.sendCheckCode setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
    [self.sendCheckCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendCheckCode.layer.masksToBounds = YES;
    self.sendCheckCode.layer.cornerRadius = 5;
    
    [self.submitInfo setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
    [self.submitInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitInfo.layer.masksToBounds = YES;
    self.submitInfo.layer.cornerRadius = 5;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self.line1 setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    [self.line2 setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    [self.line3 setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    
    [self.quyu setTitleColor:[ColorUtils colorWithHexString:text_color_gray] forState:UIControlStateNormal];
    [self.shangquan setTitleColor:[ColorUtils colorWithHexString:text_color_gray] forState:UIControlStateNormal];
    
    AppStatus *as = [AppStatus sharedInstance];
    if([as logined]){
        [self.checkCodeLabel setHidden:YES];
        [self.checkCode setHidden:YES];
        [self.sendCheckCode setHidden:YES];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)selectQuyu:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_rent_delegate_select_quyu object:nil];
}

- (IBAction)selectShangquan:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_rent_delegate_select_shangquan object:nil];
}

- (IBAction)sendCheckCode:(id)sender {
    
    NSString *mobileNo = self.mobileNo.text;
    
    NSLog(@"》》》》    获取验证码:%@" , mobileNo);
    
    if(mobileNo.length != 11){
        [self makeToast:@"请输入正确的手机号" duration:2.0 position:[NSValue valueWithCGPoint:self.center]];
        return;
    }
    
    [[UserStore sharedStore] requestTempPwd:^(NSError *err) {
        if ( err == nil ){
            [self changeSendCheckCodeBtnStatus];
        }
    } mobileNo:mobileNo];
    
}


-(void) changeSendCheckCodeBtnStatus{
    
    [self.sendCheckCode setBackgroundColor:[ColorUtils colorWithHexString:@"cccccc"]];
    [self.sendCheckCode setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray3] forState:UIControlStateDisabled];
    [self.sendCheckCode setEnabled:NO];
    self.leftCount = 60;
    [self.sendCheckCode setTitle:[NSString stringWithFormat:@"%d秒后" , self.leftCount] forState:UIControlStateDisabled];
    
    self.countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeLeftTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
    
}


-(void) changeLeftTime
{
    if(self.leftCount == 0){
        self.leftCount = 60;
        [self.sendCheckCode setEnabled:YES];
        [self.sendCheckCode setBackgroundColor:[ColorUtils colorWithHexString:bg_yellow]];
        [self.sendCheckCode setTitle:@"获取验证码" forState:UIControlStateDisabled];
        [self.countTimer invalidate];
        self.countTimer = nil;
    }else{
        self.leftCount = self.leftCount -1;
        [self.sendCheckCode setTitle:[NSString stringWithFormat:@"%d秒后" , self.leftCount] forState:UIControlStateDisabled];
        
    }
    
}


// 提交委托出租信息
- (IBAction)submitRentDelegate:(id)sender {
    
    NSString *xiaoqumingcheng = self.xiaoQuMingCheng.text;
    if([NSStringUtils isBlank:xiaoqumingcheng]){
        [self.contentView makeToast:@"请输入小区名称" duration:2.0 position:[NSValue valueWithCGPoint:self.contentView.center]];
        return;
    }
    
    if(xiaoqumingcheng.length > 15){
        [self.contentView makeToast:@"小区名称请不要超过15个字哦" duration:2.0 position:[NSValue valueWithCGPoint:self.contentView.center]];
        return;
    }
    
    if([NSStringUtils isBlank:self.selectedChengQu]){
        [self.contentView makeToast:@"请选择区域" duration:2.0 position:[NSValue valueWithCGPoint:self.contentView.center]];
        return;
    }
    
    if([NSStringUtils isBlank:self.selectedShangQuan]){
        [self.contentView makeToast:@"请选择商圈" duration:2.0 position:[NSValue valueWithCGPoint:self.contentView.center]];
        return;
    }
    
    NSString *rentMoney = self.zujin.text;
    if(![NSStringUtils isPureInt:rentMoney] || ![NSStringUtils isPureFloat:rentMoney]){
        [self.contentView makeToast:@"请输入正确的意向租金" duration:2.0 position:[NSValue valueWithCGPoint:self.contentView.center]];
        return;
    }
    
    NSString *userName = self.userName.text;
    if([NSStringUtils isBlank:userName]){
        [self.contentView makeToast:@"请输入姓名" duration:2.0 position:[NSValue valueWithCGPoint:self.contentView.center]];
        return;
    }
    
    NSString *mobileNo = self.mobileNo.text;
    if([NSStringUtils isBlank:mobileNo]){
        [self.contentView makeToast:@"请输入联系电话" duration:2.0 position:[NSValue valueWithCGPoint:self.contentView.center]];
        return;
    }
    
    NSString *checkCode = @"";
    AppStatus *as = [AppStatus sharedInstance];
    if(![as logined]){
        checkCode = self.checkCode.text;
        if([NSStringUtils isBlank:checkCode]){
            [self.contentView makeToast:@"请输入校验码" duration:2.0 position:[NSValue valueWithCGPoint:self.contentView.center]];
            return;
        }
    }
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:xiaoqumingcheng forKey:@"village"];
    [params setObject:self.selectedChengQu forKey:@"area"];
    [params setObject:self.selectedShangQuan forKey:@"circle"];
    [params setObject:rentMoney forKey:@"hopePrice"];
    [params setObject:userName forKey:@"ownerName"];
    [params setObject:mobileNo forKey:@"contact"];
    [params setObject:checkCode forKey:@"verificationCode"];
    
    [[OwnerDepositStore sharedStore] rentDelegate:^(NSError *err) {
        if(err == nil){
            [self.contentView makeToast:@"提交成功" duration:2.0 position:[NSValue valueWithCGPoint:self.contentView.center]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            ExceptionMsg *exception = [[err userInfo] objectForKey:@"ExceptionMsg"];
            [self.contentView makeToast:exception.message duration:2.0 position:[NSValue valueWithCGPoint:self.contentView.center]];
        }
    } params:params];
}

@end
