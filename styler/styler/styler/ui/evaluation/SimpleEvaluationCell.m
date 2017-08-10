//
//  SimpleEvaluationCell.m
//  styler
//
//  Created by System Administrator on 14-1-21.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "SimpleEvaluationCell.h"
#import "Evaluation.h"

@implementation SimpleEvaluationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"SimpleEvaluationCell" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}

-(void) renderContent:(StylistEvaluation *)evaluation
{

    float score = (evaluation.effectScore+evaluation.attitudeScore+evaluation.promoteReasonableScore)/3;
    [self.scoreView updateStarStatus:score viewMode:evaluation_score_view_mode_view];

    
    [self.userName setFont:[UIFont systemFontOfSize:small_font_size]];
    [self.userName setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
    [self.userName setText:evaluation.userName];
    
    NSLog(@">>>evaluation.userName>>>>>>>>>>%@",evaluation.userName);
    
    [self.evaluationContent setFont:[UIFont systemFontOfSize:default_font_size]];
    [self.evaluationContent setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
//    if (evaluation.content != nil) {
        [self.evaluationContent setText:evaluation.content];
//    }
    
    [self.postTime setFont:[UIFont systemFontOfSize:small_font_size]];
    [self.postTime setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:evaluation.createTime/1000];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"YYYY-MM-dd"];
    [self.postTime setText:[df stringFromDate:date]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];
}





@end
