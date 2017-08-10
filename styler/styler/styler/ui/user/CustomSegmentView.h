//
//  UserHdcView.h
//  styler
//
//  Created by wangwanggy820 on 14-7-18.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define btn_seed 11000

@protocol CustomSegmentViewDelegate


-(void)selectSegment:(int)inx;
@end

@interface CustomSegmentView : UIView
{

    id<CustomSegmentViewDelegate> delegate;

}
@property (retain, nonatomic) id<CustomSegmentViewDelegate> delegate;
@property (nonatomic, strong) UIView *redLineView;
@property int currentIndex;
@property (nonatomic, strong) UIImageView *redDotImage;

-(void)render:(NSArray *)btnTitleArray currentIndex:(int)currentIndex;

-(void)selectIndex:(int)index;

-(void)renderRedDot:(int)index showRedDot:(BOOL)showRedDot;

@end
