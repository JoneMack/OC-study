//
//  AppDelegate.h
//  BHZhiBo
//
//  Created by xubojoy on 2016/12/21.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHZhiBoTabbar.h"
#import "NetworkProcessor.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic ,strong) BHZhiBoTabbar *tabbar;
@property (nonatomic ,strong) NetworkProcessor *netProcessor;
@end

