//
//  LeftViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/8.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBodyView.h"
#import "MMDrawerController.h"
#import "AppDelegate.h"
@interface LeftViewController : UIViewController

@property (nonatomic , strong) LeftBodyView *bodyView;

@property (nonatomic , assign) CGFloat leftWidth;
@property (nonatomic ,strong) MMDrawerController *drawerController;

@end
