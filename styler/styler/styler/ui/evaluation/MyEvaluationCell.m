//
//  MyEvaluationCell.m
//  styler
//
//  Created by aypc on 13-12-23.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "MyEvaluationCell.h"
#import "ImageUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "StylistProfileController.h"
#import "UIView+Custom.h"
#import "NSStringUtils.h"

#define stylist_name_top_margin 12
#define item_margin 2
#define evaluation_content_width 250
#define evaluation_avatar_width 40

#define general_origin_x             55
#define time_label_height            21
#define evaluation_image_height      55
#define evuluation_content_origin_y  50
#define left_star_origin_x           112
#define rigit_star_origin_x          242
#define star_origin_y                5
#define star_space_height            22
#define score_view_frame_origin(x,y) CGRectMake(x, y, 70, 20)
#define space_margin 10

@implementation MyEvaluationCell
{
    UITapGestureRecognizer *tap[4];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyEvaluationCell" owner:self options:nil] objectAtIndex:0];
    }
    self.userInteractionEnabled = YES;
    #pragma mark ------ 头部部分 -------
    //初始化评价头部
    CGRect headerFrame = self.evaluationHeaderView.frame;
    headerFrame.size.height = [MyEvaluationCell headerHeight];
    self.evaluationHeaderView.frame = headerFrame;

    //初始化发型师的头像
    CGRect avatarFrame = self.avatarImageVIew.frame;
    avatarFrame.origin.x = general_padding;
    avatarFrame.origin.y = general_padding;
    avatarFrame.size.height = evaluation_avatar_width;
    self.avatarImageVIew.frame = avatarFrame;
    self.avatarImageVIew.layer.masksToBounds = YES;
    self.avatarImageVIew.layer.cornerRadius = self.avatarImageVIew.frame.size.width/2;
    
    //初始化发型师名字
    CGRect stylistNameFrame = self.stylistNameLabel.frame;
    stylistNameFrame.origin.x = avatarFrame.origin.x + avatarFrame.size.width + general_padding;
    stylistNameFrame.origin.y = stylist_name_top_margin;
    stylistNameFrame.size.height = default_txt_height;
    self.stylistNameLabel.frame = stylistNameFrame;
    self.stylistNameLabel.font = [UIFont systemFontOfSize:big_font_size];
    self.stylistNameLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
    
    //初始化发型师商户名
    CGRect orgNameFrame = self.orgNameLabel.frame;
    orgNameFrame.origin.y = self.stylistNameLabel.frame.origin.y + self.stylistNameLabel.frame.size.height+item_margin;
    orgNameFrame.origin.x = self.stylistNameLabel.frame.origin.x;
    orgNameFrame.size.height = default_txt_height;
    self.orgNameLabel.frame = orgNameFrame;
    self.orgNameLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.orgNameLabel.font = [UIFont systemFontOfSize:default_font_size];
    self.orgNameLabel.backgroundColor = [UIColor clearColor];
    
    #pragma mark ------ 内容部分 -------
    //初始化评价内容
    CGRect evaluationTxtFrame = self.evaluationContentLabel.frame;
    evaluationTxtFrame.origin.x = self.orgNameLabel.frame.origin.x;
    self.evaluationContentLabel.frame = evaluationTxtFrame;
    self.evaluationContentLabel.textColor = [ColorUtils colorWithHexString:light_gray_text_color];
    self.evaluationContentLabel.backgroundColor = [UIColor clearColor];
    self.evaluationContentLabel.numberOfLines = 0;
    self.evaluationContentLabel.font = [UIFont systemFontOfSize:default_font_size];
    //评论时间
    self.timeOfEvaluation.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.timeOfEvaluation.backgroundColor = [UIColor clearColor];
    
    #pragma mark ------ 详细评分 -------
    //评分区域的上分割线
    CGRect frame = self.topSpliteView.frame;
    frame.origin.x = 55;
    frame.origin.y = 0;
    frame.size.height = splite_line_height;
    frame.size.width = screen_width - frame.origin.x;
    self.topSpliteView.frame = frame;
    self.topSpliteView.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    
    //详细评分
    frame = self.detailScoreView.frame;
    frame.size.height = detail_score_view_height-splite_line_height;
    self.detailScoreView.frame = frame;
    self.detailScoreView.backgroundColor = [UIColor clearColor];
    
    #pragma mark ------ 单元格分割线 -------
    frame = self.bottomSpliteView.frame;
    frame.origin.x = 0;
    frame.size.height = splite_line_height;
    frame.size.width = screen_width - frame.origin.x;
    self.bottomSpliteView.frame = frame;
    self.bottomSpliteView.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    //设置下架状态
    self.outOfStack.backgroundColor = [ColorUtils colorWithHexString:gray_text_color];
    self.outOfStack.textColor = [UIColor whiteColor];
    self.outOfStack.font = [UIFont systemFontOfSize:default_font_size];
    [self.outOfStack addStrokeBorderWidth:splite_line_height cornerRadius:2 color:[UIColor whiteColor]];
    self.outOfStack.hidden = YES;
    self.outOfStack.alpha = 0.8;
    return self;
}

-(void)renderUI:(Evaluation *)evaluation fold:(BOOL)flod
{
    
    #pragma mark ------ 头部部分 -------
    //设置头像
    
    [self.avatarImageVIew setImageWithURL:[NSURL URLWithString:evaluation.stylistEvaluation.stylist.avatarUrl] placeholderImage:[UIImage imageNamed:@"stylist_default_image_before_load"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
    
    //设置发型师名字
    self.stylistNameLabel.text = evaluation.stylistEvaluation.stylist.name;
    //设置商户名字
    self.orgNameLabel.text = evaluation.stylistEvaluation.stylist.organization.name;
    //设置平均分
    [self.totalScoreView updateStarStatus:(evaluation.stylistEvaluation.effectScore+evaluation.stylistEvaluation.attitudeScore+evaluation.stylistEvaluation.promoteReasonableScore+evaluation.organizationEvaluation.trafficScore+evaluation.organizationEvaluation.environmentScore)/5 viewMode:evaluation_score_view_mode_view];
    
    #pragma mark ------ 内容部分 -------
    //评价内容部分，包含文字内容、图片内容及评价时间
    CGRect evaluationContentFrame = self.evaluationContentView.frame;
    evaluationContentFrame.origin.y = self.evaluationHeaderView.frame.origin.y+self.evaluationHeaderView.frame.size.height;
    evaluationContentFrame.size.height = [MyEvaluationCell contentHeight:evaluation.stylistEvaluation];
    self.evaluationContentView.frame = evaluationContentFrame;
    //渲染评价内容及布局
    self.evaluationContentLabel.text = evaluation.stylistEvaluation.content;
    CGRect evaluationTxtFrame = self.evaluationContentLabel.frame;
    evaluationTxtFrame.origin.y = 0;
    evaluationTxtFrame.size.width = evaluation_content_width;
    evaluationTxtFrame.size.height = [MyEvaluationCell txtContentHeight:evaluation.stylistEvaluation];
    self.evaluationContentLabel.frame = evaluationTxtFrame;
    //渲染评价图片内容
    [self renderImgContent:evaluation.stylistEvaluation.evaluationPictures];
    //设置评价时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:evaluation.stylistEvaluation.createTime/1000];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"YYYY-MM-dd"];
    self.timeOfEvaluation.text = [df stringFromDate:date];
    CGRect timeEvuluationFrame = self.timeOfEvaluation.frame;
    timeEvuluationFrame.origin.y = [MyEvaluationCell contentHeight:evaluation.stylistEvaluation] - time_label_height - splite_line_height;
    self.timeOfEvaluation.frame = timeEvuluationFrame;
    
    #pragma mark ------ 详细评分视图 -------
    //渲染详细评分
    [self renderDetailScoreView:evaluation];
    
    #pragma mark ------ 单元格分割线 -------
    CGRect frame = self.bottomSpliteView.frame;
    //收拢状态
    if (flod) {
        frame.origin.y = self.evaluationContentView.frame.origin.y + self.evaluationContentView.frame.size.height;
    }
    //展开状态
    else{
        frame.origin.y = self.detailScoreView.frame.origin.y + self.detailScoreView.frame.size.height;
    }
    self.bottomSpliteView.frame = frame;
    
    //设置下架的位置
    frame = self.outOfStack.frame;
    CGSize size = [self.stylistNameLabel.text sizeWithFont:self.stylistNameLabel.font constrainedToSize:CGSizeMake(screen_width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    frame.origin.x = self.stylistNameLabel.frame.origin.x + size.width + general_padding;
    self.outOfStack.frame = frame;
    
    //对发型师的下架状态做设置
    if (evaluation.stylistEvaluation.stylist.dataStatus == stylist_data_status_open) {
        self.outOfStack.hidden = YES;
        self.gotoProfilePageBtn.enabled = YES;
        self.avatarImageVIew.alpha = 1;
        self.stylistNameLabel.alpha = 1;
        self.orgNameLabel.alpha = 1;
    }else{
        self.outOfStack.hidden = NO;
        self.gotoProfilePageBtn.enabled = NO;
        self.avatarImageVIew.alpha = 0.6;
        self.stylistNameLabel.alpha = 0.6;
        self.orgNameLabel.alpha = 0.6;
    }
}

+(float)headerHeight{
    return general_padding + evaluation_avatar_width;
}

+(float)txtContentHeight:(StylistEvaluation *)evaluation{
    if ([evaluation hasContent]) {
        CGSize contentSize = [evaluation.content sizeWithFont:[UIFont systemFontOfSize:default_font_size] constrainedToSize:CGSizeMake(evaluation_content_width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        return contentSize.height;
    }else{
        return 0;
    }
}

+(float)contentHeight:(StylistEvaluation *)evaluation{
    float txtHeight = [self txtContentHeight:evaluation];
    float imgHeight = evaluation.evaluationPictures.count>0?(evaluation_image_height +general_padding/2):0;
    float timeHeight = time_label_height + general_padding/2;
    return txtHeight + imgHeight + timeHeight;
}

-(void)renderDetailScoreView :(Evaluation *)evaluation
{
    CGRect frame = self.detailScoreView.frame;
    frame.origin.y = self.evaluationContentView.frame.origin.y + self.evaluationContentView.frame.size.height;
    self.detailScoreView.frame = frame;
    
    [self.effectScoreView updateStarStatus:(int)evaluation.stylistEvaluation.effectScore viewMode:evaluation_score_view_mode_view];
    [self.attitudeScoreView updateStarStatus:(int)evaluation.stylistEvaluation.attitudeScore viewMode:evaluation_score_view_mode_view];
    [self.promoteReasonableScoreView updateStarStatus:(int)evaluation.stylistEvaluation.promoteReasonableScore viewMode:evaluation_score_view_mode_view];
    [self.trafficConvenientScoreView updateStarStatus:(int)evaluation.organizationEvaluation.trafficScore viewMode:evaluation_score_view_mode_view];
    [self.environmentScoreView updateStarStatus:(int)evaluation.organizationEvaluation.environmentScore viewMode:evaluation_score_view_mode_view];
    frame = self.bottomSpliteView.frame;
    frame.origin.y = self.detailScoreView.frame.size.height - splite_line_height;
    frame.size.height = splite_line_height;
    self.bottomSpliteView.frame = frame;
    self.bottomSpliteView.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
}

-(void)renderImgContent:(NSArray *)picturesArray
{
    NSArray * imageViewArray = [NSArray arrayWithObjects:self.evaluationImage1,self.evaluationImage2,self.evaluationImage3,self.evaluationImage4, nil];
    for (UIImageView *imgView in imageViewArray) {
        imgView.hidden = YES; 
        float width = (imgView.frame.size.height < imgView.frame.size.width)?imgView.frame.size.height:imgView.frame.size.width;
        imgView.image = [self cutCenterImage:imgView.image size:CGSizeMake(width, width)];
    }
    float y = self.evaluationContentLabel.frame.origin.y+self.evaluationContentLabel.frame.size.height + general_padding/2;
    
    for (int i = 0; i < picturesArray.count && i<4; i++) {
        UIImageView *imgView = (UIImageView *)imageViewArray[i];
        EvaluationPicture *picture = (EvaluationPicture *)picturesArray[i];
       
        imgView.hidden = NO;
        CGRect imgFrame = imgView.frame;
        imgFrame.origin.y = y;
        imgFrame.size.height = evaluation_image_height;
        imgView.frame = imgFrame;
        [imgView setImageWithURL:[NSURL URLWithString:picture.pictureUrls] placeholderImage:[UIImage imageNamed:@"stylist_default_image_before_load"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
        if (!tap[i]) {
            tap[i] = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapThumbImage:)];
            [imgView addGestureRecognizer:tap[i]];
            tap[i].delegate = self;
            imgView.userInteractionEnabled = YES;
        }
    }
}

-(void)tapThumbImage:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(tapThumbImageWith:andImageTag:)]) {
         [self.delegate tapThumbImageWith:self andImageTag:sender.view.tag];
    }
}

+(CGFloat)getCellHightFor:(Evaluation *)evaluation fold:(BOOL)fold
{
    if (fold) {
        return [self headerHeight] + [self contentHeight:evaluation.stylistEvaluation] + splite_line_height;
    }
    return [self headerHeight] + [self contentHeight:evaluation.stylistEvaluation] + detail_score_view_height + splite_line_height;
}

#pragma mark 根据size截取图片中间矩形区域的图片 这里的size是正方形
-(UIImage *)cutCenterImage:(UIImage *)image size:(CGSize)size{
    CGSize imageSize = image.size;
    CGRect rect;
    //根据图片的大小计算出图片中间矩形区域的位置与大小
    if (imageSize.width > imageSize.height) {
        float leftMargin = (imageSize.width - imageSize.height) * 0.5;
        rect = CGRectMake(leftMargin, 0, imageSize.height, imageSize.height);
    }else{
        float topMargin = (imageSize.height - imageSize.width) * 0.5;
        rect = CGRectMake(0, topMargin, imageSize.width, imageSize.width);
    }
    
    CGImageRef imageRef = image.CGImage;
    //截取中间区域矩形图片
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, rect);
    
    UIImage *tmp = [[UIImage alloc] initWithCGImage:imageRefRect];
    CGImageRelease(imageRefRect);
    
    UIGraphicsBeginImageContext(size);
    CGRect rectDraw = CGRectMake(0, 0, size.width, size.height);
    [tmp drawInRect:rectDraw];
    // 从当前context中创建一个改变大小后的图片
    tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return tmp;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIImageView class]]) {
        return YES;
    }
    return NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
@end
