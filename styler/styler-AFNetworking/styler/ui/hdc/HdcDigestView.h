//
//  HdcDigestView.h
//  styler
//
//  Created by wangwanggy820 on 14-7-17.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define hdc_digest_view_height 80

#import <UIKit/UIKit.h>
#import "HairDressingCard.h"
#import "Organization.h"
#import "HdcDigest.h"

@interface HdcDigestView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *hdcIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *hdcTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *organizationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;


-(void)render:(HdcDigest *)hdc;
@end
