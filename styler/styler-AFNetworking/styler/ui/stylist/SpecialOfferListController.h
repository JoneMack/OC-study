//
//  SpecialOfferListController.h
//  styler
//
//  Created by System Administrator on 14-1-22.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "StylistPriceList.h"

@interface SpecialOfferListController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) HeaderView *header;
@property (weak, nonatomic) IBOutlet UITableView *specialOfferListTable;

@property int specialOfferType;
@property (retain, nonatomic) StylistPriceList *priceList;
@property (strong, nonatomic) NSArray *specialOffersCommonItemTxtArray;
@end
