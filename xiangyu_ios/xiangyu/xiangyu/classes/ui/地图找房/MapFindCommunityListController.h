//
//  MapFindCommunityListController.h
//  xiangyu
//
//  Created by xubojoy on 16/6/15.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
@interface MapFindCommunityListController : UIViewController
@property (nonatomic , strong) HeaderView *headerView;
@property (nonatomic ,strong) NSString *titleName;
@property (nonatomic ,strong) MMDrawerController *drawerController;
- (instancetype)initWithTitle:(NSString *)titleName;

@end
