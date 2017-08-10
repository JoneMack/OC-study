//
//  MyOrderCell.h
//  styler
//
//  Created by System Administrator on 13-6-15.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceOrder.h"
#import "MyOrderController.h"
#import "UIView+Custom.h"

#define order_cell_height 80


@interface MyOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *avatarWrapper;
@property (weak, nonatomic) IBOutlet UIImageView *stylistAvatar;
@property (weak, nonatomic) IBOutlet UILabel *organizationName;
@property (weak, nonatomic) IBOutlet UIView *grayLine;

@property (weak, nonatomic) IBOutlet UILabel *stylistName;
@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UIButton *operateBtn;
@property (weak, nonatomic) IBOutlet UIButton *evaluationBtn;

@property (weak, nonatomic) ServiceOrder * order;
@property (strong, nonatomic) MyOrderController *controller;

- (IBAction)operatorAction:(id)sender;

-(void)renderOrderView:(ServiceOrder *)order;

@end
