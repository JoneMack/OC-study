//
//  WeiXinPayProcessor.h
//  styler
//
//  Created by 冯聪智 on 14-10-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXPrePay.h"
#import "HdcOrder.h"

@protocol WeiXinPayProcessorDelegate <NSObject>

@optional
-(void) wxpaymentSuccess:(UINavigationController *)nav;
-(void) wxpaymentFail:(UINavigationController *)nav;

@end

@interface WeiXinPayProcessor : NSObject <NSXMLParserDelegate ,WXApiDelegate>

@property (nonatomic , weak) UINavigationController *navigationController;
@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (nonatomic, strong) WXPrePay *wxprePay;
@property (nonatomic, strong) id<WeiXinPayProcessorDelegate> delegate;

-(void)doWeixinpay:(NSString *)outTradeTitle outTradeNo:(NSString *)outTradeNo totalPrice:(float)totalPrice;

+ (WeiXinPayProcessor *) sharedInstance;
@end
