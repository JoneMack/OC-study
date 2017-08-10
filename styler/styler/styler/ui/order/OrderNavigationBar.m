//
//  OrderNavigationBar.m
//  styler
//
//  Created by wangwanggy820 on 14-3-31.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "OrderNavigationBar.h"
#import "OrderNavigationBarItem.h"

@implementation OrderNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame currentIndex:(int)currentIndex
{
    self = [super initWithFrame:frame];
    self.frame = frame;
    NSArray *itemArray = [NSArray arrayWithObjects:@"选择项目", @"预约时间", @"预约成功", @"完成评价", nil];
    for (int i = 0; i < itemArray.count; i++) {
        OrderNavigationBarItem *barItem = [[OrderNavigationBarItem alloc] initWithFrame:CGRectMake(i * bar_item_width, 0, bar_item_width, order_navigation_bar_height) itemName:itemArray[i] num:i selected:(currentIndex == i)];
        if (i == itemArray.count - 1) {
            barItem.itemSeparator.hidden = YES;
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, order_navigation_bar_height -splite_line_height, screen_width, splite_line_height)];
        line.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        [self addSubview:line];
        [self addSubview:barItem];
    }
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    return self;
}



@end
