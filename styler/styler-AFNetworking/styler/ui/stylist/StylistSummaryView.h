//
//  StylistSummaryView.h
//  styler
//
//  Created by System Administrator on 14-1-20.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stylist.h"
#import "EvaluationScoreView.h"

#define stylist_summary_height 75

@interface StylistSummaryView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (weak, nonatomic) IBOutlet EvaluationScoreView *scoreView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) IBOutlet UILabel *offDaysLab;


@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImgView;



@property (retain, nonatomic) Stylist *stylist;

-(id)initWithStylist:(Stylist *)stylist frame:(CGRect)frame;

@end
