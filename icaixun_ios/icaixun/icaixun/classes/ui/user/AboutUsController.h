//
//  AboutUsController.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/4.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutUsBodyView.h"

@interface AboutUsController : UIViewController

@property (nonatomic , strong) HeaderView *headerView;
@property (nonatomic , strong) AboutUsBodyView *bodyView;


@property (strong, nonatomic) LineDashView *dashLine;

@end
