//
//  BrandItem.m
//  styler
//
//  Created by wangwanggy820 on 14-4-19.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "BrandItem.h"
#import "OrganizationListController.h"
#import "OrganizationSpecialOfferListViewController.h"
#import "OrganizationFilter.h"

@implementation BrandItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle]loadNibNamed:@"BrandItem" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        //设置品牌logo
        CGRect iconImgFrame = self.iconImg.frame;
        iconImgFrame.origin.x = (self.frame.size.width - iconImgFrame.size.width )/2;
        iconImgFrame.size.height = iconImgFrame.size.width/(190.0/126.0);
        self.iconImg.frame = iconImgFrame;
        
        //设置品牌名
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
        self.nameLabel.font = [UIFont systemFontOfSize:default_font_size];
    }
    return self;
}

- (IBAction)gotoSameOrganizationListController:(id)sender {
    OrganizationFilter *organizationFilter = [[OrganizationFilter alloc] init];
    organizationFilter.brandName = self.brand.name;
    OrganizationSpecialOfferListViewController *osovc = [[OrganizationSpecialOfferListViewController alloc] initWithOrganizationFilter:organizationFilter];
   if ([self.delegate respondsToSelector:@selector(gotoSameOrganizationListController:)]) {
       [self.delegate gotoSameOrganizationListController:osovc];
   }
}

-(void) initUI:(Brand *)brand{
    self.brand = brand;
    //设置品牌logo
    if (brand) {
        [self.iconImg setBackgroundColor:[ColorUtils colorWithHexString:splite_line_color]];
        [self.iconImg setImageWithURL:[NSURL URLWithString:brand.logoUrl] placeholderImage:[UIImage imageNamed:@"brand_default_image_before_load"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
        self.hidden = NO;
    }
    else{
        self.hidden = YES;
    }
    //设置品牌名
    self.nameLabel.text = brand.name;
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
