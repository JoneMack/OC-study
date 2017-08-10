//
//  FindHouseMoreOtherConditionTableViewCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/16.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindHouseMoreOtherConditionTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIButton *duwei;

@property (strong, nonatomic) IBOutlet UIButton *duyang;

@property (strong, nonatomic) IBOutlet UIButton *shouzu;

@property (strong, nonatomic) IBOutlet UIButton *xuequfang;

@property (strong, nonatomic) IBOutlet UIButton *nearDitie;

@property (strong, nonatomic) IBOutlet UIButton *chaonan;


@property (nonatomic , strong) UIView *separatorLine;

-(void) resetCondition;

-(NSMutableArray *) getSearchTag;

-(void) renderData:(NSMutableArray *) searchTab;



@end
