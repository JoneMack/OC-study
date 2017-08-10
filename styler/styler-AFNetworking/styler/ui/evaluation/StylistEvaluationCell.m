//
//  StylistEvaluationCell.m
//  styler
//
//  Created by aypc on 13-12-6.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "StylistEvaluationCell.h"
#import "ImageUtils.h"
#import <QuartzCore/QuartzCore.h>

#define evaluation_content_font_size 14
#define general_origin_x             55
#define time_label_height            25
#define evaluation_image_height      55
#define evaluation_content_origin_y  28
#define detail_score_view_height     50
#define left_star_origin_x           112
#define rigit_star_origin_x          242
#define star_origin_y                5
#define star_space_height            22
#define score_view_frame_origin(x,y) CGRectMake(x, y, 70, 20)
#define evaluation_avatar_width 40
#define user_name_top_margin 12
#define evaluation_content_width 250

@implementation StylistEvaluationCell
{
    UITapGestureRecognizer * tap[4];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"StylistEvaluationCell" owner:self options:nil] objectAtIndex:0];
 
        //初始化评价头部
        CGRect headerFrame = self.evaluationHeaderView.frame;
        headerFrame.size.height = [StylistEvaluationCell headerHeight];
        self.evaluationHeaderView.frame = headerFrame;
        
        //初始化头像
        CGRect avatarFrame = self.avatarImageVIew.frame;
        avatarFrame.origin.x = general_padding;
        avatarFrame.origin.y = general_padding;
        avatarFrame.size.height = evaluation_avatar_width;
        self.avatarImageVIew.frame = avatarFrame;
        self.avatarImageVIew.layer.masksToBounds = YES;
        self.avatarImageVIew.layer.cornerRadius = self.avatarImageVIew.frame.size.width/2;
        self.avatarImageVIew.userInteractionEnabled = YES;
 
        //初始化名字
        CGRect userNameFrame = self.userNameLabel.frame;
        userNameFrame.origin.x = avatarFrame.origin.x + avatarFrame.size.width + general_padding;
        userNameFrame.origin.y = user_name_top_margin;
        userNameFrame.size.height = default_txt_height;
        self.userNameLabel.frame = userNameFrame;
        self.userNameLabel.font = [UIFont systemFontOfSize:big_font_size];
        self.userNameLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
        

        //初始化评价内容
        CGRect evaluationTxtFrame = self.evaluationContentLabel.frame;
        evaluationTxtFrame.origin.x = self.userNameLabel.frame.origin.x;
        self.evaluationContentLabel.frame = evaluationTxtFrame;
        self.evaluationContentLabel.textColor = [ColorUtils colorWithHexString:light_gray_text_color];
        self.evaluationContentLabel.backgroundColor = [UIColor clearColor];
        self.evaluationContentLabel.numberOfLines = 0;
        self.evaluationContentLabel.font = [UIFont systemFontOfSize:evaluation_content_font_size];

        //评论时间
        self.timeOfEvaluation.textColor = [ColorUtils colorWithHexString:gray_text_color];

        //分割线
        CGRect frame = self.graySeparatorLine.frame;
        frame.size.height = splite_line_height;
        frame.size.width = screen_width;
        self.graySeparatorLine.frame = frame;
        self.graySeparatorLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    }
    return self;
}

-(void)loadUIForDic:(StylistEvaluation *)evaluation andBold:(BOOL)bold
{
#pragma mark ------ 头部部分 -------
    //设置头像
    [self.avatarImageVIew setImageWithURL:[NSURL URLWithString:evaluation.avatarUrl] placeholderImage:[UIImage imageNamed:@"user_default_image_before_load"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
    
    //设置用户名字
    self.userNameLabel.text = [evaluation honorName];

    //设置平均分
    [self.totalScoreView updateStarStatus:(evaluation.effectScore+evaluation.attitudeScore+evaluation.promoteReasonableScore)/3 viewMode:evaluation_score_view_mode_view];
    
#pragma mark ------ 内容部分 -------
    //评价内容部分，包含文字内容、图片内容及评价时间
    CGRect evaluationContentFrame = self.evaluationImagesView.frame;
    evaluationContentFrame.origin.y = self.evaluationHeaderView.frame.origin.y+self.evaluationHeaderView.frame.size.height;
    evaluationContentFrame.size.height = [StylistEvaluationCell contentHeight:evaluation];
    self.evaluationImagesView.frame = evaluationContentFrame;
    //渲染评价内容及布局
    self.evaluationContentLabel.text = evaluation.content;
    CGRect evaluationTxtFrame = self.evaluationContentLabel.frame;
    evaluationTxtFrame.origin.y = 0;
    evaluationTxtFrame.size.width = evaluation_content_width;
    evaluationTxtFrame.size.height = [StylistEvaluationCell txtContentHeight:evaluation];
    self.evaluationContentLabel.frame = evaluationTxtFrame;
    //渲染评价图片内容
    [self renderImgContent:evaluation.evaluationPictures];
    //设置评价时间  evalutionPictures
    self.timeOfEvaluation.text = [DateUtils stringFromLongLongIntAndFormat:evaluation.createTime dateFormat:@"yyyy-MM-dd"];
    CGRect timeEvuluationFrame = self.timeOfEvaluation.frame;
    timeEvuluationFrame.origin.y = [StylistEvaluationCell contentHeight:evaluation] - time_label_height;
    self.timeOfEvaluation.frame = timeEvuluationFrame;
    //分割线
    CGRect frame = self.graySeparatorLine.frame;
    frame.origin.y = timeEvuluationFrame.origin.y +timeEvuluationFrame.size.height - splite_line_height;
    if (bold) {
        frame.origin.x = 0;
    }else{
        frame.origin.x = general_origin_x;
    }
    self.graySeparatorLine.frame = frame;

#pragma mark ------ 详细评分视图 -------
    //渲染详细评分
    [self renderDetailScoreView:evaluation];
}

-(void)renderUpline:(BOOL)showLine{
    if (self.upLine) {
        [self.upLine removeFromSuperview];
    }
    if (showLine) {
        self.upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, splite_line_height)];
        self.upLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        [self.contentView addSubview:self.upLine];
    }
}

//评分显示
-(void)renderDetailScoreView:(StylistEvaluation*)evaluation
{
    CGRect frame = self.detailScoreView.frame;
    frame.origin.y = self.evaluationImagesView.frame.origin.y + self.evaluationImagesView.frame.size.height + splite_line_height;
    self.detailScoreView.frame = frame;
 
    [self.effectScoreView updateStarStatus:(int)evaluation.effectScore viewMode:evaluation_score_view_mode_view];
    [self.attitudeScoreView updateStarStatus:(int)evaluation.attitudeScore viewMode:evaluation_score_view_mode_view];
    [self.promoteReasonableScoreView updateStarStatus:(int)evaluation.promoteReasonableScore viewMode:evaluation_score_view_mode_view];

    frame = self.separotorView.frame;
    frame.origin.y = self.detailScoreView.frame.size.height - splite_line_height;
    frame.size.height = splite_line_height;
    self.separotorView.frame = frame;
    self.separotorView.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
}

+(float)headerHeight{
    return evaluation_avatar_width/2 +general_padding;
}

+(float)txtContentHeight:(StylistEvaluation *)evaluation{
    if ([evaluation hasContent]) {
        CGSize contentSize = [evaluation.content sizeWithFont:[UIFont systemFontOfSize:evaluation_content_font_size] constrainedToSize:CGSizeMake(evaluation_content_width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        return contentSize.height;
    }else{
        return 0;
    }
    return 3;
}

+(float)contentHeight:(StylistEvaluation *)evaluation{
    float txtHeight = [self txtContentHeight:evaluation];
    float imgHeight = (evaluation.evaluationPictures.count>0)?(evaluation_image_height +general_padding/2):0;
    float timeHeight = time_label_height + general_padding/2;
    

    return txtHeight + imgHeight + timeHeight;
}

//图片下载
-(void)renderImgContent:(NSArray *)pictures
{
    NSArray * imageViewArray = [NSArray arrayWithObjects:self.evaluationImage1,self.evaluationImage2,self.evaluationImage3,self.evaluationImage4, nil];
    for (UIImageView *imgView in imageViewArray) {
        imgView.hidden = YES;
        float width = (imgView.frame.size.height < imgView.frame.size.width)?imgView.frame.size.height:imgView.frame.size.width;
        imgView.image = [self cutCenterImage:imgView.image size:CGSizeMake(width, width)];
    }
    float y = self.evaluationContentLabel.frame.origin.y+self.evaluationContentLabel.frame.size.height + general_padding/2;
    for (int i = 0; i < pictures.count && i < 4; i++) {
        UIImageView *imgView = (UIImageView *)[imageViewArray objectAtIndex:i];
        EvaluationPicture *picture = (EvaluationPicture *)pictures[i];
        imgView.hidden = NO;
        CGRect imgFrame = imgView.frame;
        imgFrame.origin.y = y;
        
        imgFrame.size.height = evaluation_image_height;
        imgView.frame = imgFrame;
        [imgView setImageWithURL:[NSURL URLWithString:picture.pictureThumbnailUrls] placeholderImage:[UIImage loadImageWithImageName:@"evaluation_place_holder_image"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
        if (!tap[i]) {
            tap[i] = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapThumbImage:)];
            [(UIImageView *)[imageViewArray objectAtIndex:i] addGestureRecognizer:tap[i]];
        }
    }
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

-(void)tapThumbImage:(UITapGestureRecognizer *)sender
{
    [self.delegate tapThumbImageWith:self andImageTag:sender.view.tag];
}

+(CGFloat)getCellHightFor:(StylistEvaluation *)evaluation andBold:(BOOL)bold
{
    float height = [self headerHeight];
    height += [self contentHeight:evaluation];
    if (bold) {
        return height ;
    }else
    {
        return height + detail_score_view_height;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
