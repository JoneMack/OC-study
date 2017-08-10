//
//  EvaluationScoreView.m
//  styler
//
//  Created by wangwanggy820 on 14-3-24.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "EvaluationScoreView.h"
#import "Evaluation.h"
@implementation EvaluationScoreView
{
    UITapGestureRecognizer *tap;
}

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"EvaluationScoreView" owner:self options:nil] objectAtIndex:0];
        [self baseInit];
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame score:(float)score viewMode:(int)viewMode{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    self.score = score;
    self.viewMode = viewMode;
    [self updateStarStatus:self.score viewMode:self.viewMode];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    return self;
}

-(void)baseInit{
    float starWidth = self.frame.size.height;
    float starSpace = starWidth/4;
    if (self.viewMode != evaluation_score_view_mode_editing) {
        starSpace = 0;
    }
    self.viewMode = evaluation_score_view_mode_editing;
    for (int i = 0; i < 5; i++) {
        if (!starImageViews[i]) {
            starImageViews[i] = [[UIImageView alloc] initWithFrame:CGRectMake((starWidth+starSpace)*i, 0, starWidth, starWidth)];
            [self addSubview:starImageViews[i]];
        }
    }
}

-(void)updateStarStatus:(float)score viewMode:(int)viewMode{
    self.score = score;
    self.viewMode = viewMode;
    if (self.viewMode == evaluation_score_view_mode_editing) {
        
        for (int i = 0; i < 5; i++) {
            if (i <= score - 1) {
                starImageViews[i].image = [UIImage imageNamed:@"red_solid_star"];
            }else{
                starImageViews[i].image = [UIImage imageNamed:@"gray_hallow_star"];
            }
        }
        [self setScoreText:(int)self.score];
        if (!tap) {
            tap = [[UITapGestureRecognizer alloc] init];
            tap.delegate = self;
            [self addGestureRecognizer:tap];
        }
        if (!self.scoreTextLabel) {
            self.scoreTextLabel = [[UILabel alloc] init];
            self.scoreTextLabel.frame = CGRectMake(self.frame.size.height * 5, 0, evluation_lable_width, self.frame.size.height);
            self.scoreTextLabel.textColor = [ColorUtils colorWithHexString:gray_text_color];
            self.scoreTextLabel.font = [UIFont systemFontOfSize:default_font_size];
            self.scoreTextLabel.textAlignment = NSTextAlignmentRight;
            self.scoreTextLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:self.scoreTextLabel];
        }
    }else if (self.viewMode == evaluation_score_view_mode_view){  // 发型师
        if(score == 0){
            // 什么也不做
        }else if (score == 5) {  // 金星
            for (int i = 0; i < 5; i++) {
                if (i <= score - 1) {
                    starImageViews[i].image = [UIImage imageNamed:@"gold_solid_star"];
                }
            }
        }else{
            for (int i = 0; i < 5; i++) {  // 不是金星
                if (i <= score - 1) {
                    starImageViews[i].image = [UIImage imageNamed:@"red_solid_star"];
                }else if (i >= score){
                    starImageViews[i].image = [UIImage imageNamed:@"gray_hallow_star"];
                }else if(score-(int)score >= 0.5){
                    starImageViews[i].image = [UIImage imageNamed:@"red_hallow_star"];
                }else{
                    starImageViews[i].image = [UIImage imageNamed:@"gray_hallow_star"];
                }
            }
        }
        
    }else if (self.viewMode == evaluation_score_view_mode_organizaiton){  // 商户
        float starWidth = self.frame.size.height;
        float starSpace = 1;
        
        if(score == 0){
            // 什么也不做
        }else if (score == 5) {  // 金星
            for (int i = 0; i < 5; i++) {
                if (i <= score - 1) {
                    starImageViews[i].image = [UIImage imageNamed:@"gold_solid_star"];
                }
                starImageViews[i].frame = CGRectMake((starWidth+starSpace)*i, 0, starWidth, starWidth);
            }
        }else{
            for (int i = 0; i < 5; i++) {
                if (i <= score - 1) {   
                    starImageViews[i].image = [UIImage imageNamed:@"red_solid_star"];
                }else if (i >= score){
                    starImageViews[i].image = [UIImage imageNamed:@"gray_hallow_star"];
                }else if(score-(int)score >= 0.5){
                    starImageViews[i].image = [UIImage imageNamed:@"red_hallow_star"];
                }else{
                    starImageViews[i].image = [UIImage imageNamed:@"gray_hallow_star"];
                }
                starImageViews[i].frame = CGRectMake((starWidth+starSpace)*i, 0, starWidth, starWidth);
            }
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint point = [touch locationInView:self];
    self.score = (int)(point.x/(score_icon_margin + score_icon_width) + 1);
    if (self.score > 5) {
        self.score = 5;
    }
    [self updateStarStatus:self.score viewMode:self.viewMode];
    return YES;
}

-(void)setScoreText:(int)score
{
    self.scoreTextLabel.text = [Evaluation getScoreText:score];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
