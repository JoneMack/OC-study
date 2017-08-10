//
//  HouseSourceDetailFourthCellTableSubCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/17.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomShip.h"

@interface HouseSourceDetailFourthCellTableSubCell : UITableViewCell

@property (nonatomic , strong) UIImageView *sexLogo;
@property (nonatomic , strong) UILabel *room;
@property (nonatomic , strong) UILabel *sex;
@property (nonatomic , strong) UILabel *xingzuo;
@property (nonatomic , strong) UILabel *age;
@property (nonatomic , strong) UILabel *mianji;

-(void) renderData:(RoomShip *)roomShip;

@end
