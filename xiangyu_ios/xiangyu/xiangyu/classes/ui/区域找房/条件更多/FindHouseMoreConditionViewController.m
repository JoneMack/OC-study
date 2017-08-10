//
//  FindHouseMoreConditionViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/15.
//  Copyright © 2016年 相寓. All rights reserved.
//

#define live_flag_selected    1010
#define live_flag_unselect    1011


#import "FindHouseMoreConditionViewController.h"
#import "FindHouseMoreConditionTableViewCell.h"
#import "FindHouseMoreOtherConditionTableViewCell.h"
#import "SelectLiveFlagCell.h"
#import "AreaFindHousesViewController.h"
#import "SubwayFindHousesViewController.h"

@interface FindHouseMoreConditionViewController ()

@end

static NSString *findHouseMoreConditionCellId = @"findHouseMoreConditionCellId";
static NSString *findHouseMoreConditionFooterId = @"findHouseMoreConditionFooterId";
static NSString *selectLiveFlagCellId = @"selectLiveFlagCellId";


@implementation FindHouseMoreConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self convertParams];
    
    self.headerView = [[HeaderView alloc] initWithTitle:@"更多"
                                   navigationController:self.navigationController];
    self.headerView.frame = CGRectMake(0, 0, screen_width, 64);
    [self.headerView.rightBtn setTitle:@"重置" forState:UIControlStateNormal];
    [self.headerView.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.headerView.rightBtn setHidden:NO];
    [self.headerView.rightBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:self.headerView];
    
    [self.headerView.rightBtn addTarget:self action:@selector(resetCondition) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.bottomY, screen_width, screen_height - self.headerView.bottomY - 49) style:UITableViewStylePlain];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    UINib *nib = [UINib nibWithNibName:@"FindHouseMoreConditionTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:findHouseMoreConditionCellId];
    
    nib = [UINib nibWithNibName:@"FindHouseMoreOtherConditionTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:findHouseMoreConditionFooterId];
    
    
    nib = [UINib nibWithNibName:@"SelectLiveFlagCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:selectLiveFlagCellId];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.bottomView = [UIView new];
    self.bottomView.frame = CGRectMake(0, screen_height-49, screen_width, 49);
    [self.bottomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.bottomView];
    
    self.search = [UIButton new];
    self.search.frame = CGRectMake(10, screen_height-49, screen_width-20, 39);
    [self.search setTitle:@"立 即 筛 选" forState:UIControlStateNormal];
    [self.search setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
    [self.search.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.search.layer.masksToBounds = YES;
    self.search.layer.cornerRadius = 5;
    [self.view addSubview:self.search];
    [self.search addTarget:self action:@selector(search4Condition) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGRect pickerViewFrame = CGRectMake(0, self.view.bottomY, screen_width, screen_height-64);
    self.pickerView = [[SelectPickerView alloc] initWithFrame:pickerViewFrame];
    self.pickerView.delegate = self;
    [self.view addSubview:self.pickerView];
    
}

-(void) convertParams
{
    
    if([self.rentType isEqualToString:@"1"]){
        self.rentType = @"整租";
    }else if([self.rentType isEqualToString:@"2"]){
        self.rentType = @"合租";
    }
    
    if([self.houseType isEqualToString:@"1"]){
        self.houseType = @"一居";
    }else if([self.houseType isEqualToString:@"2"]){
        self.houseType = @"两居";
    }else if([self.houseType isEqualToString:@"3"]){
        self.houseType = @"三居";
    }else if([self.houseType isEqualToString:@"4+"]){
        self.houseType = @"四居及以上";
    }
    
    if([self.orderByType isEqualToString:@"priceASC"]){
        self.orderByType = @"租金从低到高";
    }else if([self.orderByType isEqualToString:@"priceDESC"]){
        self.orderByType = @"租金从高到低";
    }else if([self.orderByType isEqualToString:@"areaASC"]){
        self.orderByType = @"面积从小到大";
    }else if([self.orderByType isEqualToString:@"areaDESC"]){
        self.orderByType = @"面积从大到小";
    }
    
}


#pragma mark   返回 section 的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark   返回每个 section 中 cell 的个数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 4){
        return 124;
    }
    return 55;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2){
        FindHouseMoreConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:findHouseMoreConditionCellId forIndexPath:indexPath];
        if(indexPath.row == 0){
            [cell.conditionName setText:@"租住方式"];
            if([NSStringUtils isNotBlank:self.rentType]){
                [cell.conditionVal setText:self.rentType];
            }
        }else if(indexPath.row == 1){
            [cell.conditionName setText:@"户型居室"];
            if([NSStringUtils isNotBlank:self.houseType]){
                [cell.conditionVal setText:self.houseType];
            }
            
        }else if(indexPath.row == 2){
            [cell.conditionName setText:@"显示顺序"];
            if([NSStringUtils isNotBlank:self.orderByType]){
                [cell.conditionVal setText:self.orderByType];
            }
            
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    if(indexPath.row == 3){
        SelectLiveFlagCell *cell = [tableView dequeueReusableCellWithIdentifier:selectLiveFlagCellId forIndexPath:indexPath];
        if([NSStringUtils isBlank:self.liveFlag]){
            
            [cell setTag:live_flag_unselect];
            [cell.liveFlagBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
        }else{
            [cell setTag:live_flag_selected];
            [cell.liveFlagBtn setImage:[UIImage imageNamed:@"selected_purple"] forState:UIControlStateNormal];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    FindHouseMoreOtherConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:findHouseMoreConditionFooterId
                                                                                     forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell renderData:self.searchTab];
    
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        NSArray<NSString *> *params = @[@"不限" , @"合租" , @"整租" ];
        [self.pickerView renderParams:params type:@"租住方式"];
    }else if(indexPath.row == 1){
        NSArray<NSString *> *params = @[@"不限" , @"一居" , @"两居" , @"三居" , @"四居及以上" ];
        [self.pickerView renderParams:params type:@"户型居室"];
    }else if(indexPath.row == 2){
        NSArray<NSString *> *params = @[@"不限" , @"租金从低到高" , @"租金从高到低" , @"面积从小到大" , @"面积从大到小" ];
        [self.pickerView renderParams:params type:@"显示顺序"];
    }else if(indexPath.row == 3){
        
    }
}


-(void) selectedVal:(NSString *)val type:(NSString *)type
{
    if([type isEqualToString:@"租住方式"]){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        FindHouseMoreConditionTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.conditionVal setText:val];
        
    }else if([type isEqualToString:@"户型居室"]){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        FindHouseMoreConditionTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.conditionVal setText:val];
    }else if([type isEqualToString:@"显示顺序"]){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        FindHouseMoreConditionTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.conditionVal setText:val];
    }
}

-(void) resetCondition{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    FindHouseMoreConditionTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.conditionVal setText:@"不限"];
    
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.conditionVal setText:@"不限"];
    
    indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.conditionVal setText:@"不限"];
    
    indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    FindHouseMoreOtherConditionTableViewCell *fifthCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [fifthCell resetCondition];
    
}

-(void) search4Condition{
    
    // 租住方式
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    FindHouseMoreConditionTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *rentType = cell.conditionVal.text;
    if([rentType isEqualToString:@"不限"]){
        rentType = @"";
    }else if([rentType isEqualToString:@"整租"]){
        rentType = @"1";
    }else if([rentType isEqualToString:@"合租"]){
        rentType = @"2";
    }
    
    // 户型居室
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *houseType =  cell.conditionVal.text;
    if([houseType isEqualToString:@"一居"]){
        houseType = @"1";
    }else if([houseType isEqualToString:@"两居"]){
        houseType = @"2";
    }else if([houseType isEqualToString:@"三居"]){
        houseType = @"3";
    }else if([houseType isEqualToString:@"四居及以上"]){
        houseType = @"4+";
    }else{
        houseType = @"";
    }
    
    
    // 显示顺序
    indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *orderByType =  cell.conditionVal.text;
    if([orderByType isEqualToString:@"不限"]){
        orderByType = @"";
    }else if([orderByType isEqualToString:@"租金从低到高"]){
        orderByType = @"priceASC";
    }else if([orderByType isEqualToString:@"租金从高到低"]){
        orderByType = @"priceDESC";
    }else if([orderByType isEqualToString:@"面积从小到大"]){
        orderByType = @"areaASC";
    }else if([orderByType isEqualToString:@"面积从大到小"]){
        orderByType = @"areaDESC";
    }

    // 只看有直播的房源
    indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    SelectLiveFlagCell *selectLiveFlagCell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *liveFlag = [selectLiveFlagCell getStatus];
    
    // 其它条件
    indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    FindHouseMoreOtherConditionTableViewCell *fifthCell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSMutableArray *searchTag = [fifthCell getSearchTag];
    
    // TODO : 此地需要判断是区域找房过来的，还是地铁找房过来的
    UIViewController *viewController = [self getLastViewController];
    if([viewController isKindOfClass:[AreaFindHousesViewController class]]){
        AreaFindHousesViewController *areaFindHousesViewController = (AreaFindHousesViewController *)[self getLastViewController];
        areaFindHousesViewController.rentType = rentType;
        areaFindHousesViewController.houseType = houseType;
        areaFindHousesViewController.orderByType = orderByType;
        areaFindHousesViewController.liveFlg = liveFlag;
        areaFindHousesViewController.searchTab = searchTag;
        [areaFindHousesViewController transformEvent:event_load_data_init_load];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        SubwayFindHousesViewController *subwayFindHousesViewController = (SubwayFindHousesViewController *)[self getLastViewController];
        subwayFindHousesViewController.rentType = rentType;
        subwayFindHousesViewController.houseType = houseType;
        subwayFindHousesViewController.orderByType = orderByType;
        subwayFindHousesViewController.liveFlg = liveFlag;
        subwayFindHousesViewController.searchTab = searchTag;
        [subwayFindHousesViewController transformEvent:event_load_data_init_load];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
