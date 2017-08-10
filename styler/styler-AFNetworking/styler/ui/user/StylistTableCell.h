//
//  ExpertTableCell.h
//  styler
//
//  Created by System Administrator on 13-5-18.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluationScoreView.h"
#import "Stylist.h"

@interface StylistTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *stylistAvatar;
@property (weak, nonatomic) IBOutlet UILabel *stylistName;
@property (weak, nonatomic) IBOutlet EvaluationScoreView *scoreView;

@property (weak, nonatomic) IBOutlet UILabel *haircutPriceAndWorkNum;
@property (weak, nonatomic) IBOutlet UIImageView *gotoNext;
@property (weak, nonatomic) IBOutlet UILabel *outOfStack;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIView *grayLine;

@property (weak, nonatomic) IBOutlet UILabel *workCount;

@property (nonatomic, strong) UIView *line;

-(void)renderStylistInfo:(Stylist *)stylist;
@end
