//
//  HouseSourceDetailFourthCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/17.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseInfo.h"

@interface HouseSourceDetailFourthCell : UITableViewCell <UITableViewDelegate , UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UITableView *heZuInfos;

@property (nonatomic , weak) HouseInfo *houseInfo;


-(void) renderData:(HouseInfo *) houseInfo;

@end
