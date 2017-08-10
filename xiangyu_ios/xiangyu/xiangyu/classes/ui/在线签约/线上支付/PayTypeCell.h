//
//  PayTypeCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/21.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTypeCell : UITableViewCell



@property (strong, nonatomic) IBOutlet UIView *line1View;

@property (strong, nonatomic) IBOutlet UIImageView *payIcon;

@property (strong, nonatomic) IBOutlet UILabel *payType;

@property (strong, nonatomic) IBOutlet UIImageView *status;


@property (strong, nonatomic) IBOutlet UIView *line2View;

@end
