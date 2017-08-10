//
//  HdcDigestView.m
//  styler
//
//  Created by wangwanggy820 on 14-7-17.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "HdcDigestView.h"
#import "HdcDigest.h"

@implementation HdcDigestView

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HdcDigestView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
   
    }
    return self;
}

-(void)render:(HdcDigest *)hdc{
    [self.hdcIconImgView setImageWithURL:[NSURL URLWithString:hdc.iconUrl] placeholderImage:nil options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
    
    self.priceLab.textColor = [ColorUtils colorWithHexString:red_color];
    self.priceLab.text = hdc.specialOfferPriceString;
    self.priceLab.font = [UIFont systemFontOfSize:bigger_font_size];
    
    
    self.hdcTitleLab.text = [NSString stringWithFormat:@"%@", hdc.title];
    self.hdcTitleLab.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.hdcTitleLab.font = [UIFont systemFontOfSize:big_font_size];
    
    self.organizationNameLabel.text = [NSString stringWithFormat:@"%@", hdc.organizationName];
    self.organizationNameLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.organizationNameLabel.font = [UIFont systemFontOfSize:small_font_size];

   
    self.dateLab.font = [UIFont systemFontOfSize:small_font_size];
    self.dateLab.textColor = [ColorUtils colorWithHexString:light_gray_text_color];
    self.dateLab.text = hdc.timeNote;
//    self.dateLab.text = [NSString stringWithFormat:@"%@前可以使用", [card expiredTimeString]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
