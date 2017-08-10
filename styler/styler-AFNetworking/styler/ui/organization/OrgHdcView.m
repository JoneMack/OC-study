//
//  OrgHdcView.m
//  styler
//
//  Created by wangwanggy820 on 14-7-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "OrgHdcView.h"
#import "UIView+Custom.h"
#import "UILabel+Custom.h"

#define special_offer_price_label_width 50
#define price_label_width 45
#define card_name_label_width 130
#define card_name_label_x 110
#define card_type_icon_width 20

#define special_offer_price_label_left_space 3
#define price_label_left_space 5
#define card_name_label_left_space 5

#define profile_price_label_left_space 13
#define profile_card_name_label_left_space 15

@implementation OrgHdcView
- (id)initWithFrame:(CGRect)frame hdc:(HairDressingCard *)hdc displayScene:(int)displayScene
{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.hdc = hdc;
        self.displayScene = displayScene;
        
        //设置布局参数
        float x = general_padding;
        if (self.displayScene == display_in_stylist_profile) {
            x = 0;
        }
        float y = 0;
        float h = self.frame.size.height;
        
        //创建视图对象并布局
        if (self.displayScene == display_in_stylist_profile) {
            float cardIconY = (self.frame.size.height - card_type_icon_width)/2;
            self.cardTypeImgV = [[UIImageView alloc] initWithFrame:CGRectMake(x, cardIconY, card_type_icon_width, card_type_icon_width)];
            [self.cardTypeImgV setContentMode:UIViewContentModeScaleToFill];
            [self.cardTypeImgV setImageWithURL:[NSURL URLWithString:self.hdc.hdcType.iconUrl] placeholderImage:nil options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
            [self addSubview:self.cardTypeImgV];
            x = self.cardTypeImgV.rightX + special_offer_price_label_left_space;
        }
        
        self.specialOfferPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, special_offer_price_label_width, h)];
        self.specialOfferPriceLabel.font = [UIFont systemFontOfSize:default_font_size];
        self.specialOfferPriceLabel.textAlignment = NSTextAlignmentLeft;
        self.specialOfferPriceLabel.textColor = [ColorUtils colorWithHexString:red_color];
        [self addSubview:self.specialOfferPriceLabel];
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.font = [UIFont systemFontOfSize:smaller_font_size];
        self.priceLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.priceLabel];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:default_font_size];
        self.nameLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.nameLabel];
        
//        self.saleCountLabel = [[UILabel alloc] init];
//        self.saleCountLabel.font = [UIFont systemFontOfSize:default_font_size];
//        self.saleCountLabel.textAlignment = NSTextAlignmentLeft;
//        self.saleCountLabel.textColor = [ColorUtils colorWithHexString:light_gray_text_color];
//        [self addSubview:self.saleCountLabel];
        
        [self renderData];
    }
    return self;
}

-(void)renderData{
    float y = 0;
    float yOffset = 0;
    self.specialOfferPriceLabel.text = [self.hdc specialOfferPriceTxt];
    float x = general_padding+ self.specialOfferPriceLabel.realWidth+ price_label_left_space;
    
    if (self.displayScene == display_in_stylist_profile) {
        
        self.priceLabel.frame = CGRectMake(x+profile_price_label_left_space, y+yOffset, price_label_width, self.specialOfferPriceLabel.frame.size.height);
        self.priceLabel.text = [NSString stringWithFormat:@"￥%d", self.hdc.price];
//        self.saleCountLabel.text = [NSString stringWithFormat:@"%d人购买", self.hdc.saleCount.saleCount];
        
        float nameLabelX = general_padding+ self.specialOfferPriceLabel.realWidth+price_label_left_space+self.priceLabel.realWidth+ card_name_label_left_space;
        self.nameLabel.frame = CGRectMake(nameLabelX+profile_price_label_left_space, y, card_name_label_width, self.priceLabel.frame.size.height);
        self.nameLabel.text = self.hdc.title;

    }else if (self.displayScene == display_in_organization_list){
        
        self.priceLabel.frame = CGRectMake(x, y+yOffset, price_label_width, self.specialOfferPriceLabel.frame.size.height);
        self.priceLabel.text = [NSString stringWithFormat:@"￥%d", self.hdc.price];
//        self.saleCountLabel.text = [NSString stringWithFormat:@"%d人购买", self.hdc.saleCount.saleCount];
        
        float nameLabelX = general_padding+ self.specialOfferPriceLabel.realWidth+price_label_left_space+self.priceLabel.realWidth+ card_name_label_left_space;
        self.nameLabel.frame = CGRectMake(nameLabelX, y, card_name_label_width, self.specialOfferPriceLabel.frame.size.height);
        self.nameLabel.text = self.hdc.title;
    }
    
    CGSize size =  [self.priceLabel.text sizeWithFont:self.priceLabel.font];
    y = self.priceLabel.frame.size.height/2;
    UIView *throughLine = [[UIView alloc] initWithFrame:CGRectMake(0, y, size.width, splite_line_height)];
    throughLine.backgroundColor = [ColorUtils colorWithHexString:black_text_color];
    [self.priceLabel addSubview:throughLine];

//    size = [self.saleCountLabel.text sizeWithFont:self.saleCountLabel.font];
//    x = self.frame.size.width - size.width - general_padding;
//    self.saleCountLabel.frame = CGRectMake(x, self.specialOfferPriceLabel.frame.origin.y, size.width, self.frame.size.height);
}

@end
