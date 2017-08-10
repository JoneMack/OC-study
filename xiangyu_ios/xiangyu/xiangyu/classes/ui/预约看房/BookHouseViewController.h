//
//  BookHouseViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/17.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseInfo.h"
#import "SelectDateTimePicker.h"

@interface BookHouseViewController : UIViewController <SelectDateTimePickerDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerBlock;

@property (strong, nonatomic) HeaderView *headerView;

@property (strong, nonatomic) IBOutlet UITextField *userName;


@property (strong, nonatomic) IBOutlet UIButton *bookAnyTime;

@property (strong, nonatomic) IBOutlet UIButton *bookSpecialTime;


@property (strong, nonatomic) IBOutlet UIButton *booTime;

@property (strong, nonatomic) IBOutlet UIView *bookTimeBlock;

@property (strong, nonatomic) IBOutlet UITextField *mobileNo;


@property (strong, nonatomic) IBOutlet UILabel *checkCodeLabel;


@property (strong, nonatomic) IBOutlet UITextField *checkCode;


@property (strong, nonatomic) IBOutlet UIButton *sendCheckCode;


@property (strong, nonatomic) IBOutlet UIButton *submitBook;

@property (nonatomic , strong) UIView *separatorLine;

@property (nonatomic , strong) NSLayoutConstraint *bookTimeBlockCons;


@property (nonatomic , strong) SelectDateTimePicker *selectDateTimePicker;

@property (strong, nonatomic) NSTimer *countTimer;

@property (nonatomic , assign) int leftCount;

@property (nonatomic , weak) HouseInfo *houseInfo;

@property (nonatomic , strong) NSString *currentBookType;


- (IBAction)sendCheckCodeEvent:(id)sender;


- (IBAction)submitBookViewHouse:(id)sender;
- (IBAction)changeToBookAndTime:(id)sender;

- (IBAction)changeToBookSpecialTime:(id)sender;

@end
