//
//  SmartLockViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmartLockViewController : UIViewController <UICollectionViewDelegate , UICollectionViewDataSource>


@property (nonatomic , strong) HeaderView *headerView;

@property (nonatomic , strong) UICollectionView *bodyView;



@end
