//
//  PayProcessor.h
//  styler
//
//  Created by 冯聪智 on 14-10-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlipayProcessor.h"
#import "WeiXinPayProcessor.h"
@class UserHdc, HdcOrder, Page, StylistProfileController ;

//-------------------------------------------
//  支付类型的数据结构
//-------------------------------------------
@interface PaymentType : NSObject

@property (nonatomic, copy , readonly) NSString *paymentTypeIcon;
@property (nonatomic, copy , readonly) NSString *paymentTypeName;

-(instancetype) init __attribute__((unavailable("Must use initWithPaymentTypeName method instead.")));
-(BOOL) isTenPay;
-(BOOL) isALIAPPPay;
-(BOOL) isALIWEBPay;

@end


//-------------------------------------------
//  支付处理器
//-------------------------------------------
@interface PayProcessor : NSObject <AlipayProcessorDelegate , WeiXinPayProcessorDelegate>


/*
 因为服务器端接收支付宝支付成功通知并更新状态有可能有延迟，这种延迟
 会体现在产品上未能显示刚刚支付成功的美发卡，为此客户端弥补性的临时
 记录已支付的美发卡，当服务器端也完成了支付状态的更新则把客户端临时
 记录清除掉
 */

//正在支付的卡片
@property (nonatomic, strong) NSMutableArray *payingCards;
//支付成功的卡片
@property (nonatomic, strong) NSMutableArray *paidCards;
@property (nonatomic, strong) NSString *payFrom;
@property (nonatomic, strong) StylistProfileController *spc;

@property (nonatomic , strong) NSMutableArray *paymentTypes;

-(instancetype)init __attribute__((unavailable("Must use sharedInstance method instead.")));

-(NSMutableArray *) getPaymentTypes;
-(PaymentType *) getDefaultPaymentType;


-(void) addPayingCard:(UserHdc *)card;
-(void) addHdcOrder:(HdcOrder *)order;
-(void) mergePaidCardsWithLocal:(Page *)page;
-(void) mergeUnpaymentCardsWithLocal:(Page *)page;
-(void) cleanLocalData;

-(void) savePayProcessor;

+ (NSString *) savedPath;
+(PayProcessor *) sharedInstance;
@end
