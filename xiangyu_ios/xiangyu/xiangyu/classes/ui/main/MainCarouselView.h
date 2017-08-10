//
//  MainCarouselView.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/8.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCarouselView : UIView <UICollectionViewDelegate , UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) UIButton *searchBtn;


@property (strong, nonatomic) NSArray *banners;

@property (nonatomic ,weak) UINavigationController *navigationController;

-(instancetype) initWithFrame:(CGRect)frame;

-(void) renderData:(NSArray *) banners;



@end
