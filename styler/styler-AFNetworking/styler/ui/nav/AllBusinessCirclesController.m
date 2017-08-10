//
//  AllBusinessCirclesController.m
//  styler
//
//  Created by System Administrator on 14-2-15.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "AllBusinessCirclesController.h"
#import "CityStore.h"
#import "StylistStore.h"
#import "BusinessCircles.h"
#import "StylistListController.h"
#import "CityDistrictCell.h"
#import "UIViewController+Custom.h"
#import "OrganizationListController.h"
#import "NSString+stringPlus.h"

@interface AllBusinessCirclesController ()

@end

@implementation AllBusinessCirclesController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setRightSwipeGestureAndAdaptive];
    [self initView];
    [self initHeader];
    [self initDistrictListTable];
}

-(void) initView{
    [self.navigationController.navigationBar setHidden:YES];
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    self.view.autoresizesSubviews = NO;
}

-(void) initHeader{
    self.header = [[HeaderView alloc] initWithTitle:page_name_all_businesscircles navigationController:self.navigationController];
    [self.view addSubview:self.header];
}

-(void) initDistrictListTable{
    CGRect frame = self.districtListTable.frame;
    frame.origin.y = self.header.frame.size.height;
    frame.size.width = self.view.frame.size.width/2;
    frame.size.height = UIScreen.mainScreen.bounds.size.height - frame.origin.y;
    self.districtListTable.frame = frame;
    self.districtListTable.separatorStyle = UITableViewCellSeparatorStyleNone;

    [[CityStore sharedStore] getCityDistrictList:^(NSArray *districts, NSError *err) {
        self.districts = [CityDistrict clearNoStylistDistrictAndBusinessCircles:districts];
        [self.indicator stopAnimating];
        [self.districtListTable reloadData];
        self.selectedDistrict = self.districts[0];
        [self.districtListTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        [self initBusinessCircleLitTable];
        [self.businessCirclesListTable reloadData];
    } cityName:@"北京"];
}

-(void) initBusinessCircleLitTable{
    self.businessCirclesListTableBg.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    CGRect frame = self.businessCirclesListTableBg.frame;
    frame.origin.y = self.districtListTable.frame.origin.y;
    frame.size.height = self.districtListTable.frame.size.height;
    self.businessCirclesListTableBg.frame = frame;
    
    frame = self.businessCirclesListTable.frame;
    frame.size.height = self.districtListTable.frame.size.height;
    frame.origin.x -= splite_line_height;
    self.businessCirclesListTable.frame = frame;
    self.districtListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.districtListTable) {
        return self.districts.count;
    }
    return self.selectedDistrict.businessCircles.count;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.districtListTable){
        return 80;
    }
    return 40;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.districtListTable){
        CityDistrictCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistrictListTableCell"];
        if (cell == nil) {
            cell = [[CityDistrictCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CityDistrict *district = self.districts[indexPath.row];
        cell.textLabel.text = district.name;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        UIView *spliteLine = [[UIView alloc] initWithFrame:CGRectMake(0, 79, self.view.frame.size.width/2, splite_line_height)];
        spliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        [cell addSubview:spliteLine];
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCircleListTableCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 140, 30)];
    label.text = [self.selectedDistrict.businessCircles[indexPath.row] name];
    if (cell.selected) {
        [label setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
    }else{
        [label setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    }
    [label setFont:[UIFont systemFontOfSize:16]];
    label.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:label];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.districtListTable) {
        self.selectedDistrict = self.districts[indexPath.row];
        
        [MobClick event:log_event_name_select_district attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.selectedDistrict.name, @"城区", nil]];
        
        [self.businessCirclesListTable reloadData];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.textLabel setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        BusinessCircles *businessCircles = self.selectedDistrict.businessCircles[indexPath.row];
    
        [MobClick event:log_event_name_select_businesscirlces attributes:[NSDictionary dictionaryWithObjectsAndKeys:businessCircles.name, @"商圈", nil]];
        NSMutableString *businessCirclesName = [[NSMutableString alloc] initWithString:businessCircles.name];
        [businessCirclesName replaceOccurrencesOfString:@"/" withString:@"__" options:NSCaseInsensitiveSearch range:NSMakeRange(0, businessCirclesName.length)];
        NSString *urlStr = [NSString stringWithFormat:@"/organizations/businessCircles,%@", [businessCirclesName urlEncode]];
        OrganizationListController *olc = [[OrganizationListController alloc] initWithUrl:urlStr title:[NSString stringWithFormat:@"%@附近的美发沙龙",businessCircles.name]];
        olc.orderType = organization_order_by_business_circle;
        [self.navigationController pushViewController:olc animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.districtListTable) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.textLabel setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    }
}

-(NSString *)getPageName{
    return page_name_all_businesscircles;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
