//
//  SubwayLineViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubwayLine.h"

@interface SubwayLineViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>


@property (strong , nonatomic) HeaderView *headerView;
@property (strong, nonatomic) IBOutlet UIView *headerBlockView;

@property (strong, nonatomic) IBOutlet UITableView *leftTableView;

@property (strong, nonatomic) IBOutlet UIView *middleLine;

@property (strong, nonatomic) IBOutlet UITableView *rightTableView;

@property (strong, nonatomic) NSArray<SubwayLine *> *subwayLines;

@property (strong, nonatomic) NSString *currentSelectSubwayLine;
@property (assign, nonatomic) int currentSelectSubwayLineRow;
@property (strong, nonatomic) NSString *currentSelectStation;
@property (assign, nonatomic) int currentSelectStationRow;

@property (strong, nonatomic) NSString *selectedSubwayLine;
@property (strong, nonatomic) NSString *selectedStation;




@end
