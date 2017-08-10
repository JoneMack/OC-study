//
//  XBCustomSegmentView.h
//  xiangyu
//
//  Created by xubojoy on 16/9/23.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#define btn_seed 11000

@protocol XBCustomSegmentViewDelegate <NSObject>


-(void)selectSegment:(int)inx;
@end
@interface XBCustomSegmentView : UIView
@property (retain, nonatomic) id<XBCustomSegmentViewDelegate> delegate;
@property (nonatomic, strong) UIView *redLineView;
@property int currentIndex;
@property (nonatomic, strong) UIImageView *redDotImage;

-(void)render:(NSArray *)btnTitleArray currentIndex:(int)currentIndex;

-(void)selectIndex:(int)index;

-(void)renderRedDot:(int)index showRedDot:(BOOL)showRedDot;
@end
