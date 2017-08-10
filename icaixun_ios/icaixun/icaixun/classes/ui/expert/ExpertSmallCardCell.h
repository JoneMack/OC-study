//
//  ExpertSmallCardCell.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/26.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expert.h"

@interface ExpertSmallCardCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *expertAvatar;
@property (strong, nonatomic) IBOutlet UILabel *expertName;

@property (strong, nonatomic) UILabel *statusLabel;


@property (strong , nonatomic) Expert *expert;

- (void) renderBaseUI;
- (void)renderWithExpert:(Expert *)expert;

- (void)renderAddExpert;

@end
