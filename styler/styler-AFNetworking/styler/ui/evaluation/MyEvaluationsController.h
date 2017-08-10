//
//  MyEvaluationsController.h
//  styler
//
//  Created by wangwanggy820 on 14-4-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEvaluationCell.h"
#import "HeaderView.h"

@interface MyEvaluationsController : UIViewController<UITableViewDataSource, UITableViewDelegate, TapThumbImageDelegate>

@property (weak, nonatomic) IBOutlet UITableView *evaluationsTableView;
@property (strong, nonatomic) NSMutableArray * evaluationsArray;
@property (strong, nonatomic)HeaderView *header;

@end
