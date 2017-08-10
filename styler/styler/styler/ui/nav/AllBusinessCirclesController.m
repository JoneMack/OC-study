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
#import "OrganizationFilter.h"
#import "OrganizationSpecialOfferListViewController.h"

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
    frame.size.width = self.view.frame.size.width*0.4375;
    frame.size.height = UIScreen.mainScreen.bounds.size.height - frame.origin.y;
    self.districtListTable.frame = frame;
    self.districtListTable.separatorStyle = UITableViewCellSeparatorStyleNone;

    [[CityStore sharedStore] getCityDistrictList:^(NSArray *districts, NSError *err) {
        self.districts = [CityDistrict clearNoStylistDistrictAndBusinessCircles:districts];
        [self.indicator stopAnimating];
        self.selectedCityDistrictRow = 0;
        self.selectedDistrict = self.districts[0];
        [self.districtListTable reloadData];
        
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
    frame.origin.x -=splite_line_height;
    frame.size.width = screen_width*0.5625;
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
    return 37;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.districtListTable){
        CityDistrictCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistrictListTableCell"];
        if (cell == nil) {
            cell = [[CityDistrictCell alloc] init];
            [cell.contentView setBackgroundColor:[ColorUtils colorWithHexString:light_gray_color]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
        }
        
        CityDistrict *district = self.districts[indexPath.row];
        cell.textLabel.text = district.name;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        UIView *spliteLine = [[UIView alloc] initWithFrame:CGRectMake(20, 36, self.view.frame.size.width/2, splite_line_height)];
        spliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        [cell addSubview:spliteLine];
        if (self.selectedCityDistrictRow == indexPath.row) {
            [cell.textLabel setTextColor:[ColorUtils colorWithHexString:red_default_color]];
            [cell.selectedView setHidden:NO];
        }else{
            [cell.textLabel setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
            [cell.selectedView setHidden:YES];
        }
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCircleListTableCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 140, 30)];
    label.text = [self.selectedDistrict.businessCircles[indexPath.row] name];
    if ([label.text isEqualToString:self.selectedBusinessCircleName]) {
        [label setTextColor:[ColorUtils colorWithHexString:red_default_color]];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
    }else{
        [label setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    }
    [label setFont:[UIFont systemFontOfSize:16]];
    label.tag = [self genTagValue:indexPath.row];
    label.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:label];
    
    UIView *businessCircleSpliteLine = [[UIView alloc] initWithFrame:CGRectMake(20, 36.5, self.view.frame.size.width/2, splite_line_height)];
    businessCircleSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [cell addSubview:businessCircleSpliteLine];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.districtListTable) {
        
        // 清除上一次旧的
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.selectedCityDistrictRow inSection:0];
        CityDistrictCell *cell = (CityDistrictCell *)[tableView cellForRowAtIndexPath:lastIndexPath];
        [cell.textLabel setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
        [cell.selectedView setHidden:YES];
        
        // 处理新的
        self.selectedDistrict = self.districts[indexPath.row];
        self.selectedCityDistrictRow = indexPath.row;
        cell = (CityDistrictCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.textLabel setTextColor:[ColorUtils colorWithHexString:red_default_color]];
        [cell.selectedView setHidden:NO];
        
        [self.businessCirclesListTable reloadData];

        [MobClick event:log_event_name_select_district attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.selectedDistrict.name, @"城区", nil]];
        
    }else{
        
        // 清除上一次选择的商圈
        if (self.selectedDistrict.businessCircles.count >= self.selectedBusinessCircleRow+1) {
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.selectedBusinessCircleRow inSection:0];
            UITableViewCell *cell = [self.businessCirclesListTable cellForRowAtIndexPath:lastIndexPath];
            UILabel *labelView = (UILabel *)[cell viewWithTag:[self genTagValue:self.selectedBusinessCircleRow]];
            [labelView setTextColor:[ColorUtils colorWithHexString:gray_text_color]];  //在这里不用判断名字是否相同，改一下颜色也没关系
        }
        
        UITableViewCell *cell = [self.businessCirclesListTable cellForRowAtIndexPath:indexPath];
        UILabel *labelView = (UILabel *)[cell viewWithTag:[self genTagValue:indexPath.row]];
        [labelView setTextColor:[ColorUtils colorWithHexString:red_default_color]];
        self.selectedBusinessCircleRow = indexPath.row;
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        BusinessCircles *businessCircles = self.selectedDistrict.businessCircles[indexPath.row];
        self.selectedBusinessCircleName = businessCircles.name;
        [MobClick event:log_event_name_select_businesscirlces attributes:[NSDictionary dictionaryWithObjectsAndKeys:businessCircles.name, @"商圈", nil]];

        // 选择了商圈后进入到优惠列表页面
        OrganizationFilter *organizationFilter = [[OrganizationFilter alloc] initWithSelectedBusinessCircle:self.selectedDistrict.name selectedBusinessCircleId:businessCircles.id selectedBusinessCircleName:businessCircles.name];
        OrganizationSpecialOfferListViewController *organizationSpecialOfferListViewController = [[OrganizationSpecialOfferListViewController alloc] initWithOrganizationFilter:organizationFilter];
        
        [self.navigationController pushViewController:organizationSpecialOfferListViewController animated:YES];
    }
}

-(int) genTagValue:(int)rowValue{
    return rowValue + 1;
}

-(NSString *)getPageName{
    return page_name_all_businesscircles;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
