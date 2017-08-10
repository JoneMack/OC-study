//
//  WeiXinPayTestViewController.m
//  styler
//
//  Created by 冯聪智 on 14-10-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "WeiXinPayTestViewController.h"
#import "WXPrePay.h"
#import "WXPayReq.h"
#import "XMLDocument.h"
#import <objc/runtime.h>

@interface WeiXinPayTestViewController ()
{
    XMLDocument *xmlElements;
}
@end

@implementation WeiXinPayTestViewController

-(id) initWithXib{
    self = [super init];
    self = [[[NSBundle mainBundle] loadNibNamed:@"WeiXinPayTestViewController" owner:self options:nil] objectAtIndex:0];
    [WXApi handleOpenURL:nil delegate:self];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



- (IBAction)doPay:(UIButton *)sender {
    
    NSString *genOutTradeNo = [NSString stringWithFormat:@"%lld" , [DateUtils longlongintFromDate:[NSDate date]]] ;
    NSString *urlStr = [NSString stringWithFormat:@"http://test.shishangmao.cn/alipay/tenpay/payRequest.jsp?body=剪发*1&out_trade_no=%@&total_fee=0.01" , genOutTradeNo];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade doGet:url completionBlock:^(NSString *json, NSError *err) {
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

                [WXApi registerApp:self.wxprePay.appid];
                if(![WXApi safeSendReq:request]){
                    NSLog(@"微信调用失败");
                }
            }else{
                NSLog(@"生成预订单失败");
            }

        }else if (err != nil)
        {
            NSLog(@"获取xml失败");
        }
    } refresh:YES useCacheIfNetworkFail:YES];
    
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:
    (NSString *)qName attributes:(NSDictionary *)attributeDict{
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




@end
