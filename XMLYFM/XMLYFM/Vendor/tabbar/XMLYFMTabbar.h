//
//  XMLYFMTabbar.h
//  XMLYFM
//
//  Created by xubojoy on 2017/8/22.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
@interface XMLYFMTabbar : NSObject<UINavigationControllerDelegate,RDVTabBarControllerDelegate>
@property (nonatomic,copy)NSString *currentPageName;

@property (nonatomic, strong) RDVTabBarController *tabBarController;

-(id) init;

-(UINavigationController *) getSelectedViewController;
-(UINavigationController *) getViewController:(int)index;

-(NSInteger) getSelectedIndex;
-(void) setSelectedIndex:(int)selectedIndex;
-(NSString *) getCurrentPageName;


@end
