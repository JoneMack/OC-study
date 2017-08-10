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
#import "SpecialEvent.h"

@interface ChooseOrderTimeController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) HeaderView *header;
@property (strong, nonatomic) OrderNavigationBar *navBar;
//遮罩视图
@property (strong, nonatomic) IBOutlet UIView *maskView;
//作容器用
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITableView *userInfoTableView;
@property (weak, nonatomic) IBOutlet UIView *scheduleTimeView;

@property (weak, nonatomic) IBOutlet UILabel *orderDescription;
@property (weak, nonatomic) IBOutlet UILabel *chooseTime;
@property (strong, nonatomic) IBOutlet UIView *chooseTimeModalView;


@property (weak, nonatomic) IBOutlet UIView *specialRemarkView;
@property (weak, nonatomic) IBOutlet UILabel *specialRemark;
@property (strong, nonatomic) IBOutlet UIView *chooseSpecialRemarkModalView;
@property (weak, nonatomic) IBOutlet UIPickerView *specialRemarkPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *scheduleTimePicker;


@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;


@property (nonatomic, retain) StylistServicePackage *servicePackage;
@property (nonatomic, retain) TargetServiceItems *targetServiceItems;
@property (nonatomic ,retain) Stylist *stylist;
@property (nonatomic, strong) NSArray *orderedHours;
@property (nonatomic, strong) NSArray *specialEventArray;
@property (nonatomic, strong) SpecialEvent *specialEvent;
@property (nonatomic, strong) NSArray *daysCanOrder;
@property (nonatomic, strong) NSArray *hoursCanOrder;
@property (nonatomic, retain) NSDate *scheduleDate;


- (IBAction)cancelChooseSpecialRemark:(id)sender;
- (IBAction)confirmChooseSpecialRemark:(id)sender;

- (IBAction)cancelChooseTime:(id)sender;
- (IBAction)confirmChooseTime:(id)sender;
- (IBAction)confirmOrder:(id)sender;

@end
