//
//  RentDelegateFormCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/20.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RentDelegateFormCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UITextField *xiaoQuMingCheng;


@property (strong, nonatomic) IBOutlet UIButton *quyu;

@property (strong, nonatomic) IBOutlet UIButton *shangquan;


@property (strong, nonatomic) IBOutlet UITextField *zujin;


@property (strong, nonatomic) IBOutlet UITextField *userName;


@property (strong, nonatomic) IBOutlet UITextField *mobileNo;


@property (strong, nonatomic) IBOutlet UILabel *checkCodeLabel;

@property (strong, nonatomic) IBOutlet UITextField *checkCode;


@property (strong, nonatomic) IBOutlet UIButton *sendCheckCode;

@property (strong, nonatomic) IBOutlet UIButton *submitInfo;

@property (strong, nonatomic) IBOutlet UIView *line1;

@property (strong, nonatomic) IBOutlet UIView *line2;


@property (strong, nonatomic) IBOutlet UIView *line3;


@property (strong, nonatomic) NSString *selectedChengQu;
@property (strong, nonatomic) NSString *selectedShangQuan;


@property (nonatomic , assign) int leftCount;
@property (strong, nonatomic) NSTimer *countTimer;

@property (nonatomic , weak) UINavigationController *navigationController;



- (IBAction)selectQuyu:(id)sender;

- (IBAction)selectShangquan:(id)sender;

- (IBAction)sendCheckCode:(id)sender;


- (IBAction)submitRentDelegate:(id)sender;



@end
