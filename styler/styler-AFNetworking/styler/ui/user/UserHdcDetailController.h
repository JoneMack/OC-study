//
//  UserHdcDetailController.h
//  styler
//
//  Created by wangwanggy820 on 14-10-14.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHdcDetailController : UIViewController<UIWebViewDelegate, ISSShareViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) HeaderView *header;
@property (copy, nonatomic) NSString *shareTitle;
@property (copy, nonatomic) NSString *shareContent;
@property (copy, nonatomic) NSString *shareImageUrl;
@property (nonatomic, retain) UIImage *shareImage;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *title;
@property BOOL withMask;

-(id) initWithUrl:(NSString *)url title:(NSString *)title;


@end
