//
//  HouseSourceDetailThirdCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/17.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseInfo.h"

@interface HouseSourceDetailThirdCell : UITableViewCell <UICollectionViewDelegate , UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *mianji;
@property (strong, nonatomic) IBOutlet UILabel *chaoxiang;

@property (strong, nonatomic) IBOutlet UILabel *jushi;


@property (strong, nonatomic) IBOutlet UILabel *louceng;

@property (strong, nonatomic) IBOutlet UIView *lineView;

@property (strong, nonatomic) IBOutlet UICollectionView *icons;
@property (strong, nonatomic) HouseInfo *houseInfo;
@property (strong, nonatomic) NSMutableArray *totalIcons;


-(void) renderData:(HouseInfo *)houseInfo;

@end
