//
//  AppDelegate.h
//  iUser
//
//  Created by System Administrator on 13-4-17.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LeveyTabBarController.h"
#import "StylerTabbar.h"
#import "ASIHttpRequestProcessor.h"
#import "Reminder.h"
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "WXApi.h"

@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *rootController;

@property int currentOrderId;
@property BOOL hasReceivedPush;
@property (strong, nonatomic)StylerTabbar *tabbar;
@property (strong, nonatomic)ASIHTTPRequestProcessor *asiProcessor;
@property (strong, nonatomic)Reminder *reminder;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
