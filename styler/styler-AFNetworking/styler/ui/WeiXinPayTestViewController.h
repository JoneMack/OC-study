//
//  WeiXinPayTestViewController.h
//  styler
//
//  Created by 冯聪智 on 14-10-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
@class WXPrePay;

@interface WeiXinPayTestViewController : UIViewController <NSXMLParserDelegate , WXApiDelegate>

@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (nonatomic, strong) WXPrePay *wxprePay;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
- (IBAction)doPay:(UIButton *)sender;



@end
