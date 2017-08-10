//
//  AllHairStyleController.h
//  styler
//
//  Created by System Administrator on 14-2-13.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"

@interface AllHairStyleController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) HeaderView *header;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *loadingTxt;

@property (strong, nonatomic) UIButton *bigRetryBut;

@end
