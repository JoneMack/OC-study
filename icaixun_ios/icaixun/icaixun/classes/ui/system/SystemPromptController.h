//
//  SystemPromptController.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/21.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppInfo.h"

@interface SystemPromptController : UIViewController

@property (nonatomic , strong) HeaderView *headerView;
@property (nonatomic , strong) UIView *bodyView;
@property (nonatomic , strong) UIWebView *webView;

@property (nonatomic , strong) AppInfo *appInfo;



@end
