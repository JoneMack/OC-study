//
//  HdcCardView.h
//  styler
//
//  Created by 冯聪智 on 14-9-25.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define delete_line_offset               7
#define selled_count_label_margin_right  7
#define selled_count_label_margin_top    18
#define hdc_card_info_height             54


#import <UIKit/UIKit.h>
@class HairDressingCard;

@interface HdcCardView : UIView

@property (nonatomic , retain) UIView *hdcTypeBlock;
@property (nonatomic , retain) UILabel *hdcNameLabel;
@property (nonatomic , retain) UILabel *specialOfferPriceLabel;
@property (nonatomic , retain) UILabel *originalPriceLabel;
@property (nonatomic , retain) UIView *deleteLine;

@property (nonatomic , strong) HairDressingCard *hairDressingCard;


-(id) initWithHdc:(float)hdcCardWidth hairDressingCard:(HairDressingCard *)hairDressingCard;

@end
