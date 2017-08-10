//
//  IndexViewController.h
//  BHZhiBo
//
//  Created by xubojoy on 2016/12/21.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "CustomCategoryView.h"
#import "Article.h"
@interface IndexViewController : UIViewController<SDCycleScrollViewDelegate,CustomCategoryViewDelegate,UICollectionViewDataSource , UICollectionViewDelegate>
@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic ,strong) UIScrollView *mainScrollView;
@property (nonatomic ,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic ,strong) NSMutableArray *imageArray;
@property (nonatomic ,strong) CustomCategoryView *customCategoryView;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic ,strong) Article *article;
@property (nonatomic ,strong) NSMutableArray *articleArray;
@property (nonatomic ,strong) NSMutableArray *bannerArray;
@end
