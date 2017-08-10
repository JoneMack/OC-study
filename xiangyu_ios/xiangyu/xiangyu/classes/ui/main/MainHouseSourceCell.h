//
//  MainHouseSourceCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/8/1.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "House.h"

@interface MainHouseSourceCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *name;

@property (strong, nonatomic) IBOutlet UILabel *address;

@property (strong, nonatomic) IBOutlet UIButton *distance;


@property (strong, nonatomic) IBOutlet UILabel *price;


@property (strong, nonatomic) IBOutlet UILabel *tag1;

@property (strong, nonatomic) IBOutlet UILabel *tag2;

@property (strong, nonatomic) IBOutlet UILabel *tag3;

@property (strong, nonatomic) IBOutlet UILabel *tag4;

@property (strong, nonatomic) IBOutlet UILabel *tag5;


@property (strong, nonatomic) IBOutlet UILabel *houseStyle;


@property (nonatomic , strong) IBOutlet UIView *separatorLine;

@property (strong, nonatomic) IBOutlet UIButton *zhibo;



@property (strong, nonatomic) House *house;


-(void) renderData:(House *)house;

-(void) hideDistance;



@end
