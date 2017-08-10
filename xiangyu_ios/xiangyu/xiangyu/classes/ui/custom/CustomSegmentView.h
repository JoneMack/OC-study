//
//  CustomSegmentView.h
//  CrazyDoctor
//
//  Created by xubojoy on 16/4/18.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define btn_seed 11000

@protocol CustomSegmentViewDelegate <NSObject>


-(void)selectSegment:(int)inx;
@end

@interface CustomSegmentView : UIView

@property (retain, nonatomic) id<CustomSegmentViewDelegate> delegate;
@property (nonatomic, strong) UIView *redLineView;
@property int currentIndex;
@property (nonatomic, strong) UIImageView *redDotImage;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) UINavigationController *navigationController;

// 区域找房
@property (nonatomic , strong) NSString *quyu;
@property (nonatomic , strong) NSString *shangquan;

// 地铁找房
@property (nonatomic , strong) NSString *subwayLine;
@property (nonatomic , strong) NSString *station;

// 区域找房和地铁找房 共同的参数
@property (nonatomic , strong) NSString *rentType;
@property (nonatomic , strong) NSString *houseType;  //户型居室（不限、1、2、3、4+）
@property (nonatomic , strong) NSString *orderByType;  // 显示顺序（租金：priceASC/priceDESC、面积:areaASC/areaDESC）默认不传值
@property (nonatomic , strong) NSString *liveFlg;   // 带视频直播（选中：1）
@property (nonatomic , strong) NSMutableArray *searchTab;



-(void)render:(NSArray *)btnTitleArray currentIndex:(int)currentIndex;


-(void)selectIndex:(int)index;

-(void)renderRedDot:(int)index showRedDot:(BOOL)showRedDot;

//底部添加线
-(void) addBottomSeparateLine;



@end
