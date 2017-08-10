//
//  OrganizationController.h
//  styler
//
//  Created by wangwanggy820 on 14-6-19.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationEvaluationCell.h"
#import "HeaderView.h"
#import "UIViewController+Custom.h"
#import "LoadingStatusView.h"

@interface OrganizationEvaluationController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) HeaderView *header;
@property int organizationId;

-(id)initWithOrganizationId:(int)organizationId;

@end
