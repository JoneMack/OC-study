//
//  IndexHeaderView.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/30.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "ExpertSmallCardCell.h"

@protocol IndexHeaderDelegate <NSObject>

-(void) getExpertsMessages:(NSArray *)experts;

@end

@interface IndexHeaderView : UIView <UICollectionViewDataSource , UICollectionViewDelegate>

@property (nonatomic , strong) HeaderView *headerView;
@property (nonatomic , strong) UICollectionView *expertsCollectionView;
@property (nonatomic , strong) UILabel *hasNotRecommendExperts;
@property (nonatomic , strong) UIButton *attentionNow;

@property (nonatomic , strong) NSArray *experts;
@property (nonatomic , strong) UINavigationController *navigationController;

@property (nonatomic , strong) id<IndexHeaderDelegate> delegate;

-(instancetype) initWithNavigationController:(UINavigationController *)navigationController;

@end
