//
//  FindExpertsHeaderView.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/25.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindExpertsHeaderView : UIView <UICollectionViewDataSource , UICollectionViewDelegate >


@property (nonatomic , strong) UICollectionView *expertsCollectionView;

@property (nonatomic , strong) UIButton *moreBtn;

@property (nonatomic , strong) UINavigationController *navigationController;
@property (nonatomic , strong) NSArray *experts;


-(instancetype) initWithNavigationController:(UINavigationController *)navigationController;

@end
