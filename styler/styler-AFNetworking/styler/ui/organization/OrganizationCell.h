//
//  OrganizationCell.h
//  styler
//
//  Created by wangwanggy820 on 14-4-26.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Organization.h"
#import "UIView+Custom.h"
#import "EvaluationScoreView.h"
#import "HairDressingCard.h"
#import "OrgHdcView.h"

#define organization_font_size 13
#define organization_hdc_height 42
#define organization_more_hdc_height 20
#define organization_headImg_height 142
#define organization_cell_space 15
#define organization_cell_width 300
#define organization_cell_left_point 10


#define organization_cell_height      170

@interface OrganizationCell : UITableViewCell
{
    OrgHdcView *hdcView;

}
@property (weak, nonatomic) IBOutlet UIImageView *coverPicture;
@property (weak, nonatomic) IBOutlet UILabel *organizationName;
@property (weak, nonatomic) IBOutlet EvaluationScoreView *scoreView;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIView *hdcsView;
@property (nonatomic,strong) HairDressingCard *hairdcs;

-(void)renderOrganization:(Organization *)organization hdcs:(NSArray *)hdcs;

+(CGFloat)getCellHeight:(NSArray *)hdcs;


@end
