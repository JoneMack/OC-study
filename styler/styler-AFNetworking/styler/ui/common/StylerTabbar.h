//
//  StylerTabbar.h
//  styler
//
//  Created by System Administrator on 14-8-26.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeveyTabBarController.h"

@interface StylerTabbar : NSObject<UINavigationControllerDelegate, LeveyTabBarControllerDelegate>

@property (nonatomic,copy)NSString *currentPageName;

@property (nonatomic, strong) LeveyTabBarController *tabbarController;

-(id) init;

-(void) goChatView;

-(UINavigationController *) getSelectedViewController;
-(UINavigationController *) getViewController:(int)index;

-(int) getSelectedIndex;
-(void) setSelectedIndex:(int)selectedIndex;
-(NSString *) getCurrentPageName;
@end
