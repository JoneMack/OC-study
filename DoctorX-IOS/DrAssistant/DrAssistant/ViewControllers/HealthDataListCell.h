//
//  HealthDataListCell.h
//  DrAssistant
//
//  Created by 张保华 on 15/10/29.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthDataListCell : UITableViewCell
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *pressureLabel;
@property (strong, nonatomic) UILabel *rateLabel;
@end
