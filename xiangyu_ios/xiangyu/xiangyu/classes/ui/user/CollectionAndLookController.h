//
//  MyCollectionController.h
//  xiangyu
//
//  Created by xubojoy on 16/7/6.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBSegmentView.h"
#import "MyCollectionController.h"
#import "MyOrderedLookController.h"

@interface CollectionAndLookController : UIViewController<XBSegmentViewDelegate>
@property (nonatomic , strong) HeaderView *headerView;
@property (nonatomic , strong) XBSegmentView *xbSegmentView;
@property (nonatomic ,strong) NSArray *currentType;
@property (nonatomic ,strong) MyCollectionController *myCollectionController;
@property (nonatomic ,strong) MyOrderedLookController *myOrderedLookController;

@property (nonatomic ,strong) UIButton *selectedBtn;
@property (nonatomic ,strong) UIButton *backBtn;

@end
