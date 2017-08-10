//
//  OrganizationSpecialOfferListSectionHeaderView.m
//  styler
//
//  Created by 冯聪智 on 14-10-21.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define special_offer_list_cell_height   105
#define special_offer_list_cell_height_with_show_more 128
#define special_offer_list_left_margin   10
#define special_offer_list_right_margin  10
#define hdc_card_margin                  5

#import "OrganizationSpecialOfferListSectionHeaderView.h"
#import "UILabel+Custom.h"

@implementation OrganizationSpecialOfferListSectionHeaderView

-(id) initWithOrganization:(Organization *)organization identifier:(NSString *)identifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        self.frame = CGRectMake(0, 0, screen_width, 31);
        [self setBackgroundColor:[UIColor whiteColor]];
        
        //cell的顶部分隔线:
        self.topLineView = [[UIView alloc] init];
        self.topLineView.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        self.topLineView.frame = CGRectMake(0, 0, screen_width,  splite_line_height);
        [self addSubview:self.topLineView];
        
        // 品牌名
        self.brandLable = [UILabel new];
        [self.brandLable setTextColor:[ColorUtils colorWithHexString:black_text_color]];
        [self.brandLable setFont:[UIFont systemFontOfSize:default_2_font_size]];
        CGRect frame = CGRectMake(special_offer_list_left_margin, self.topLineView.frame.origin.y+10, 200, 15);
        self.brandLable.frame = frame;
        [self addSubview:self.brandLable];
        
        // 距离
        self.distanceLabel = [UILabel new];
        [self.distanceLabel setFont:[UIFont systemFontOfSize:default_2_font_size]];
        float distancelLabelX = screen_width - special_offer_list_right_margin - self.distanceLabel.realWidth;
        self.distanceLabel.frame = CGRectMake(distancelLabelX, self.topLineView.frame.origin.y+10, self.distanceLabel.realWidth, 15);
        [self addSubview:self.distanceLabel];
        
        // 评星
        self.scoreView = [[EvaluationScoreView alloc] initWithFrame:frame score:[organization getEvaluationAvgScore]
                                                           viewMode:evaluation_score_view_mode_organizaiton];
        frame = self.scoreView.frame;
        frame.origin.x = self.distanceLabel.frame.origin.x + 15 + frame.size.width;
        self.scoreView.frame = frame;
        [self addSubview:self.scoreView];
    }
    return self;
}

-(void) renderSectionUI:(Organization *)organization{
    // 品牌名 分店名
    self.brandLable.text = [NSString stringWithFormat:@"%@  %@", organization.businessCirclesName,[organization getBrandName] ];
    
    // 距离
    self.distanceLabel.text = organization.getDistanceTxt;
    float distancelLabelX = screen_width - special_offer_list_right_margin - self.distanceLabel.realWidth;
    self.distanceLabel.frame = CGRectMake(distancelLabelX, self.topLineView.frame.origin.y+10, self.distanceLabel.realWidth, 15);
    
    // 评分
    CGRect frame = CGRectMake(self.distanceLabel.frame.origin.x-5 - 80, self.topLineView.frame.origin.y+10, 80, 15);
    [self.scoreView updateStarStatus:[organization getEvaluationAvgScore] viewMode:evaluation_score_view_mode_organizaiton];
    self.scoreView.frame = frame;
    
    float coverWidth = self.brandLable.frame.origin.x + self.brandLable.realWidth+5 - self.scoreView.frame.origin.x;
    if(coverWidth>0 ){
        // 调整品牌Label的宽度
        CGRect frame = self.brandLable.frame;
        frame.size.width = self.brandLable.realWidth - coverWidth;
        self.brandLable.frame = frame;
    }
}
@end
