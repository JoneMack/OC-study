//
//  SpecialOfferCell.h
//  styler
//
//  Created by 冯聪智 on 14-9-25.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define show_more_none                   0
#define show_more_txt                    1
#define show_more_cards                  2

#import <UIKit/UIKit.h>
@class HairDressingCard, Organization, HdcCardView;


@protocol SpecialOfferCellViewDelegate <NSObject>

-(void) showOrHideMoreHdcs:(int)organizationId;

@end


@interface SpecialOfferCellView : UITableViewCell

@property (nonatomic, strong) UIView *topMarginBlock;

@property (nonatomic, strong) UIView *coverWrapper;
@property (nonatomic, strong) UIImageView *organizationCoverPicture;
@property (nonatomic, strong) UIImageView *downArrowView;
@property (nonatomic, strong) UIView *bottomLineView;


@property (nonatomic , retain) UIView *hdcTypeBlock;
@property (nonatomic , retain) UILabel *hdcNameLabel;
@property (nonatomic , retain) UILabel *specialOfferPriceLabel;
@property (nonatomic , retain) UILabel *originalPriceLabel;
@property (nonatomic , retain) UIView *deleteLine;


@property (nonatomic, strong) Organization *organization;
@property (nonatomic, strong) HairDressingCard *hairDressingCard;
@property (nonatomic, strong) id<SpecialOfferCellViewDelegate> delegate;



-(id) initWithOrganizationAndHdcs:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier organization:(Organization *)organization;

-(void)renderData:(Organization *)organization
 hairDressingCard:(HairDressingCard *)hairDressingCard showOrganizationPic:(BOOL)showOrganizationPic;


@end
