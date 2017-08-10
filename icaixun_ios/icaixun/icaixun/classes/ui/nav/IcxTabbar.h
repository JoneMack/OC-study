//
//  IcxTabbar.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/31.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeveyTabBarController.h"

@interface IcxTabbar : NSObject < UINavigationControllerDelegate , LeveyTabBarControllerDelegate >

@property (nonatomic , copy) NSString *currentPageName;

@property (nonatomic , strong) LeveyTabBarController *tabbarController;

-(instancetype) init;


-(void) setSelectedIndex:(int)selectedIndex;
-(UINavigationController *) getSelectedViewController;

@end
