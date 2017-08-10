//
//  MyEvaluationCell.h
//  styler
//
//  Created by aypc on 13-12-23.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//


#define detail_score_view_height     75

@protocol TapThumbImageDelegate <NSObject>
-(void)tapThumbImageWith:(id)myEvaluationCell andImageTag:(int)tag;
@end
@protocol bb <NSObject>
-(void)ss;
@end

#import <UIKit/UIKit.h>
#import "EvaluationScoreView.h"
#import "Evaluation.h"

@interface MyEvaluationCell : UITableViewCell
@property (weak, nonatomic) id<TapThumbImageDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *evaluationHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *stylistNameLabel;   //发型师名
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;//商户
@property (weak, nonatomic) IBOutlet UILabel *evaluationContentLabel;//评价内容
@property (weak, nonatomic) IBOutlet UILabel *outOfStack;  //下架状态
@property (weak, nonatomic) IBOutlet EvaluationScoreView *totalScoreView;
@property (weak, nonatomic) IBOutlet UIButton *gotoProfilePageBtn;

@property (weak, nonatomic) IBOutlet UIView *evaluationContentView;
@property (weak, nonatomic) IBOutlet UIImageView *evaluationImage1;
@property (weak, nonatomic) IBOutlet UIImageView *evaluationImage2;
@property (weak, nonatomic) IBOutlet UIImageView *evaluationImage3;
@property (weak, nonatomic) IBOutlet UIImageView *evaluationImage4;
@property (weak, nonatomic) IBOutlet UILabel *timeOfEvaluation;


@property (weak, nonatomic) IBOutlet UIView *topSpliteView;
@property (weak, nonatomic) IBOutlet UIView *detailScoreView;
@property (weak, nonatomic) IBOutlet UIView *bottomSpliteView;

@property (weak, nonatomic) IBOutlet EvaluationScoreView *effectScoreView;
@property (weak, nonatomic) IBOutlet EvaluationScoreView *attitudeScoreView;
@property (weak, nonatomic) IBOutlet EvaluationScoreView *promoteReasonableScoreView;
@property (weak, nonatomic) IBOutlet EvaluationScoreView *trafficConvenientScoreView;
@property (weak, nonatomic) IBOutlet EvaluationScoreView *environmentScoreView;

@property BOOL fold;

@property(weak,nonatomic) UIViewController *controller;
+(CGFloat)getCellHightFor:(Evaluation *)evaluation fold:(BOOL)fold;
-(void)renderUI:(Evaluation*)evaluation fold:(BOOL)flod;
@end
