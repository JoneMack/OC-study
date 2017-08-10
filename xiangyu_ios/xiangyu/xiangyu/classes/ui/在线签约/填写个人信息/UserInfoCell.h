//
//  UserInfoCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/18.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerInfo.h"

@interface UserInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *userName;

@property (strong, nonatomic) IBOutlet UIButton *man;

@property (strong, nonatomic) IBOutlet UIButton *woman;

@property (strong, nonatomic) IBOutlet UITextField *mobile;


@property (strong, nonatomic) IBOutlet UITextField *idNo;

@property (strong, nonatomic) IBOutlet UITextField *confirmIdNo;

@property (strong, nonatomic) IBOutlet UITextField *emergencyContactName;

@property (strong, nonatomic) IBOutlet UITextField *emergencyContactPhone;

@property (strong, nonatomic) IBOutlet UITextField *contactRelation;

@property (strong, nonatomic) CustomerInfo *customerInfo;


- (IBAction)manEvent:(id)sender;

- (IBAction)womanEvent:(id)sender;

-(void) renderCustomerData:(CustomerInfo *) customerInfo;


-(NSString *)getSex;


@end
