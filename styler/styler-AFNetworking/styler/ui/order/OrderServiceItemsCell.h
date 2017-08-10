//
//  OrderServiceItemsCell.h
//  styler
//
//  Created by wangwanggy820 on 14-4-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceOrder.h"

@interface OrderServiceItemsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *serviceOrderDescription;
@property (weak, nonatomic) IBOutlet UIView *lineOnTheOriginPrice;
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;
@property (retain, nonatomic) OrderServiceItem *orderServiceItem;

-(void)renderOrderServiceItems:(OrderServiceItem *)orderServiceItem;

@end
