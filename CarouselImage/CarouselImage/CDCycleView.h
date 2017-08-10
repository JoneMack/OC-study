//
//  CDCycleView.h
//  CarouselImage
//
//  Created by xubojoy on 2017/3/8.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDCycleView;
@protocol CDCycleViewDelegate <NSObject>

@optional

/** 点击图片回调 */
- (void)cycleScrollView:(CDCycleView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

/** 图片滚动回调 */
- (void)cycleScrollView:(CDCycleView *)cycleScrollView didScrollToIndex:(NSInteger)index;

@end

@interface CDCycleView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *imagePathsGroup;
@property (nonatomic, assign) NSInteger totalItemsCount;
@property (nonatomic, weak) id<CDCycleViewDelegate> delegate;

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;


+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<CDCycleViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;

@end
