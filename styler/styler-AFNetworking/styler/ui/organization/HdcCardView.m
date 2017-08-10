//
//  HdcCardView.m
//  styler
//
//  Created by 冯聪智 on 14-9-25.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//


#import "HdcCardView.h"
#import "UILabel+Custom.h"
#import "HairDressingCard.h"
#import "StylerTabbar.h"
#import "AppDelegate.h"
#import "ShareEnableWebController.h"

@implementation HdcCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithHdc:(float)hdcCardWidth hairDressingCard:(HairDressingCard *)hairDressingCard{
    self = [super init];
    if (self) {
        self.hairDressingCard = hairDressingCard;
        // 美发卡 卡片背景
        self.frame = CGRectMake(0, 0, hdcCardWidth, hdc_card_info_height);
        
        UIImage *bgImg = [[UIImage imageNamed:@"card_icon"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5,0 , 0)
                                                                           resizingMode:UIImageResizingModeStretch];
        UIImageView *bgImgView = [[UIImageView alloc] initWithImage:bgImg];
        bgImgView.frame = self.frame;
        [self addSubview:bgImgView];
        
        // 美发卡信息上面的条状块
        self.hdcTypeBlock = [[UIView alloc] init];
        self.hdcTypeBlock.frame = CGRectMake(0, 0, 5, hdc_card_info_height);
        [self.hdcTypeBlock setBackgroundColor:[ColorUtils colorWithHexString:hairDressingCard.hdcType.color]];
        [self addSubview:self.hdcTypeBlock];
        
        // 美发卡名称
        self.hdcNameLabel = [[UILabel alloc] init];
        self.hdcNameLabel.text = hairDressingCard.title;
        self.hdcNameLabel.font = [UIFont boldSystemFontOfSize:big_font_size];
        self.hdcNameLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
        self.hdcNameLabel.frame = CGRectMake(15, 9, 160, 15);
        [self addSubview:self.hdcNameLabel];
        
        // 美发卡的优惠价
        self.specialOfferPriceLabel = [[UILabel alloc] init];
        self.specialOfferPriceLabel.text = [hairDressingCard specialOfferPriceTxt];
        [self.specialOfferPriceLabel setFont:[UIFont systemFontOfSize:default_1_font_size]];
        [self.specialOfferPriceLabel setTextColor:[ColorUtils colorWithHexString:red_default_color]];
        self.specialOfferPriceLabel.frame = CGRectMake(12, 32, self.specialOfferPriceLabel.realWidth, 15);
        [self addSubview:self.specialOfferPriceLabel];
        
        // 美发卡的原价
        self.originalPriceLabel = [[UILabel alloc] init];
        self.originalPriceLabel.text = [NSString stringWithFormat:@"%d" , hairDressingCard.price];
        [self.originalPriceLabel setFont:[UIFont systemFontOfSize:small_font_size]];
        CGRect frame = CGRectMake(12+ self.specialOfferPriceLabel.realWidth + 10, 33, self.originalPriceLabel.realWidth, 15);
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

-(void) viewHdc{
    StylerTabbar *tabBar = [(AppDelegate*)[UIApplication sharedApplication].delegate tabbar];
    
    AppStatus *as = [AppStatus sharedInstance];
    NSString *url = [NSString stringWithFormat:@"%@/app/hairDressingCards/%d?from=stylistProfile", as.webPageUrl, self.hairDressingCard.id];
    ShareEnableWebController *shareEnableWebController = [[ShareEnableWebController alloc] initWithUrl:url title:self.hairDressingCard.title shareable:YES];
    [[tabBar getSelectedViewController] pushViewController:shareEnableWebController animated:YES];
    
}

@end
