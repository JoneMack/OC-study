//
//  EvaluationScoreView.h
//  styler
//
//  Created by wangwanggy820 on 14-3-24.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define score_icon_width 24
#define score_icon_margin 5
#define left_space 40
#define evluation_lable_width 100

#define evaluation_score_view_mode_editing       1 //编辑模式
#define evaluation_score_view_mode_view          2 //阅读模式
#define evaluation_score_view_mode_organizaiton  3 //机构评分

@interface EvaluationScoreView : UIView<UIGestureRecognizerDelegate>
{
    UIImageView *starImageViews[5];
}
@property (strong, nonatomic) UILabel *scoreTextLabel;
@property float score;
@property int viewMode;

-(id)initWithFrame:(CGRect)frame score:(float)score viewMode:(int)viewMode;
-(void)updateStarStatus:(float) score viewMode:(int) viewMode;

@end
