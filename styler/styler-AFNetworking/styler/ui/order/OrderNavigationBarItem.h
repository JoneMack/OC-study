//
//  OrderNavigationBar.h
//  styler
//
//  Created by wangwanggy820 on 14-3-31.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define bar_item_width 80
@interface OrderNavigationBarItem : UIView
@property (weak, nonatomic) IBOutlet UILabel *itemNum;
@property (weak, nonatomic) IBOutlet UIImageView *itemNumBgView;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UIImageView *itemSeparator;

-(id)initWithFrame:(CGRect)frame itemName:(NSString *)itemName num:(int)num selected:(BOOL)selected;
@end
