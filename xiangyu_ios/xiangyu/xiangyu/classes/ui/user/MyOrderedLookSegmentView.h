//
//  MyOrderedLookSegmentView.h
//  xiangyu
//
//  Created by xubojoy on 16/7/7.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#define btn1_seed 31000

@protocol MyOrderedLookSegmentViewDelegate <NSObject>


-(void)selectMyOrderedLookSegmentView:(int)inx;
@end

@interface MyOrderedLookSegmentView : UIView
@property (retain, nonatomic) id<MyOrderedLookSegmentViewDelegate> delegate;
@property (nonatomic, strong) UIView *redLineView;
@property int currentIndex;
@property (nonatomic, strong) UIImageView *redDotImage;

-(void)render:(NSArray *)btnTitleArray currentIndex:(int)currentIndex;

-(void)selectIndex:(int)index;

-(void)renderRedDot:(int)index showRedDot:(BOOL)showRedDot;
@end
