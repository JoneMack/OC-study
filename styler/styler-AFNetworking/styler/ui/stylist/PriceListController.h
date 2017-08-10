//
//  PriceListController.h
//  styler
//
//  Created by System Administrator on 14-4-1.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stylist.h"
#import "StylistPriceList.h"
#import "HeaderView.h"

@interface PriceListController : UIViewController<UICollectionViewDelegate>

@property (nonatomic, strong) HeaderView *header;
@property (weak, nonatomic) IBOutlet UIScrollView *wrapper;

@property (nonatomic, retain) Stylist *stylist;
@property (nonatomic, retain) StylistPriceList *priceList;
@end
