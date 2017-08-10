//
//  WeiXinPayProcessor.m
//  styler
//
//  Created by 冯聪智 on 14-10-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "WeiXinPayProcessor.h"
#import "XMLDocument.h"
#import "WXPrePay.h"
#import "WXPayReq.h"
#import "PayProcessor.h"
#import <objc/runtime.h>

@implementation WeiXinPayProcessor
{
    XMLDocument *xmlElements;
}
-(void)doWeixinpay:(NSString *)outTradeTitle outTradeNo:(NSString *)outTradeNo totalPrice:(float)totalPrice{
    
    AppStatus *as = [AppStatus sharedInstance];
    NSString *baseUrl = as.webPageUrl;
    if ([baseUrl rangeOfString:@"http://test.shishangmao.cn"].location == 0) {
        baseUrl = [baseUrl substringWithRange:NSMakeRange(0, [baseUrl rangeOfString:@"http://test.shishangmao.cn"].location+ @"http://test.shishangmao.cn".length)];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/alipay/tenpay/payRequest.jsp?body=%@&out_trade_no=%@&total_fee=%f" , baseUrl , outTradeTitle ,outTradeNo , totalPrice ];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade doGet:url completionBlock:^(NSString *json, NSError *err) {  // 生成预订单号
        [SVProgressHUD dismiss];
        if (json != nil) {
            NSData *xmlData = [NSData dataWithBytes:[json UTF8String] length:[json length]];
            self.xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
            self.xmlParser.delegate = self;
            xmlElements = [[XMLDocument alloc] init];
            if ([self.xmlParser parse]) {
                [self changeXmlElements2WXPrePay];
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = self.wxprePay.partnerid;
                request.prepayId= self.wxprePay.prepayid;
                request.package = self.wxprePay.package;
                request.nonceStr= self.wxprePay.noncestr;
                request.timeStamp= self.wxprePay.timestamp;
                request.sign= self.wxprePay.sign;
                
                [WXApi registerApp:self.wxprePay.appid];   // 进行支付
                if(![WXApi safeSendReq:request]){
                    [SVProgressHUD showErrorWithStatus:@"调用微信支付app失败"];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"生成微信预支付订单失败"];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"生成微信支付预订单失败"];
        }
    } refresh:YES useCacheIfNetworkFail:NO];
}



-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
                                       namespaceURI:(NSString *)namespaceURI
                                      qualifiedName:(NSString *)qName
                                         attributes:(NSDictionary *)attributeDict{
    [xmlElements.keys addObject:elementName];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)content{
    if ([content isEqualToString:@"\n"]) {
        return;
    }
    if (xmlElements.values.count == 0) {
        [xmlElements.values addObject:@""];
    }
    if (content) {
        [xmlElements.values addObject:content];
    }
}

-(void) changeXmlElements2WXPrePay{
    unsigned int outCount;
    self.wxprePay = [[WXPrePay alloc] init];
    objc_property_t *properties = class_copyPropertyList([WXPrePay class] ,&outCount);
    // TODO : 这个地方可以重构到一个类中
    for (int i=0 ; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        NSString *propertyName = [[NSString alloc] initWithUTF8String:propName];
        for (int j=0 ; j<xmlElements.keys.count ; j++) {
            if ([propertyName isEqualToString:xmlElements.keys[j]]) {
                [self.wxprePay setValue:xmlElements.values[j] forKey:propertyName];
            }
        }
    }
}


-(void) onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
                [SVProgressHUD showSuccessWithStatus:@"支付成功" duration:2.0];
                if ([self.delegate respondsToSelector:@selector(wxpaymentSuccess:)]) {
                    [self.delegate wxpaymentSuccess:self.navigationController];
                }
                break;
            default:
                [SVProgressHUD showErrorWithStatus:@"订单未支付" duration:2.0];
                if ([self.delegate respondsToSelector:@selector(wxpaymentFail:)]) {
                    [self.delegate wxpaymentFail:self.navigationController];
                }
                break;
        }
    }
    
}

+ (WeiXinPayProcessor *) sharedInstance{
    static WeiXinPayProcessor *sharedInstance = nil;
    if(sharedInstance == nil){
        sharedInstance = [[WeiXinPayProcessor alloc] init];
    }
    return sharedInstance;
}



@end
