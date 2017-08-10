//
//  StylistEvaluationCell.h
//  styler
//
//  Created by aypc on 13-12-6.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

@protocol TapThumbImageDelegate <NSObject>
@optional
-(void)tapThumbImageWith:(id)stylistEvaluationCell andImageTag:(int)tag;

@end

#import <UIKit/UIKit.h>
#import "EvaluationScoreView.h"
#import "Evaluation.h"
#import "EvaluationPicture.h"


@interface StylistEvaluationCell : UITableViewCell

@property (weak, nonatomic) id<TapThumbImageDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIView *evaluationHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *evaluationContentLabel;//评价内容

@property (weak, nonatomic) IBOutlet UIView *evaluationImagesView;
@property (strong, nonatomic) IBOutlet UIImageView *evaluationImage1;
@property (strong, nonatomic) IBOutlet UIImageView *evaluationImage2;
@property (strong, nonatomic) IBOutlet UIImageView *evaluationImage3;
@property (strong, nonatomic) IBOutlet UIImageView *evaluationImage4;
@property (weak, nonatomic) IBOutlet UIView *graySeparatorLine;
@property (weak, nonatomic) IBOutlet UILabel *timeOfEvaluation;

@property (weak, nonatomic) IBOutlet UIView *detailScoreView;
@property (weak, nonatomic) IBOutlet UIView *separotorView;

@property (weak, nonatomic) IBOutlet EvaluationScoreView *effectScoreView;
@property (weak, nonatomic) IBOutlet EvaluationScoreView *attitudeScoreView;
@property (weak, nonatomic) IBOutlet EvaluationScoreView *promoteReasonableScoreView;

@property (weak, nonatomic) IBOutlet EvaluationScoreView *totalScoreView;//平均分

@property (strong, nonatomic) UIView *upLine;

+(CGFloat)getCellHightFor:(StylistEvaluation *)evaluation andBold:(BOOL)bold;
-(void)loadUIForDic:(StylistEvaluation*)evaluation andBold:(BOOL)bold;
-(void)renderUpline:(BOOL)showLine;

@end
