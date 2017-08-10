//
//  UserRedEnvelopeCell.h
//  styler
//
//  Created by System Administrator on 14-8-25.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define user_red_envelope_cell_height 75

#import <UIKit/UIKit.h>
#import "RedEnvelope.h"

@interface UserRedEnvelopeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeNoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) UIView *spliteView;
@property (strong, nonatomic) UIImageView *selectImgView;

-(void)render:(RedEnvelope *)redEnvelope withSplite:(BOOL)withSplite last:(BOOL)last showRedEnvelopeStatusFlag:(BOOL)showRedEnvelopeStatusFlag;

@end
