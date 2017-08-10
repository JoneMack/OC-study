//
//  HdcDetailController.h
//  styler
//
//  Created by wangwanggy820 on 14-8-5.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "ShareContent.h"
@interface ShareEnableWebController : UIViewController<UIWebViewDelegate,ISSShareViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) HeaderView *header;

@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *shareTitle;
@property (copy, nonatomic) NSString *shareContent;
@property (copy, nonatomic) NSString *shareImageUrl;
@property (copy, nonatomic) NSString *shareUrl;
@property (strong, nonatomic) UIImage *shareImage;
@property BOOL shareable;

-(id) initWithUrl:(NSString *)url title:(NSString *)title shareable:(BOOL)shareable;

-(ShareContent *) collectionShareContent;

@end
