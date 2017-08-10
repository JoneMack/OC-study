//
//  HDCOrder.m
//  styler
//
//  Created by wangwanggy820 on 14-7-18.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "HdcOrder.h"

@implementation HdcOrder

-(NSString *) getOutTradeNo{
//    NSMutableString *result = [[NSMutableString alloc] init];
//    for(int i = 0; i < self.hdcOrderItems.count; i++) {
//        UserHdc *hdc = self.hdcOrderItems[i];
//        if (i == (self.hdcOrderItems.count-1)) {
//            [result appendString:hdc.hdcNum];
//        }else{
//            [result appendFormat:@"%@", hdc.hdcNum];
//        }
//    }
    NSString *envChar = @"P";
    AppStatus *as = [AppStatus sharedInstance];
    if([as.env isEqualToString:@"test"]){
        envChar = @"T";
    }else if([as.env isEqualToString:@"stage"]){
        envChar = @"S";
    }
    
    return [NSString stringWithFormat:@"%@order%d", envChar, self.id];
}

-(NSString *) getOutTradeTitle{
    NSLog(@"%@*%d", ((UserHdc *)self.hdcOrderItems[0]).title, self.hdcCount);
    return [NSString stringWithFormat:@"%@*%d", ((UserHdc *)self.hdcOrderItems[0]).title, self.hdcCount];
}


-(float) getPaymentTotalAmount{
    float totalPrice = 0;
    for (int i=0 ; i<self.hdcOrderItems.count ; i++) {
        UserHdc *userHdc = self.hdcOrderItems[i];
        for (HdcPaymentItem *hdcPaymentItem in userHdc.hdcPaymentItems) {
            if (hdcPaymentItem.paymentItemType == payment_item_type_money) {
                totalPrice = totalPrice + hdcPaymentItem.paymentItemAmount;
            }
        }
    }
    return totalPrice;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.id forKey:@"id"];
    [aCoder encodeInt64:self.createTime forKey:@"createTime"];
    [aCoder encodeFloat:self.totalPrice forKey:@"totalPrice"];
    [aCoder encodeInt:self.hdcCount forKey:@"hdcCount"];
    [aCoder encodeObject:self.hdcOrderItems forKey:@"hdcOrderItems"];
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.id = [aDecoder decodeIntForKey:@"id"];
        self.createTime = [aDecoder decodeInt64ForKey:@"createTime"];
        self.totalPrice = [aDecoder decodeFloatForKey:@"totalPrice"];
        self.hdcCount = [aDecoder decodeIntForKey:@"hdcCount"];
        self.hdcOrderItems = [aDecoder decodeObjectForKey:@"hdcOrderItems"];
    }
    return self;
}


@end
