//
//  TransactionViewController.h
//  BHZhiBo
//
//  Created by xubojoy on 2016/12/21.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionViewController : BaseViewController<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) HeaderView *headerView;
@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic ,strong) BHZhiBoTabbar *tabbar;
@property (nonatomic ,strong) NSString *flagStr;
@end