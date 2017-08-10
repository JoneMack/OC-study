//
//  HouseSourceIndoorIconCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/8/5.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseSourceIndoorIconCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *icon;

@property (strong, nonatomic) IBOutlet UILabel *name;

-(void) renderData:(NSString *)iconName;

@end
