//
//  TableViewCell.h
//  styler
//
//  Created by wangwanggy820 on 14-6-19.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluationScoreView.h"
#import "UIView+Custom.h"
#import "Evaluation.h"

@interface OrganizationEvaluationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *enviromentLabel;
@property (weak, nonatomic) IBOutlet UILabel *trafficLabel;
@property (weak, nonatomic) IBOutlet EvaluationScoreView *environmentScoreView;
@property (weak, nonatomic) IBOutlet EvaluationScoreView *trafficScoreView;
@property (weak, nonatomic) IBOutlet UIView *spliteLine;

-(void)renderUIWithOrganizationEvaluation:(OrganizationEvaluation *)evaluation;

@end
