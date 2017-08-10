//
//  UserHdc.m
//  styler
//
//  Created by wangwanggy820 on 14-7-18.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "UserHdc.h"
#import "AppStatus.h"


@implementation UserHdc

-(NSString *) getAlipayOutTradeNo{
    NSString *envChar = @"P";
    AppStatus *as = [AppStatus sharedInstance];
    if([as.env isEqualToString:@"test"]){
        envChar = @"T";
    }else if([as.env isEqualToString:@"stage"]){
        envChar = @"S";
    }
    return [NSString stringWithFormat:@"%@card%@", envChar, self.hdcNum];
}

-(NSString *) getAlipayOutTradeTitle{
    return self.title;
}

-(NSString *)specialOfferPriceTxt{
    int specialOfferPriceInt = (int)self.specialOfferPrice;
    NSString *specialOfferPriceTxt = [NSString stringWithFormat:@"￥%.0f", self.specialOfferPrice];
    if (self.specialOfferPrice > (float)specialOfferPriceInt) {
        specialOfferPriceTxt = [NSString stringWithFormat:@"￥%.2f", self.specialOfferPrice];
    }
    return specialOfferPriceTxt;
}

-(NSString *) getPaymentAmountTxt{
    if (self.orderItemStatus == user_card_status_unpayment) {  // 未支付的美发卡
        int paymentItemAmount = (float)self.specialOfferPrice;
        NSString *paymentItemAmountTxt = [NSString stringWithFormat:@"￥%.0f", self.specialOfferPrice];
        if (self.specialOfferPrice > (float)paymentItemAmount) {
            paymentItemAmountTxt = [NSString stringWithFormat:@"￥%.2f", self.specialOfferPrice];
        }
        return paymentItemAmountTxt;
    }else{  // 未使用 ， 已使用  ， 退款
        for (HdcPaymentItem *item in self.hdcPaymentItems) {
            if (item.paymentItemType == payment_item_type_money) {
                int paymentItemAmount = (float)item.paymentItemAmount;
                NSString *paymentItemAmountTxt = [NSString stringWithFormat:@"￥%.0f", item.paymentItemAmount];
                if (item.paymentItemAmount > (float)paymentItemAmount) {
                    paymentItemAmountTxt = [NSString stringWithFormat:@"￥%.2f", item.paymentItemAmount];
                }
                return paymentItemAmountTxt;
            }
        }
    }

    return @"";
}


-(NSString *)expiredTimeString
{
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:[self.expiredTime longLongValue]/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年M月d日";
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

-(BOOL) isRewardedUserHdc{
    if (self.hdcReward != nil && [self.hdcReward.invationStatus isEqualToString:hdc_invitation_reward_status_rewarded]) {
        return YES;
    }
    return NO;
}

-(BOOL) isReceivedUserHdc{
    if (self.hdcReward != nil && [self.hdcReward.invationStatus isEqualToString:hdc_invitation_reward_status_received]) {
        return YES;
    }
    return NO;
}

-(NSString *)orderItemStatusTxt
{
    if ([self isRewardedUserHdc]) {
        return @"未领取";
    }else if([self isReceivedUserHdc]){
        return @"已领取";
    }else if (self.expiredStatus){
        return @"已过期";
    }
    
    switch (self.orderItemStatus) {
        case user_card_status_unpayment:
            return @"未付款";
            break;
        case user_card_status_cancel:
            return @"已取消";
            break;
        case user_card_status_paid:
            return @"已付款";
            break;
        case user_card_status_request_refund:
            return @"退款中";
            break;
        case user_card_status_refunded:
            return @"已退款";
            break;
        case user_card_status_used:
            return @"已使用";
            break;
        default:
            break;
    }
    return @"";
}

-(BOOL) hasUsedRedEnvelope{
    for (HdcPaymentItem *hdcPaymentItem in self.hdcPaymentItems) {
        if (hdcPaymentItem.paymentItemType == payment_item_type_red_envelope) {
            return YES;
        }
    }
    return NO;
}

-(int) getRedEnvelopeAmount{
    for (HdcPaymentItem *hdcPaymentItem in self.hdcPaymentItems) {
        if (hdcPaymentItem.paymentItemType == payment_item_type_red_envelope) {
            return hdcPaymentItem.paymentItemAmount;
        }
    }
    return 0;
}

-(int) getRedEnvelopeId{
    for (HdcPaymentItem *hdcPaymentItem in self.hdcPaymentItems) {
        if (hdcPaymentItem.paymentItemType == payment_item_type_red_envelope) {
            return hdcPaymentItem.redEnvelopeId;
        }
    }
    return 0;
}


-(float) getUserHdcPaymentTotalPrice{
    
    for (HdcPaymentItem *hdcPaymentItem in self.hdcPaymentItems){
        if(hdcPaymentItem.paymentItemType == payment_item_type_money){
            return hdcPaymentItem.paymentItemAmount;
        }
    }
    return 10000; // 获取价格失败，这个地方是可以抛异常提示的。
}

-(NSString *)timeNoteString
{
    NSDate *date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年M月d日";
    NSString *result;
    
    if (self.hdcReward != nil && [self.hdcReward.invationStatus isEqualToString:hdc_invitation_reward_status_rewarded]) {
        result = [NSString stringWithFormat:@"%@%@", [DateUtils stringFromNumber:self.hdcReward.invationTime], @"赠送"];
        return result;
    }
    if (self.hdcReward != nil && [self.hdcReward.invationStatus isEqualToString:hdc_invitation_reward_status_received]) {
        result = [NSString stringWithFormat:@"%@%@",  [DateUtils stringFromNumber:self.hdcReward.receiveTime], @"领取"];
        return result;
    }
    if (self.expiredStatus) {
        result = [NSString stringWithFormat:@"%@%@", [DateUtils stringFromNumber:self.expiredTime], @"过期"];
        return result;
    }
    switch (self.orderItemStatus) {
        case 0:
            date = [[NSDate alloc]initWithTimeIntervalSince1970:[self.expiredTime longLongValue]/1000.0];
            result = [NSString stringWithFormat:@"%@%@", [dateFormatter stringFromDate:date], @"前可以使用"];
            break;
        case 1:
            date = [[NSDate alloc]initWithTimeIntervalSince1970:[self.createTime longLongValue]/1000.0];
            result = [NSString stringWithFormat:@"%@%@", [dateFormatter stringFromDate:date], @"购买"];
            break;
        case 2:
            date = [[NSDate alloc]initWithTimeIntervalSince1970:[self.payTime longLongValue]/1000.0];
            result = [NSString stringWithFormat:@"%@%@", [dateFormatter stringFromDate:date], @"付款"];
            break;
        case 3:  // 申请退款中
            date = [[NSDate alloc]initWithTimeIntervalSince1970:[self.applyRefundTime longLongValue]/1000.0];
            result = [NSString stringWithFormat:@"%@%@", [dateFormatter stringFromDate:date], @"申请退款"];
            break;
        case 4:  // 已退款
            if (self.hdcReward != nil && [self.hdcReward.invationStatus isEqualToString:hdc_invitation_reward_status_received]) {
                result = [NSString stringWithFormat:@"%@%@",  [DateUtils stringFromNumber:self.hdcReward.receiveTime], @"领取"];
                break;
            }
            date = [[NSDate alloc]initWithTimeIntervalSince1970:[self.refundTime longLongValue]/1000.0];
            result = [NSString stringWithFormat:@"%@%@", [dateFormatter stringFromDate:date], @"退款成功"];
            break;
        case 5:
            date = [[NSDate alloc]initWithTimeIntervalSince1970:[self.useTime longLongValue]/1000.0];
            result = [NSString stringWithFormat:@"%@%@", [dateFormatter stringFromDate:date], @"激活使用"];
            break;
            
        default:
            break;
    }
    return result;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.id forKey:@"id"];
    [aCoder encodeInt:self.orderId forKey:@"orderId"];
    [aCoder encodeObject:self.hdcNum forKey:@"hdcNum"];
    if (self.payTime != nil) {
        [aCoder encodeObject:self.payTime forKey:@"payTime"];
    }
    if (self.refundTime != nil) {
        [aCoder encodeObject:self.refundTime forKey:@"refundTime"];
    }
    if (self.useTime != nil) {
        [aCoder encodeObject:self.useTime forKey:@"useTime"];
    }
    if (self.applyRefundTime != nil) {
        [aCoder encodeObject:self.applyRefundTime forKey:@"applyRefundTime"];
    }
    
    [aCoder encodeInt:self.hairDressingCardId forKey:@"hairDressingCardId"];
    [aCoder encodeInt:self.organizationId forKey:@"organizationId"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.hdcType forKey:@"hdcType"];
    [aCoder encodeObject:self.hdcDescription forKey:@"hdcDescription"];
    [aCoder encodeFloat:self.price forKey:@"price"];
    [aCoder encodeFloat:self.specialOfferPrice forKey:@"specialOfferPrice"];
    if (self.discount != nil) {
        [aCoder encodeObject:self.discount forKey:@"discount"];
    }
    if (self.specialOfferDescription != nil) {
        [aCoder encodeObject:self.specialOfferDescription forKey:@"specialOfferDescription"];
    }
    if (self.remark != nil) {
        [aCoder encodeObject:self.remark forKey:@"remark"];
    }
    if (self.expiredTime != nil) {
        [aCoder encodeObject:self.expiredTime forKey:@"expiredTime"];
    }
    [aCoder encodeObject:self.iconUrl forKey:@"iconUrl"];
    [aCoder encodeBool:self.expiredStatus forKey:@"expiredStatus"];
    [aCoder encodeInt:self.orderItemStatus forKey:@"orderItemStatus"];
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
    
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    if(self){
        self.id = [aDecoder decodeIntForKey:@"id"];
        self.orderId = [aDecoder decodeIntForKey:@"orderId"];
        self.hdcNum = [aDecoder decodeObjectForKey:@"hdcNum"];
        self.payTime = [aDecoder decodeObjectForKey:@"payTime"];
        self.refundTime = [aDecoder decodeObjectForKey:@"refundTime"];
        self.useTime = [aDecoder decodeObjectForKey:@"useTime"];
        self.applyRefundTime = [aDecoder decodeObjectForKey:@"applyRefundTime"];
        self.hairDressingCardId = [aDecoder decodeIntForKey:@"hairDressingCardId"];
        self.organizationId = [aDecoder decodeIntForKey:@"organizationId"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.hdcType = [aDecoder decodeObjectForKey:@"hdcType"];
        self.hdcDescription = [aDecoder decodeObjectForKey:@"hdcDescription"];
        self.price = [aDecoder decodeFloatForKey:@"price"];
        self.specialOfferPrice = [aDecoder decodeFloatForKey:@"specialOfferPrice"];
        self.discount = [aDecoder decodeObjectForKey:@"discount"];
        self.specialOfferDescription = [aDecoder decodeObjectForKey:@"specialOfferDescription"];
        self.remark = [aDecoder decodeObjectForKey:@"remark"];
        self.expiredTime = [aDecoder decodeObjectForKey:@"expiredTime"];
        self.iconUrl = [aDecoder decodeObjectForKey:@"iconUrl"];
        self.expiredStatus = [aDecoder decodeBoolForKey:@"expiredStatus"];
        self.orderItemStatus = [aDecoder decodeIntForKey:@"orderItemStatus"];
        self.createTime = [aDecoder decodeObjectForKey:@"createTime"];
    }
    return self;
}

@end
