//
//  TableViewCell.m
//  styler
//
//  Created by wangwanggy820 on 14-6-19.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "OrganizationEvaluationCell.h"

#define font_size 11
@implementation OrganizationEvaluationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"OrganizationEvaluationCell" owner:self options:nil] objectAtIndex:0];
        
        [self.avatar addStrokeBorderWidth:0 cornerRadius:self.avatar.frame.size.height/2 color:nil];
        
        self.name.textColor = [ColorUtils colorWithHexString:black_text_color];
        self.name.backgroundColor = [UIColor clearColor];
        self.name.font = [UIFont boldSystemFontOfSize:big_font_size];
        
        self.time.textColor = [ColorUtils colorWithHexString:light_gray_text_color];
        self.time.backgroundColor = [UIColor clearColor];
        self.time.font = [UIFont systemFontOfSize:small_font_size];
        
        self.enviromentLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
        self.enviromentLabel.backgroundColor = [UIColor clearColor];
        self.enviromentLabel.font = [UIFont systemFontOfSize:font_size];
        
        self.trafficLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
        self.trafficLabel.backgroundColor = [UIColor clearColor];
        self.trafficLabel.font = [UIFont systemFontOfSize:font_size];
        
        self.spliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        CGRect frame = self.spliteLine.frame;
        frame.size.height = splite_line_height;
        self.spliteLine.frame = frame;
    }
    return self;
}

-(void)renderUIWithOrganizationEvaluation:(OrganizationEvaluation *)evaluation
{
    [self.avatar setImageWithURL:[NSURL URLWithString:evaluation.avatarUrl] placeholderImage:[UIImage imageNamed:@"user_default_image_before_load@2x"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
    
    self.name.text = evaluation.userName;
    
    //设置评价时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:evaluation.createTime/1000];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"YYYY-MM-dd"];
    self.time.text = [df stringFromDate:date];
    
    [self.environmentScoreView updateStarStatus:evaluation.environmentScore viewMode:evaluation_score_view_mode_view];
    [self.trafficScoreView updateStarStatus:evaluation.trafficScore viewMode:evaluation_score_view_mode_view];
}

@end
