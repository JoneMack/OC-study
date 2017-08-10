//
//  AllBusinessCirclesController.h
//  styler
//
//  Created by System Administrator on 14-2-15.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "CityDistrict.h"

@interface AllBusinessCirclesController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) HeaderView *header;
@property (weak, nonatomic) IBOutlet UITableView *districtListTable;
@property (weak, nonatomic) IBOutlet UIView *businessCirclesListTableBg;
@property (weak, nonatomic) IBOutlet UITableView *businessCirclesListTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (strong, nonatomic) NSArray *districts;
@property int selectedCityDistrictRow;
@property (retain, nonatomic) CityDistrict *selectedDistrict;
@property (strong, nonatomic) NSString *selectedBusinessCircleName;
@property int selectedBusinessCircleRow;

@end
