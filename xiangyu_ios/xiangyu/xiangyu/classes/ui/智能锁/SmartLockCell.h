//
//  SmartLockCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmartLockCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView *line1View;

@property (strong, nonatomic) IBOutlet UIView *line2View;

@property (strong, nonatomic) IBOutlet UIImageView *statusImg;

@property (strong, nonatomic) IBOutlet UILabel *status;

@property (strong, nonatomic) IBOutlet UILabel *name;


@end
