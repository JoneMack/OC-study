//
//  SelectOrderTimeController.h
//  styler
//
//  Created by wangwanggy820 on 14-4-7.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "OrderNavigationBar.h"
#import "StylistServicePackage.h"
#import "Stylist.h"
#import "StylistPriceList.h"
#import "CommonItemTxtView.h"

@interface OrderOnlineController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) HeaderView *header;
//遮罩视图
@property (strong, nonatomic) IBOutlet UIView *maskView;
//作容器用
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITableView *userInfoTableView;
//预约种类
@property (weak, nonatomic) IBOutlet UIView *chooseServicePackage;
@property (weak, nonatomic) IBOutlet UILabel *servicePackageName;

@property (weak, nonatomic) IBOutlet UIView *scheduleTimeView;

@property (weak, nonatomic) IBOutlet UILabel *chooseTime;
@property (strong, nonatomic) IBOutlet UIView *chooseTimeModalView;


@property (weak, nonatomic) IBOutlet UIView *specialRemarkView;
@property (weak, nonatomic) IBOutlet UILabel *specialRemark;
@property (weak, nonatomic) IBOutlet UITextField *inputRemark;


@property (strong, nonatomic) IBOutlet UIView *chooseSpecialRemarkModalView;
@property (weak, nonatomic) IBOutlet UIPickerView *servicePackagePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *scheduleTimePicker;

@property (weak, nonatomic) IBOutlet UIView *serviceDescriptionWapper;
@property (weak, nonatomic) IBOutlet UILabel *serviceDescription;
@property (strong, nonatomic) CommonItemTxtView *orderServiceDescriptionView;

@property (weak, nonatomic) IBOutlet UIView *btnWapper;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic ,retain) Stylist *stylist;
//@property (nonatomic, strong) NSArray *orderedHours;
@property (nonatomic, strong) NSArray *orderedTimes;
@property (nonatomic, strong) NSArray *servicePackages;
@property (nonatomic, strong) NSArray *daysCanOrder;
@property (nonatomic, strong) NSArray *hoursCanOrder;
@property (nonatomic, retain) NSDate *scheduleDate;


- (IBAction)cancelChooseServicePackage:(id)sender;
- (IBAction)confirmChooseServicePackage:(id)sender;

- (IBAction)cancelChooseTime:(id)sender;
- (IBAction)confirmChooseTime:(id)sender;
- (IBAction)confirmOrder:(id)sender;

@end
