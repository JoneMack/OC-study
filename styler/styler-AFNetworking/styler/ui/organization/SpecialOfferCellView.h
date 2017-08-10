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
@class HairDressingCard, Organization, EvaluationScoreView, HdcCardView;


@protocol SpecialOfferCellViewDelegate <NSObject>

-(void) showOrHideMoreHdcs:(int)organizationId;

@end


@interface SpecialOfferCellView : UITableViewCell

@property (nonatomic, strong) UIView *topMarginBlock;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UILabel *brandLable;
@property (nonatomic, strong) UILabel *storeLable;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UIView *coverWrapper;
@property (nonatomic, strong) UIImageView *organizationCoverPicture;
@property (nonatomic, strong) EvaluationScoreView *scoreView;
@property (nonatomic, strong) HdcCardView *firstHdcCardView;
@property (nonatomic, strong) NSMutableArray *moreHdcCardsView;
@property (nonatomic, strong) UIImageView *downArrowView;
@property (nonatomic, strong) UIView *showMoreLine;
@property (nonatomic, strong) UIView *bottomLineView;


@property (nonatomic, strong) UIButton *showMoreButton;
@property int showMoreFlag;
@property (nonatomic, strong) Organization *organization;
@property (nonatomic, strong) id<SpecialOfferCellViewDelegate> delegate;



-(id) initWithOrganizationAndHdcs:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier organization:(Organization *)organization hdcType:(int)hdcType showMoreFlag:(int)showMoreFlag;

-(void) renderData:(Organization *)organization hdcType:(int)hdcType showMoreFlag:(int)showMoreFlag;

+(float) getHeightByHdcs:(NSArray *)hdcs showMoreFlag:(int)showMoreFlag;


@end
