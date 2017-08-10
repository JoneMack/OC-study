//
//  MainFindHouseWaysView.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/12.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainFindHouseWaysView : UICollectionView <UICollectionViewDelegate , UICollectionViewDataSource>

@property (nonatomic , strong) UIView *separatorLine;
@property (nonatomic , strong) UINavigationController *navigationController;

-(instancetype) initWithFrame:(CGRect)frame navigationController:(UINavigationController *)navigationController;

@end
