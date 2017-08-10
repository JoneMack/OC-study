//
//  OrganizationCell.m
//  styler
//
//  Created by wangwanggy820 on 14-4-26.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "OrganizationCell.h"
#define more_hdc_label_width 100
#define right_arrow_img_width 20
#define right_arrow_img_left_space 185

@implementation OrganizationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"OrganizationCell" owner:self options:nil] objectAtIndex:0];
        
        self.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
        
        self.organizationName.font = [UIFont boldSystemFontOfSize:default_font_size];
        self.organizationName.textColor = [ColorUtils colorWithHexString:white_text_color];
        self.organizationName.backgroundColor = [UIColor clearColor];
        self.organizationName.shadowColor = [ColorUtils colorWithHexString:black_text_color];
        
        
        self.scoreView.backgroundColor = [UIColor clearColor];
        
        self.distance.font = [UIFont systemFontOfSize:organization_font_size];
        self.distance.textColor = [ColorUtils colorWithHexString:white_text_color];
        self.distance.backgroundColor = [UIColor clearColor];
        
        self.organizationName.shadowColor = [ColorUtils colorWithHexString:black_text_color];
        
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)renderOrganization:(Organization *)organization hdcs:(NSArray *)hdcs
{
    for (UIView *theHdcView in self.hdcsView.subviews) {
        [theHdcView removeFromSuperview];
    }
    NSString *urlStr;
    for (Picture *picture in organization.pictures) {
        if (picture.coverPictureFlag) {
            urlStr = picture.picUrl;
            break;
        }
    }
    
    [self.coverPicture setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"brand_default_image_before_load"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
    self.coverPicture.contentMode = UIViewContentModeScaleAspectFill;
    
    
    //机构名
    self.organizationName.text = [organization getOrganizationName];
    
    //机构评分
    float avgScore = [organization getEvaluationAvgScore];
    [self.scoreView updateStarStatus:avgScore viewMode:evaluation_score_view_mode_organizaiton];
    
    if (organization.distance == 0) {
        self.distance.hidden = YES;
    }else{
        self.distance.text = [organization getDistanceTxt];
    }
    
    //设置美发卡容器视图的frame和背景
    self.hdcsView.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    float y = self.coverPicture.frame.size.height;
    float height = [OrganizationCell getHdcsHeight:hdcs];
    self.hdcsView.frame = CGRectMake(organization_cell_left_point, y, organization_cell_width, height);

   

    y = 0;
    float hdcViewWidth = organization_cell_width - 2*splite_line_height;
    float hdcViewX = splite_line_height;
    
    //获取推荐的美发卡数组
    NSArray *recommendHdcs = [HairDressingCard getRecommendHdcs:hdcs];
    
    for (int i = 0; i < recommendHdcs.count; i++)
    {
        y = i*organization_hdc_height + i*splite_line_height;
        HairDressingCard *hdc = recommendHdcs[i];
        hdcView = [[OrgHdcView alloc] initWithFrame:CGRectMake(hdcViewX, y, hdcViewWidth, organization_hdc_height) hdc:hdc displayScene:display_in_organization_list];
        hdcView.backgroundColor = [UIColor whiteColor];
        CGRect frame = CGRectMake(hdcViewX, y, hdcViewWidth, organization_hdc_height);
        hdcView.frame = frame;
        [self.hdcsView addSubview:hdcView];
    }
    
//    if (hdcs.count > recommendHdcs.count)
//    {
    UIView *moreView = [[UIView alloc] init];
    if (recommendHdcs.count > 0) {
        moreView.frame = CGRectMake(splite_line_height, y+organization_hdc_height+splite_line_height, hdcViewWidth, organization_more_hdc_height);
    }else if (recommendHdcs.count == 0){
        moreView.frame = CGRectMake(splite_line_height, y, hdcViewWidth, organization_more_hdc_height);
    
    }
        moreView.backgroundColor = [UIColor whiteColor];
        
       
        UILabel *moreLab=[[UILabel alloc]initWithFrame:CGRectMake(splite_line_height, 0, hdcViewWidth-right_arrow_img_width, organization_more_hdc_height)];
        moreLab.text=@"选择发型师查看详情";
        moreLab.backgroundColor=[UIColor whiteColor];
        moreLab.font = [UIFont systemFontOfSize:smallest_font_size];
        moreLab.textAlignment = NSTextAlignmentCenter;
        moreLab.textColor = [ColorUtils colorWithHexString:light_gray_text_color];
        [moreView addSubview:moreLab];
        
        UIImageView *moreImgView=[[UIImageView alloc] initWithFrame:CGRectMake(hdcViewX+right_arrow_img_left_space, 0, right_arrow_img_width, right_arrow_img_width)];
        moreImgView.image=[UIImage imageNamed:@"right_arrow@2x.png"];
        [moreView addSubview:moreImgView];
        
        [self.hdcsView addSubview:moreView];
        
        
//    }

}

+(float)getCellHeight:(NSArray *)hdcs{
    float hdcsHeight = [OrganizationCell getHdcsHeight:hdcs];
    return hdcsHeight + organization_cell_space + organization_headImg_height;

}

+(float) getHdcsHeight:(NSArray *)hdcs{
    NSArray *recommendHdcs = [HairDressingCard getRecommendHdcs:hdcs];
//    if (hdcs.count > recommendHdcs.count && recommendHdcs.count > 0) {
        return recommendHdcs.count*organization_hdc_height + organization_more_hdc_height + (recommendHdcs.count+1)*splite_line_height;
//    }else if(hdcs.count == recommendHdcs.count && recommendHdcs.count > 0){
//        return recommendHdcs.count*(organization_hdc_height + splite_line_height);
//    }
//    
//    return 0;
}

@end
