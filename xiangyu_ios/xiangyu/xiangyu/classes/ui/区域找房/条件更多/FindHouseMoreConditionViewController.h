//
//  FindHouseMoreConditionViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/15.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectPickerView.h"


@interface FindHouseMoreConditionViewController : UIViewController <UITableViewDelegate , UITableViewDataSource , SelectPickerViewDelegate>

@property (nonatomic , strong) HeaderView *headerView;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UIButton *search;
@property (nonatomic , strong) UIView *bottomView;
@property (nonatomic , strong) SelectPickerView *pickerView;

@property (nonatomic , strong) UIView *separatorLine;

@property (nonatomic , strong) NSString *rentType;
@property (nonatomic , strong) NSString *houseType;  //户型居室（不限、1、2、3、4+）
@property (nonatomic , strong) NSString *orderByType;  // 显示顺序（租金：priceASC/priceDESC、面积:areaASC/areaDESC）默认不传值
@property (nonatomic , strong) NSString *liveFlag;
@property (nonatomic , strong) NSMutableArray *searchTab;




@end
