//
//  CompanyListCell.h
//  YJ
//
//  Created by xubojoy on 2017/6/30.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;

@property (weak, nonatomic) IBOutlet UIView *downLine;
@end
