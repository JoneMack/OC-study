//
//  UserHdcCell.h
//  styler
//
//  Created by wangwanggy820 on 14-7-19.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define  user_hdc_cell_height 80

#import <UIKit/UIKit.h>
#import "UserHdc.h"
#import "Organization.h"

@interface UserHdcCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *hdcIconImgView;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *hdcTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *organizationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *hdcStatusLabel;
@property (strong, nonatomic) UIView *spliteView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (retain, nonatomic) IBOutlet UILabel *redEnvelopeLabel;
@property (strong, nonatomic) UserHdc<Optional> * userHdc;

@property (weak, nonatomic) IBOutlet UIView *imgBgView;
@property (strong , nonatomic) UIImageView *lockImgView;

-(void)render:(UserHdc *)card organization:(Organization *)organization withSplite:(BOOL)withSplite last:(BOOL)last;

@end
