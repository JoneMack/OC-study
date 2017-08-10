//
//  XBSegmentView.h
//  xiangyu
//
//  Created by xubojoy on 16/7/7.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#define btn_seed 21000

@protocol XBSegmentViewDelegate <NSObject>


-(void)selectXBSegmentView:(int)inx;
@end
@interface XBSegmentView : UIView
@property (retain, nonatomic) id<XBSegmentViewDelegate> delegate;
@property (nonatomic, strong) UIView *redLineView;
@property int currentIndex;
@property (nonatomic, strong) UIImageView *redDotImage;

-(void)render:(NSArray *)btnTitleArray currentIndex:(int)currentIndex;

-(void)selectIndex:(int)index;

-(void)renderRedDot:(int)index showRedDot:(BOOL)showRedDot;
@end
