//
//  SimpleEvaluationCell.h
//  styler
//
//  Created by System Administrator on 14-1-21.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluationScoreView.h"
#import "Evaluation.h"

@interface SimpleEvaluationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EvaluationScoreView *scoreView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *evaluationContent;
@property (weak, nonatomic) IBOutlet UILabel *postTime;

-(void)renderContent:(StylistEvaluation *)evaluation;

@end
