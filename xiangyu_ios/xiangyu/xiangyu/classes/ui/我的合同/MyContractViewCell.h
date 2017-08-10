//
//  MyContractViewCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/8.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractInfoList.h"
@interface MyContractViewCell : UITableViewCell



@property (strong, nonatomic) IBOutlet UIView *firstLineView;

@property (strong, nonatomic) IBOutlet UILabel *address;

@property (strong, nonatomic) IBOutlet UIView *secondLineView;

@property (strong, nonatomic) IBOutlet UIView *smallLineView;

@property (strong, nonatomic) IBOutlet UILabel *rentType;

@property (strong, nonatomic) IBOutlet UILabel *status;

@property (strong, nonatomic) IBOutlet UIButton *contactBtn;

@property (strong, nonatomic) IBOutlet UILabel *heTongNo;

@property (strong, nonatomic) IBOutlet UILabel *heTongNoVal;

@property (strong, nonatomic) IBOutlet UILabel *rentDate;

@property (strong, nonatomic) IBOutlet UILabel *rentDateVal;

@property (strong, nonatomic) IBOutlet UILabel *rentMoney;

@property (strong, nonatomic) IBOutlet UILabel *rentMoneyVal;

@property (strong, nonatomic) IBOutlet UILabel *guanJia;

@property (strong, nonatomic) IBOutlet UILabel *guanJiaVal;

@property (strong, nonatomic) IBOutlet UIView *topBlock;

- (IBAction)contactGuanJiaEvent:(id)sender;

- (void)renderMyContractViewCellWithContractInfoList:(ContractInfoList *)contractInfoList;
@end
