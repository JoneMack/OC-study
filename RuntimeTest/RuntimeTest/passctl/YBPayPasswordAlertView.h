//
//  YBPayPasswordAlertView.h
//
//  Created by xubojoy on 2018/3/23.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import "PassGuardCtrl.h"
@protocol payPasswordAlertDelegate <NSObject>
@optional
-(void)closeAlert;
-(void)forgetPayPassword;
@end

typedef void(^payBlock)(NSString *payPsw);
@interface YBPayPasswordAlertView : UIView<DoneDelegate,OnCharDelegate>
@property (strong, nonatomic) UIView * blackView;
@property (strong, nonatomic) UIView * alertView;
@property(strong,nonatomic)    PassGuardTextField *passGuard;
//设置随机字符串，用来产生AES密钥（需要与解密端字符串同步）
@property (nonatomic, strong) NSString *randomKey;
//设置RSA加密公钥。
@property (nonatomic, strong) NSString *pubKey;

/**
 *  支付密码alert
 */
@property(copy,nonatomic)payBlock payPSWBlock;
@property (assign, nonatomic) id<payPasswordAlertDelegate> delegate_pay;

-(void)showInView:(UIView *)view;
-(void)close;
/**
 *  初始化界面
 */
-(void)initWithView;

@end
