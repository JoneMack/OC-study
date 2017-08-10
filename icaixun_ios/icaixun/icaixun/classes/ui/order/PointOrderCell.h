//
//  UserPointLogCell.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/13.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointOrder.h"

@interface PointOrderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *payLabel;

@property (strong, nonatomic) IBOutlet UILabel *payTime;

@property (strong, nonatomic) IBOutlet UILabel *pointLabel;

@property (strong, nonatomic) IBOutlet UILabel *addPoint;

@property (weak, nonatomic) PointOrder *pointOrder;


- (void)renderData:(PointOrder *)pointOrder;

@end
