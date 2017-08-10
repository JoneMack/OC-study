//
//  ChooseServiceConditionsController.h
//  styler
//
//  Created by wangwanggy820 on 14-4-2.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StylistServicePackage.h"
#import "HeaderView.h"
#import "OrderNavigationBar.h"
#import "StylistPriceList.h"
#import "Stylist.h"
@interface ChooseServiceConditionsController : UIViewController<UICollectionViewDelegate>

@property (strong, nonatomic) HeaderView *header;
@property (strong, nonatomic) OrderNavigationBar *orderBar;
//预计金额
@property (weak, nonatomic) IBOutlet UIView *priceOfOrderWrapperView;
@property (weak, nonatomic) IBOutlet UILabel *priceOfOrder;
@property (weak, nonatomic) IBOutlet UILabel *priceOfOrderInfo;
@property (weak, nonatomic) IBOutlet UILabel *reminderInformation;
@property (weak, nonatomic) IBOutlet UILabel *cutAgainReminderInformation;

//服务包选择   服务条件
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *priceListView;
//服务信息
@property (weak, nonatomic) IBOutlet UIView *serviceinformation;
@property (weak, nonatomic) IBOutlet UILabel *specialOffer;
@property (weak, nonatomic) IBOutlet UILabel *specialOfferDescriptions;
@property (weak, nonatomic) IBOutlet UILabel *service;
@property (weak, nonatomic) IBOutlet UILabel *serviceDescriptions;
@property (weak, nonatomic) IBOutlet UILabel *optionValue;
@property (weak, nonatomic) IBOutlet UILabel *optionValueDescriptions;
@property (weak, nonatomic) IBOutlet UILabel *serviceTime;
@property (weak, nonatomic) IBOutlet UILabel *serviceTimeDescriptions;

//预定背景  预定按钮
@property (weak, nonatomic) IBOutlet UIView *orderServiceWrapperView;
@property (weak, nonatomic) IBOutlet UIButton *orderServiceBtn;

@property (strong, nonatomic) StylistServicePackage *servicePackage;
@property (nonatomic, retain) StylistPriceList *priceList;
@property (nonatomic ,retain) Stylist *stylist;
@property (nonatomic, retain) NSMutableArray *stylistServiceItems;
@property (nonatomic, retain) NSMutableArray *selectedStylistServiceItemPrice;

- (IBAction)orderService:(id)sender;

//-(id)initWithServicePackage:(StylistServicePackage *)servicePackage;

@end
