//
//  LeveyTabBar.h
//  LeveyTabBarController
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 VanillaTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarItem.h"

@protocol LeveyTabBarDelegate;

@interface LeveyTabBar : UIView <TabBarItemDelegate>
{
	UIImageView *_backgroundView;
	id<LeveyTabBarDelegate> _delegate;
	NSMutableArray *_buttons;
    NSMutableArray * tabBarItems;
}
@property (nonatomic, retain) UIImageView *backgroundView;
@property (nonatomic, assign) id<LeveyTabBarDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *buttons;

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray andItemTitle:(NSArray *)titles;
- (void)selectTabAtIndex:(NSInteger)index;
- (void)setBackgroundImage:(UIImage *)img;
- (void)addRemindIconIndex:(int)index;
- (void)removeRemindIconIndex:(int)index;

@end

@protocol LeveyTabBarDelegate<NSObject>
@optional
- (void)tabBar:(LeveyTabBar *)tabBar didSelectIndex:(NSInteger)index; 
@end
