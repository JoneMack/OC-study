//
//  OrderServiceItemsController.h
//  styler
//
//  Created by System Administrator on 14-4-9.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "ServiceOrder.h"
#import "OrderServiceItemsCell.h"

@interface OrderServiceItemsController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)HeaderView *header;
@property (weak, nonatomic) IBOutlet UIView *amountView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceTabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceInfo;
@property (weak, nonatomic) IBOutlet UITableView *serviceItemsTableView;
@property (nonatomic, retain) ServiceOrder *serviceOrder;

-(id)initWithOrder:(ServiceOrder *)order;

@end
