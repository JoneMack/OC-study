//
//  HotCircleCollectionView.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/5.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotCircle.h"

@interface HotCircleCollectionView : UICollectionView <UICollectionViewDelegate , UICollectionViewDataSource>


@property (nonatomic , strong) NSArray<HotCircle *> *hotCircles;

@property (nonatomic , strong) UINavigationController *navigationController;

-(instancetype) init;

@end
