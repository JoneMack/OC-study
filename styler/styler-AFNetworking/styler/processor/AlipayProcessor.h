//
//  AlipayProcessor.h
//  styler
//
//  Created by System Administrator on 14-7-18.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StylistProfileController.h"
@class PaymentType, HdcOrder, UserHdc , Page , AlixPayOrder;

@protocol AlipayProcessorDelegate <NSObject>

@optional
-(void) paymentSuccess:(UINavigationController *)nav;
-(void) paymentFail:(UINavigationController *)nav;

@end

@interface AlipayProcessor : NSObject<UIAlertViewDelegate>

@property (nonatomic , weak) UINavigationController *navigationController;
@property (nonatomic , strong) id<AlipayProcessorDelegate> delegate;

+ (AlipayProcessor *) sharedInstance;
-(void) processPaymentResultFromApp:(NSString *)result nav:(UINavigationController *)nav;
-(void) processPaymentResultFromWeb:(NSString *)result nav:(UINavigationController *)nav;
-(void)doAlipay:(AlixPayOrder *)payOrder
    paymentType:(PaymentType *)paymentType navigationController:(UINavigationController *)navigationController;

-(AlixPayOrder *) buildAlixPayOrderByUserHdc:(UserHdc *)userHdc;
-(AlixPayOrder *) buildAlixPayOrderByHdcOrder:(HdcOrder *)hdcOrder;

@end
