//
//  MainHouseSourceTableView.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/13.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "House.h"

#define house_source_type_recommend      @"recommendHouseSourceTypeRecommend"
#define house_source_type_near           @"recommendHouseSourceTypeNear"

@protocol MainHouseSourceTableViewDetegate <NSObject>

-(void) changeHouseSourceType:(NSString *)houseSourceType height:(float)height;

@end

@interface MainHouseSourceTableView : UITableView <UITableViewDelegate , UITableViewDataSource >


@property (nonatomic , strong) UIButton *recommendHouseSourceBtn;

@property (nonatomic , strong) UIButton *nearHouseSourceBtn;

@property (nonatomic , strong) NSString *houseSourceType;

@property (nonatomic , weak) id<MainHouseSourceTableViewDetegate> fydelegate;

@property (nonatomic , strong) UINavigationController *navigationController;


@property (nonatomic , strong) NSArray<House *> *nearHouses;



-(instancetype) init;

@end
