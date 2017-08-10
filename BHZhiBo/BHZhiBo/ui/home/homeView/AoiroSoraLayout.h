
//  Copyright (c) 2015年 徐建飞. All rights reserved.


#import <UIKit/UIKit.h>
@class AoiroSoraLayout;
@protocol AoiroSoraLayoutDelegate <NSObject>

@required

//设置每个item的自身高度
 
- (CGFloat)itemHeightLayOut:(AoiroSoraLayout *)layOut indexPath:(NSIndexPath *)indexPath;

@end

@interface AoiroSoraLayout : UICollectionViewFlowLayout
/**
 *  列数
 */
@property (nonatomic, assign)NSInteger colNum;
/**
 *  每个item的间隔
 */
@property (nonatomic, assign)CGFloat interSpace;
/**
 *  整个CollectionView的间隔
 */
@property (nonatomic, assign)UIEdgeInsets edgeInsets;

@property (nonatomic, weak) id<AoiroSoraLayoutDelegate>delegate;

@end
