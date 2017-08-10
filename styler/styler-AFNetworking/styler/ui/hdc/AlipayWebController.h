//
//  AlipayWebController.h
//  styler
//
//  Created by System Administrator on 14-7-30.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"

@interface AlipayWebController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) HeaderView *header;

@property (copy, nonatomic) NSString *url;
@property (nonatomic, copy) NSString *backUrl;

-(id) initWithUrl:(NSString *)url;
@end
