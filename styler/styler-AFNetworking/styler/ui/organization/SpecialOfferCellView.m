//
//  SpecialOfferCell.m
//  styler
//
//  Created by 冯聪智 on 14-9-25.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//


#define special_offer_list_cell_height   105
#define special_offer_list_cell_height_with_show_more 128
#define special_offer_list_left_margin   10
#define special_offer_list_right_margin  10
#define hdc_card_margin                  5


#import "SpecialOfferCellView.h"
#import "UILabel+Custom.h"
#import "HdcCardView.h"
#import "Organization.h"
#import "HairDressingCard.h"
#import "EvaluationScoreView.h"


@implementation SpecialOfferCellView
{
//    NSMutableArray *hdcCards;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(id) initWithOrganizationAndHdcs:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier organization:(Organization *)organization hdcType:(int)hdcType showMoreFlag:(int)showMoreFlag{
                                                                     
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.showMoreFlag = showMoreFlag;
        self.organization = organization;
        self.moreHdcCardsView = [[NSMutableArray alloc] init];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //cell 顶部间距
        self.topMarginBlock = [[UIView alloc] init];
        self.topMarginBlock.frame = CGRectMake(0, 0, screen_width, 10);
        self.topMarginBlock.backgroundColor = [ColorUtils colorWithHexString:light_gray_color];
        [self addSubview:self.topMarginBlock];
        
        //cell的顶部分隔线:
        self.topLineView = [[UIView alloc] init];
        self.topLineView.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        self.topLineView.frame = CGRectMake(0, 10, screen_width,  splite_line_height);
        [self addSubview:self.topLineView];
        
        // 品牌名
        self.brandLable = [UILabel new];
        [self.brandLable setTextColor:[ColorUtils colorWithHexString:black_text_color]];
        [self.brandLable setFont:[UIFont systemFontOfSize:default_2_font_size]];
        CGRect frame = CGRectMake(special_offer_list_left_margin, self.topLineView.frame.origin.y+10, 200, 15);
        self.brandLable.frame = frame;
        [self addSubview:self.brandLable];
        
        // 评星
        self.scoreView = [[EvaluationScoreView alloc] initWithFrame:frame score:[organization getEvaluationAvgScore]
                                                           viewMode:evaluation_score_view_mode_organizaiton];
        [self addSubview:self.scoreView];
        
        // 距离
        self.distanceLabel = [UILabel new];
        [self.distanceLabel setFont:[UIFont systemFontOfSize:default_2_font_size]];
        float distancelLabelX = screen_width - special_offer_list_right_margin - self.distanceLabel.realWidth;
        self.distanceLabel.frame = CGRectMake(distancelLabelX, self.topLineView.frame.origin.y+10, self.distanceLabel.realWidth, 15);
        [self addSubview:self.distanceLabel];

        // 机构图
        float coverHeight = hdc_card_info_height;
        float coverWidth = coverHeight*2;
        float displayWidth = 70;
        self.coverWrapper = [UIView new];
        self.coverWrapper.frame = CGRectMake(special_offer_list_left_margin, self.brandLable.frame.origin.y+20, displayWidth, coverHeight);
        self.coverWrapper.clipsToBounds = YES;
        [self addSubview:self.coverWrapper];
        
        self.organizationCoverPicture = [[UIImageView alloc] init];
        frame = CGRectMake(0-(coverWidth-displayWidth)/2, 0, coverWidth, coverHeight);
        self.organizationCoverPicture.frame = frame;
        [self.coverWrapper addSubview:self.organizationCoverPicture];
        
//        // 美发卡信息
//        float baseHdcX = special_offer_list_left_margin + self.coverWrapper.frame.size.width + 10;
//        float hdcCardWidth = screen_width - baseHdcX - special_offer_list_right_margin;
//        self.firstHdcCardView = [[HdcCardView alloc] initWithHdc:hdcCardWidth hairDressingCard:[organization getFistDisplayHairDressingCard:hdcType]];
//        frame = CGRectMake(baseHdcX, self.brandLable.frame.origin.y+20, hdcCardWidth, hdc_card_info_height);
//        self.firstHdcCardView.frame = frame;
//        [self addSubview:self.firstHdcCardView];
        
        NSString *showMoreTxt = @"查看更多优惠";
        NSString *showMoreIcon = @"double_arrow_down_icon";
        
        // 查看更多的分隔线 , 根据最后一个卡片获取
        HdcCardView *card = [self.moreHdcCardsView lastObject];
        self.showMoreLine = [[UIView alloc] init];
        self.showMoreLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        self.showMoreLine.frame = CGRectMake(self.organizationCoverPicture.frame.origin.x,
                                             card.frame.origin.y + card.frame.size.height+10,
                                             screen_width-special_offer_list_left_margin-special_offer_list_right_margin,
                                             splite_line_height);
        [self addSubview:self.showMoreLine];
        
        // 查看更多文本
        self.showMoreButton = [[UIButton alloc] init];
//        self.showMoreButton.backgroundColor = [UIColor purpleColor];
        [self.showMoreButton setTitle:showMoreTxt forState:UIControlStateNormal];
        [self.showMoreButton setImage:[UIImage imageNamed:showMoreIcon] forState:UIControlStateNormal];
        self.showMoreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [self.showMoreButton setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
        self.showMoreButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.showMoreButton.titleLabel setFont:[UIFont systemFontOfSize:small_font_size]];
        self.showMoreButton.frame = CGRectMake(special_offer_list_left_margin, self.showMoreLine.frame.origin.y-0.5, self.showMoreLine.frame.size.width, 25);
        [self addSubview:self.showMoreButton];
        
        
        [self.showMoreButton addTarget:self action:@selector(showOrHideMoreSpecialOffer) forControlEvents:UIControlEventTouchUpInside];

        
        //底部分隔线:
        self.bottomLineView = [[UIView alloc] init];
        self.bottomLineView.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        float bottomLineY = [SpecialOfferCellView getHeightByHdcs:organization.hdcs showMoreFlag:showMoreFlag]-0.5;
        self.bottomLineView.frame = CGRectMake(0, bottomLineY, screen_width,  splite_line_height);
        [self addSubview:self.bottomLineView];
    }
    return self;
}

-(void)renderData:(Organization *)organization hdcType:(int)hdcType showMoreFlag:(int)showMoreFlag{

    self.showMoreFlag = showMoreFlag;
    self.organization = organization;
    // 先清除旧的更多美发卡 , 防止cell数据重用
    if( self.moreHdcCardsView.count != 0){
        for (UIView *view in self.moreHdcCardsView) {
            [view removeFromSuperview];
        }
    }
    
    // 品牌名 分店名
    self.brandLable.text = [NSString stringWithFormat:@"%@  %@", organization.brandName,organization.storeName ];
    
    // 评分
    CGRect frame = CGRectMake(self.brandLable.realWidth+self.brandLable.frame.origin.x+10, self.topLineView.frame.origin.y+10, 80, 15);
    [self.scoreView updateStarStatus:[organization getEvaluationAvgScore] viewMode:evaluation_score_view_mode_organizaiton];
    self.scoreView.frame = frame;
    
    // 距离
    self.distanceLabel.text = organization.getDistanceTxt;
    float distancelLabelX = screen_width - special_offer_list_right_margin - self.distanceLabel.realWidth;
    self.distanceLabel.frame = CGRectMake(distancelLabelX, self.topLineView.frame.origin.y+10, self.distanceLabel.realWidth, 15);
    
    // 验证评分的宽度是否覆盖了距离，如果覆盖了，调整品牌名和分店名的宽度
    float coverWidth = self.scoreView.frame.origin.x + self.scoreView.frame.size.width - self.distanceLabel.frame.origin.x ;
    if(coverWidth > 0){
        // 调整品牌Label的宽度
        CGRect frame = self.brandLable.frame;
        frame.size.width = self.brandLable.realWidth - coverWidth;
        self.brandLable.frame = frame;
        // 调整评价的位置
        frame = self.scoreView.frame;
        frame.origin.x = frame.origin.x - coverWidth -5 ;
        self.scoreView.frame = frame;
    }
    
    // 机构图
    Picture *picture = organization.getCoverPicture;
    [self.organizationCoverPicture setImageWithURL:[NSURL URLWithString:picture.picUrl] placeholderImage:[UIImage imageNamed:@"brand_default_image_before_load"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
    
    // 美发卡信息
    float baseHdcX = special_offer_list_left_margin + self.coverWrapper.frame.size.width + 10;
    float hdcCardWidth = screen_width - baseHdcX - special_offer_list_right_margin;
    HairDressingCard *firstHairDressingCard = [organization getFistDisplayHairDressingCard:hdcType];
    HdcCardView *firstHdcCardView = [[HdcCardView alloc] initWithHdc:hdcCardWidth hairDressingCard:firstHairDressingCard];
    frame = CGRectMake(baseHdcX, self.brandLable.frame.origin.y+20, hdcCardWidth, hdc_card_info_height);
    firstHdcCardView.frame = frame;
    [self addSubview:firstHdcCardView];
    [self.moreHdcCardsView addObject:firstHdcCardView];
    
    if (self.showMoreFlag == show_more_none) {
        self.showMoreLine.hidden = YES;
        self.showMoreButton.hidden = YES;
        self.showMoreButton.titleLabel.hidden=YES;
    }else{
        self.showMoreButton.hidden = NO;
        self.showMoreButton.titleLabel.hidden=NO;
        self.showMoreLine.hidden = NO;
    }
    
    if (showMoreFlag > show_more_none) {
        NSString *showMoreTxt = @"查看更多优惠";
        NSString *showMoreIcon = @"double_arrow_down_icon.png";
        
        if (showMoreFlag == show_more_cards) {
            showMoreTxt = @"收起";
            showMoreIcon = @"double_arrow_up_icon.png";
            //显示更多美发卡
            
            for (int i=0 ; i<organization.hdcs.count ; i++) {
                HairDressingCard *nextHairDressingCard = organization.hdcs[i] ;
                if (firstHairDressingCard != nextHairDressingCard) {
                    float hdcCardY = 100;  // 默认y坐标
                    if (self.moreHdcCardsView.count >1) {  // 每添加一次，重新计算y坐标
                        HdcCardView *card = [self.moreHdcCardsView lastObject];
                        hdcCardY = card.frame.origin.y + card.frame.size.height + hdc_card_margin;
                    }
                    
                    float baseHdcX = special_offer_list_left_margin + self.coverWrapper.frame.size.width + 10;
                    float hdcCardWidth = screen_width - baseHdcX - special_offer_list_right_margin;
                    HdcCardView *hdcCardView = [[HdcCardView alloc] initWithHdc:hdcCardWidth
                                                               hairDressingCard:nextHairDressingCard];
                    frame = CGRectMake(baseHdcX, hdcCardY, hdcCardWidth, hdc_card_info_height);
                    hdcCardView.frame = frame;
                    [self addSubview:hdcCardView];
                    [self.moreHdcCardsView addObject:hdcCardView];
                }
            }
        }
        
        // 查看更多的分隔线 , 根据最后一个卡片获取
        HdcCardView *card = [self.moreHdcCardsView lastObject];

        self.showMoreLine.frame = CGRectMake(special_offer_list_left_margin,
                                             card.frame.origin.y + card.frame.size.height+10,
                                             screen_width-special_offer_list_left_margin-special_offer_list_right_margin,
                                             splite_line_height);
        
        // 查看更多文本
        [self.showMoreButton setTitle:showMoreTxt forState:UIControlStateNormal];
        [self.showMoreButton setImage:[UIImage imageNamed:showMoreIcon] forState:UIControlStateNormal];
        self.showMoreButton.frame = CGRectMake(special_offer_list_left_margin, self.showMoreLine.frame.origin.y-0.5, self.showMoreLine.frame.size.width, 25);
    }
    
    //底部分隔线:
    float bottomLineY = [SpecialOfferCellView getHeightByHdcs:organization.hdcs showMoreFlag:showMoreFlag]-0.5;
    self.bottomLineView.frame = CGRectMake(0, bottomLineY, screen_width,  splite_line_height);
}

-(void) showOrHideMoreSpecialOffer{
    
    if (self.moreHdcCardsView.count> 0) {
        for (UIView *view in self.moreHdcCardsView) {
            [view removeFromSuperview];
        }
    }
    // 通知代理 显示或隐藏更多美发卡
    if ([self.delegate respondsToSelector:@selector(showOrHideMoreHdcs:)]) {
        [self.delegate showOrHideMoreHdcs:self.organization.id];
    }
}


+(float) getHeightByHdcs:(NSArray *)hdcs showMoreFlag:(int)showMoreFlag{
    
    if (showMoreFlag == show_more_none) {
        return special_offer_list_cell_height;
        
    }else if (showMoreFlag == show_more_txt) {
        return special_offer_list_cell_height_with_show_more;
        
    }else if (showMoreFlag == show_more_cards) {
        
        return special_offer_list_cell_height_with_show_more
                    +(hdcs.count-1)*hdc_card_info_height   // 更多中卡片的高度
                    +(hdcs.count-1)*hdc_card_margin;   // 卡片之间的间距
    }
    return 0;
}


@end
