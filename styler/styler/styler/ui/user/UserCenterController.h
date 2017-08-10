//
//  UserCenterController.h
//  styler
//
//  Created by wangwanggy820 on 14-3-6.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Reminder.h"

@interface UserCenterController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *userPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *myEvaluation;
@property (weak, nonatomic) IBOutlet UILabel *evaluationCount;
@property (weak, nonatomic) IBOutlet UIButton *unPostEvaluations;
@property (weak, nonatomic) IBOutlet UIView *evluation;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (nonatomic, strong) NSArray *myOrders;
@property (nonatomic, strong) NSMutableArray *myOrders;

- (IBAction)myEvaluations:(UIButton *)sender;
- (IBAction)moreSetting:(id)sender;

@end
