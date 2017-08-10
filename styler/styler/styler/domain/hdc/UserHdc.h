//
//  UserHdc.h
//  styler
//
//  Created by wangwanggy820 on 14-7-18.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define user_card_status_unpayment        0
#define user_card_status_cancel           1
#define user_card_status_paid             2
#define user_card_status_request_refund   3
#define user_card_status_refunded         4
#define user_card_status_used             5
#define user_card_status_waitting_paid    6
#define user_card_status_donate           7


#define payment_item_type_money  1
#define payment_item_type_red_envelope 2

#import <Foundation/Foundation.h>
#import "HdcType.h"
#import "HdcPaymentItem.h"
#import "HdcInvitationReward.h"

@protocol UserHdc
@end

@interface UserHdc : JSONModel

@property int id;
@property int orderId;
@property (nonatomic, copy) NSString *hdcNum;
@property NSNumber<Optional> *payTime;
@property NSNumber<Optional> *refundTime;
@property NSNumber<Optional> *useTime;
@property NSNumber<Optional> *applyRefundTime;
@property int hairDressingCardId;
@property int organizationId;
@property int stylistId;
@property (nonatomic, copy) NSString *title;
@property HdcType *hdcType; 
@property (nonatomic, copy) NSString<Optional> *hdcDescription;
@property float price;
@property float specialOfferPrice;
@property (nonatomic, copy) NSString<Optional> *discount;
@property (nonatomic, copy) NSString<Optional> *specialOfferDescription;
@property (nonatomic, copy) NSString<Optional> *remark;
@property NSNumber<Optional> *expiredTime;
@property (nonatomic, copy) NSString *iconUrl;
@property BOOL expiredStatus;
@property int orderItemStatus;
@property (nonatomic, strong) NSArray<HdcPaymentItem,Optional>  *hdcPaymentItems;
@property NSNumber *createTime;
@property (nonatomic, strong) HdcInvitationReward<Optional> *hdcReward;



-(NSString *) specialOfferPriceTxt;
-(NSString *) expiredTimeString;

-(NSString *) orderItemStatusTxt;
-(NSString *) timeNoteString;

-(NSString *) getAlipayOutTradeNo;
-(NSString *) getAlipayOutTradeTitle;
-(BOOL) hasUsedRedEnvelope;
-(int) getRedEnvelopeAmount;
-(NSString *) getPaymentAmountTxt;
-(int) getRedEnvelopeId;
-(BOOL) isRewardedUserHdc;
-(BOOL) isReceivedUserHdc;


/**
 *  获取用户美发卡支付的总金额，
 *  当有红包时，获得的是减去红包后的价格，
 *  如果没有红包，获取就是优惠价。
 */
-(float) getUserHdcPaymentTotalPrice;



@end





