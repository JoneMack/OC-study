//
//  OrderDetailInfoController.h
//  styler
//
//  Created by System Administrator on 14-4-7.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "ServiceOrder.h"
#import "OrderNavigationBar.h"
#import "CommonItemTxtView.h"
#import "Stylist.h"
//订单的界面状态，刚下单后跳转过来的成功状态；二次从我的订单列表过来的成功状态；等待评价状态；订单已取消
#define order_ui_status_success_first 0
#define order_ui_status_success_second 1
#define order_ui_status_wait_evaluation 2
#define order_ui_status_complete_evaluation 3
#define order_ui_status_canceled 4

#define order_safeguard_btn_height 30
#define bottom_view_height 50

@interface OrderDetailInfoController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) HeaderView *header;
@property (strong, nonatomic) OrderNavigationBar *orderBar;
@property (weak, nonatomic) IBOutlet UIScrollView *mainContent;

@property (weak, nonatomic) IBOutlet UIView *statusAndNoView;
@property (weak, nonatomic) IBOutlet UIButton *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;

@property (weak, nonatomic) IBOutlet UIView *orderSuccessNavView;
@property (weak, nonatomic) IBOutlet UIButton *goBackStylistProfileBtn;
@property (weak, nonatomic) IBOutlet UIButton *goMyOrderBtn;


@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userGender;
@property (weak, nonatomic) IBOutlet UILabel *userMobileNo;

@property (weak, nonatomic) IBOutlet UIView *scheduleTimeView;
@property (weak, nonatomic) IBOutlet UILabel *scheduleTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *stylistAndServiceItemView;
@property (weak, nonatomic) IBOutlet UILabel *stylistNameLabel;

@property (weak, nonatomic) IBOutlet UIView *stylistAndServiceItemSpliteLine;
@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet UIImageView *gotoNextImageView;
@property (weak, nonatomic) IBOutlet UILabel *outOfStack;

@property (weak, nonatomic) IBOutlet UIView *orderAmountView;
@property (weak, nonatomic) IBOutlet UILabel *amountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceTipLabel1;
@property (weak, nonatomic) IBOutlet UILabel *serviceTipLabel2;

@property (weak, nonatomic) IBOutlet UITableView *remarkAndOrgInfoTableView;
@property (strong, nonatomic) CommonItemTxtView *orderServiceDescriptionView;


@property (weak, nonatomic) IBOutlet UIButton *safeguardBtn;


@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *operationBtn;

@property (retain, nonatomic) ServiceOrder *order;
@property int orderId;
@property int orderUIStatus;

- (IBAction)goHome:(id)sender;
- (IBAction)goMyOrder:(id)sender;

-(void)orderStatusChanged;
-(id)initWithOrder:(ServiceOrder *)order orderUIStatus:(int)orderUIStatus;
-(id)initWithOrderId:(int)orderId;

@end
