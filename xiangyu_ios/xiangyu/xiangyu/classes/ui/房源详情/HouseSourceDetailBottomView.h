//
//  HouseSourceDetailBottomView.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/17.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "House.h"
#import "HouseInfo.h"
#import "SelectContractViewController.h"

@interface HouseSourceDetailBottomView : UIView

@property (nonatomic , strong) UIButton *favBtn;

@property (nonatomic , strong) UIButton *qianyueOnline;

@property (nonatomic , strong) UIButton *yuyuekanfang;

@property (nonatomic , strong) UINavigationController *navigationController;

@property (nonatomic , weak) House *house;
@property (nonatomic , weak) HouseInfo *houseInfo;

-(void) renderData:(HouseInfo *)houseInfo;

- (instancetype)init;

@end
