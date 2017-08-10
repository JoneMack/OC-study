//
//  HouseSourceDetailSecondCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/16.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseInfo.h"

@interface HouseSourceDetailSecondCell : UITableViewCell

@property (nonatomic , strong) UILabel *firstRow;
@property (nonatomic , strong) UILabel *secondRow;

@property (nonatomic , strong) UILabel *firstTag;
@property (nonatomic , strong) UILabel *secondTag;
@property (nonatomic , strong) UILabel *thirdTag;
@property (nonatomic , strong) UILabel *fourthTag;
@property (nonatomic , strong) UILabel *fifthTag;


-(void) renderData:(HouseInfo *)houseInfo;



@end
