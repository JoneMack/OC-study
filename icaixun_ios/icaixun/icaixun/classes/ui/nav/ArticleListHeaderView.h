//
//  ArticleListHeaderView.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/20.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleListHeaderView : UITableViewCell <UICollectionViewDataSource , UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) IBOutlet UILabel *currentArtitleTitle;

@property (nonatomic , strong) UIView *separatorLine;

@property (nonatomic , weak) NSArray *articles;
@property (nonatomic , strong) UINavigationController *navigationController;



-(instancetype) initWithArticles:(NSArray *)articles navigationController:(UINavigationController *)navigationController;

@end
