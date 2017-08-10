//
//  AlipayProceessor.h
//  CrazyDoctor
//
//  Created by xubojoy on 16/7/13.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlixPayOrder.h"
#import "PayProcessor.h"
#import "AliPay.h"

@class PaymentType;
//@protocol AlipayProceessorDrelegate <NSObject>
//
//-(void) paymentSuccess:(UINavigationController *)nav;
//-(void) paymentFail:(UINavigationController *)nav;
//
//@end

@interface AlipayProceessor : NSObject<UIAlertViewDelegate>
@property (nonatomic , strong) UINavigationController *navigationController;

@property (nonatomic ,assign) BOOL isClick;
@property (nonatomic ,strong) NSString *type;

+ (AlipayProceessor *) sharedInstance;
-(void) processPaymentResultFromApp:(NSURL *)result nav:(UINavigationController *)nav;


-(void)doAlipay:(AlixPayOrder *)payOrder alipaySign:(NSString *)alipaySign paymentType:(NSString *)paymentType navigationController:(UINavigationController *)navigationController;

-(AlixPayOrder *) buildAlixPayOrder:(AliPay *)projectOrder;


@end
