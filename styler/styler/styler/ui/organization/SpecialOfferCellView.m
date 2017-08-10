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

#define delete_line_offset               7
#define selled_count_label_margin_right  7
#define selled_count_label_margin_top    18
#define hdc_card_info_height             54




#import "SpecialOfferCellView.h"
#import "UILabel+Custom.h"
#import "Organization.h"
#import "HairDressingCard.h"
#import "StylerTabbar.h"
#import "AppDelegate.h"
#import "ShareEnableWebController.h"


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

-(id) initWithOrganizationAndHdcs:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier organization:(Organization *)organization {
                                                                     
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.organization = organization;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
                // 商户图
        float coverHeight = hdc_card_info_height;
        float coverWidth = coverHeight*2;
        float displayWidth = 70;
        self.coverWrapper = [UIView new];
        self.coverWrapper.frame = CGRectMake(special_offer_list_left_margin, 0, displayWidth, coverHeight);
        self.coverWrapper.clipsToBounds = YES;
        [self addSubview:self.coverWrapper];
        
        self.organizationCoverPicture = [[UIImageView alloc] init];
        CGRect frame = CGRectMake(0-(coverWidth-displayWidth)/2, 0, coverWidth, coverHeight);
        self.organizationCoverPicture.frame = frame;
        [self.coverWrapper addSubview:self.organizationCoverPicture];
        
        // 美发卡信息上面的条状块
        self.hdcTypeBlock = [[UIView alloc] init];
        self.hdcTypeBlock.frame = CGRectMake(self.coverWrapper.frame.origin.x+self.coverWrapper.frame.size.width+10,
                                             0, 5, hdc_card_info_height);
        [self.hdcTypeBlock setBackgroundColor:[ColorUtils colorWithHexString:self.hairDressingCard.hdcType.color]];
        [self addSubview:self.hdcTypeBlock];

        // 美发卡 卡片背景
        UIImage *bgImg = [[UIImage imageNamed:@"card_icon"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5,0 , 0)
                                                                                   resizingMode:UIImageResizingModeStretch];
        UIImageView *bgImgView = [[UIImageView alloc] initWithImage:bgImg];
    
        float bgImgX = self.hdcTypeBlock.frame.origin.x + self.hdcTypeBlock.frame.size.width ;
        frame = CGRectMake(self.hdcTypeBlock.frame.origin.x + self.hdcTypeBlock.frame.size.width, 0,
                           screen_width - bgImgX - 10, hdc_card_info_height);
        bgImgView.frame = frame;
        [self addSubview:bgImgView];

        // 美发卡名称
        self.hdcNameLabel = [[UILabel alloc] init];
        self.hdcNameLabel.text = self.hairDressingCard.title;
        self.hdcNameLabel.font = [UIFont boldSystemFontOfSize:big_font_size];
        self.hdcNameLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
        self.hdcNameLabel.frame = CGRectMake(bgImgX+15, 9, 160, 15);
        [self addSubview:self.hdcNameLabel];
        
        // 美发卡的优惠价
        self.specialOfferPriceLabel = [[UILabel alloc] init];
        self.specialOfferPriceLabel.text = [self.hairDressingCard specialOfferPriceTxt];
        [self.specialOfferPriceLabel setFont:[UIFont systemFontOfSize:default_1_font_size]];
        [self.specialOfferPriceLabel setTextColor:[ColorUtils colorWithHexString:red_default_color]];
        self.specialOfferPriceLabel.frame = CGRectMake(bgImgX+12, 32, self.specialOfferPriceLabel.realWidth, 15);
        [self addSubview:self.specialOfferPriceLabel];
        
        // 美发卡的原价
        self.originalPriceLabel = [[UILabel alloc] init];
        self.originalPriceLabel.text = [NSString stringWithFormat:@"%d" , self.hairDressingCard.price];
        [self.originalPriceLabel setFont:[UIFont systemFontOfSize:small_font_size]];
        frame = CGRectMake(bgImgX+12+ self.specialOfferPriceLabel.realWidth + 10, 33, self.originalPriceLabel.realWidth, 15);
        self.originalPriceLabel.frame = frame;
        [self addSubview:self.originalPriceLabel];
        
        // 删除线
        self.deleteLine = [[UIView alloc] init];
        self.deleteLine.backgroundColor = [ColorUtils colorWithHexString:black_text_color];
        self.deleteLine.frame = CGRectMake(self.originalPriceLabel.frame.origin.x, self.originalPriceLabel.frame.origin.y + delete_line_offset, self.originalPriceLabel.frame.size.width,  1);
        [self addSubview:self.deleteLine];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewHdc)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)renderData:(Organization *)organization hairDressingCard:(HairDressingCard *)hairDressingCard showOrganizationPic:(BOOL)showOrganizationPic{

    self.organization = organization;
    self.hairDressingCard = hairDressingCard;
    
    // 商户图
    if (showOrganizationPic) {
        self.organizationCoverPicture.hidden = NO;
        Picture *picture = organization.getCoverPicture;
        [self.organizationCoverPicture setImageWithURL:[NSURL URLWithString:picture.picUrl] placeholderImage:[UIImage imageNamed:@"brand_default_image_before_load"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
    }else{
        self.organizationCoverPicture.hidden = YES;
    }
    
    // 美发卡信息上面的条状块
    [self.hdcTypeBlock setBackgroundColor:[ColorUtils colorWithHexString:hairDressingCard.hdcType.color]];
    
    // 美发卡名称
    self.hdcNameLabel.text = hairDressingCard.title;
    
    // 美发卡的优惠价
    self.specialOfferPriceLabel.text = [hairDressingCard specialOfferPriceTxt];
    CGRect frame = self.specialOfferPriceLabel.frame;
    self.specialOfferPriceLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, self.specialOfferPriceLabel.realWidth, frame.size.height);
    
    // 美发卡的原价
    self.originalPriceLabel.text = [NSString stringWithFormat:@"%d" , hairDressingCard.price];
    frame = self.originalPriceLabel.frame;
    frame = CGRectMake(self.specialOfferPriceLabel.frame.origin.x + 12+ self.specialOfferPriceLabel.realWidth, frame.origin.y,
                       self.originalPriceLabel.realWidth, frame.size.height);
    self.originalPriceLabel.frame = frame;
    
    // 美发卡原价的删除线
    self.deleteLine.frame = CGRectMake(self.originalPriceLabel.frame.origin.x, self.originalPriceLabel.frame.origin.y+8,
                                       self.originalPriceLabel.frame.size.width, 1);
    
//    //底部分隔线:
//    float bottomLineY = [SpecialOfferCellView getHeightByHdcs:organization.hdcs showMoreFlag:showMoreFlag]-0.5;
//    self.bottomLineView.frame = CGRectMake(0, bottomLineY, screen_width,  splite_line_height);
}


-(void) viewHdc{
    StylerTabbar *tabBar = [(AppDelegate*)[UIApplication sharedApplication].delegate tabbar];
    
    AppStatus *as = [AppStatus sharedInstance];
    NSString *url = [NSString stringWithFormat:@"%@/app/hairDressingCards/%d?from=stylistProfile", as.webPageUrl, self.hairDressingCard.id];
    ShareEnableWebController *shareEnableWebController = [[ShareEnableWebController alloc] initWithUrl:url title:self.hairDressingCard.title shareable:YES];
    [[tabBar getSelectedViewController] pushViewController:shareEnableWebController animated:YES];
    
}


@end
