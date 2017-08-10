//
//  HouseSourceDetailHeaderCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/16.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseInfo.h"

@interface HouseSourceDetailHeaderCell : UITableViewCell <UICollectionViewDelegate , UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *carouselList;

@property (strong, nonatomic) IBOutlet UIView *headerBg;

@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;

@property (strong, nonatomic) IBOutlet UILabel *userName;


@property (strong, nonatomic) IBOutlet UILabel *timeLeft;


@property (strong, nonatomic) IBOutlet UIView *priceBg;

@property (strong, nonatomic) IBOutlet UILabel *price;

@property (strong, nonatomic) IBOutlet UILabel *pageNo;

@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;

@property (strong , nonatomic) HouseInfo *houseInfo;

-(void) renderData:(HouseInfo *)houseInfo;



@end
