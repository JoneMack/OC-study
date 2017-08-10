//
//  AppDelegate.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/6.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Main2ViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "MMExampleCenterTableViewController.h"
#import "MMExampleLeftSideDrawerViewController.h"
#import "MMNavigationController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "LeftViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Main2ViewController *mainViewController;
@property (nonatomic,strong) MMDrawerController * drawerController;



@end

