//
//  OrderNavigationBar.h
//  styler
//
//  Created by wangwanggy820 on 14-3-31.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define bar_item_width 80
#define order_navigation_bar_height 37

@interface OrderNavigationBar : UIView

-(id)initWithFrame:(CGRect)frame currentIndex:(int)currentIndex;

@end
