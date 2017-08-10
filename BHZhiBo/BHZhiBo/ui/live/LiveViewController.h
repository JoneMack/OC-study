//
//  LiveViewController.h
//  BHZhiBo
//
//  Created by xubojoy on 2016/12/21.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveViewController : BaseViewController<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) HeaderView *headerView;
@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@end
