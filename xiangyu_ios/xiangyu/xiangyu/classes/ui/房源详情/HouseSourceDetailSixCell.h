//
//  HouseSourceDetailSixCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/17.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "House.h"

@interface HouseSourceDetailSixCell : UITableViewCell <UITableViewDelegate , UITableViewDataSource>


@property (nonatomic , strong) UITableView *recommendTableView;

@property (nonatomic , strong) NSArray<House *> *houses;
@property (nonatomic , strong) UINavigationController *navigationController;

- (void) renderData:(CGRect)frame houses:(NSArray<House *> *)houses navigationController:(UINavigationController *) navigationController;



@end
