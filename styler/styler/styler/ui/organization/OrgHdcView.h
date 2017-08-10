//
//  OrgHdcView.h
//  styler
//
//  Created by wangwanggy820 on 14-7-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Organization.h"
#import "HairDressingCard.h"

#define display_in_organization_list 1   //在商户列表中显示
#define display_in_stylist_profile 2     //在发型师详情页中显示

@interface OrgHdcView : UIView
{
    UILabel *_priceLabel;
    UILabel *_specialOfferPriceLabel;
    UILabel *_name;
    UILabel *_saleCount;
}
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *specialOfferPriceLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *saleCountLabel;
@property (nonatomic, strong) UIImageView *cardTypeImgV;
@property (nonatomic, strong) HairDressingCard *hdc;
//卡片显示的场景
@property int displayScene;

-(id)initWithFrame:(CGRect)frame hdc:(HairDressingCard *)hdc displayScene:(int)displayScene;

-(void)renderData;

@end
