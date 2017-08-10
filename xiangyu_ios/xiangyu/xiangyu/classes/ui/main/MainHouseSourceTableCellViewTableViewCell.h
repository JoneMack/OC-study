//
//  MainHouseSourceTableCellViewTableViewCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/13.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "House.h"

@interface MainHouseSourceTableCellViewTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *name;

@property (strong, nonatomic) IBOutlet UILabel *address;

@property (strong, nonatomic) IBOutlet UIImageView *zuobiao;

@property (strong, nonatomic) IBOutlet UILabel *distance;

@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *tag1;
@property (strong, nonatomic) IBOutlet UILabel *tag2;
@property (strong, nonatomic) IBOutlet UILabel *tag3;

@property (strong, nonatomic) IBOutlet UILabel *tag4;

@property (strong, nonatomic) IBOutlet UILabel *tag5;



@property (nonatomic , strong) UIView *separatorLine;

@property (strong, nonatomic) IBOutlet UIButton *zhibo;



@property (strong, nonatomic) House *house;


-(void) renderData:(House *)house;

-(void) hideDistance;


@end