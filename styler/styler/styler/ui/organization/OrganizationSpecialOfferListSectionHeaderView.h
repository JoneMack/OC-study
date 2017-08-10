//
//  OrganizationSpecialOfferListSectionHeaderView.h
//  styler
//
//  Created by 冯聪智 on 14-10-21.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluationScoreView.h"
#import "Organization.h"

@interface OrganizationSpecialOfferListSectionHeaderView : UITableViewCell

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UILabel *brandLable;
@property (nonatomic, strong) UILabel *storeLable;
@property (nonatomic, strong) EvaluationScoreView *scoreView;
@property (nonatomic, strong) UILabel *distanceLabel;

-(id) initWithOrganization:(Organization *)organization identifier:(NSString *)identifier;
-(void) renderSectionUI:(Organization *)organization;

@end
