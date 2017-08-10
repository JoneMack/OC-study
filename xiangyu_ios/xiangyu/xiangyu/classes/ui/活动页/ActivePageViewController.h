//
//  ActivePageViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/5.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Banner.h"

@interface ActivePageViewController : UIViewController

@property (nonatomic , strong) HeaderView *headerView;

@property (nonatomic , strong) UIWebView *webView;

@property (nonatomic , strong) Banner *banner;



@end
