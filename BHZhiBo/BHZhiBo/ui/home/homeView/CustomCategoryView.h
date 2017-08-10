//
//  HoneInOneCategoryView.h
//  Golf
//
//  Created by xubojoy on 16/3/16.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomCategoryViewDelegate <NSObject>

- (void)didSelectedCustomCategoryViewItem:(NSInteger)item categoryTitle:(NSString *)categoryTitle;

@end

@interface CustomCategoryView : UIView<UICollectionViewDataSource , UICollectionViewDelegate>

@property (nonatomic , strong) UICollectionView *customCategoryViewCollectionView;
@property (nonatomic, assign) id<CustomCategoryViewDelegate> delegate;
@end
