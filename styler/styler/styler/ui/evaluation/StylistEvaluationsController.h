//
//  StylistEvaluationsController.h
//  styler
//
//  Created by wangwanggy820 on 14-3-26.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderVIew.h"
#import "Stylist.h"
#import "Evaluation.h"
#import "StylistEvaluationCell.h"

@interface StylistEvaluationsController : UIViewController <UITableViewDataSource, UITableViewDelegate,TapThumbImageDelegate>
{
    NSMutableArray *evaluationArray;
}
@property (weak, nonatomic) IBOutlet UITableView *stylistEvaluationTableView;

@property (strong, nonatomic) HeaderView *header;
@property (retain, nonatomic) Stylist *stylist;
@property (retain, nonatomic) Evaluation *evaluation;
@property (strong, nonatomic) NSMutableArray *evaluationArray;

@end
