//
//  AllBrandController.m
//  styler
//
//  Created by System Administrator on 14-2-14.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "AllBrandController.h"
#import "Brand.h"
#import "Organization.h"
#import "OrganizationStore.h"
#import "BrandCell.h"
#import "StylistListController.h"
#import "StylistStore.h"
#import "UIViewController+Custom.h"
#import "LoadingStatusView.h"
#import "OrganizationListController.h"


@interface AllBrandController ()

@end

@implementation AllBrandController
#define brand_cell_header_height 30
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
    [self initHeader];
    [self initBrandListTable];
    [self renderBrandListTable];
}

-(void) initHeader{
    self.header = [[HeaderView alloc] initWithTitle:page_name_all_brand navigationController:self.navigationController];
    [self.view addSubview:self.header];
}

-(void) initBrandListTable
{
    CGRect frame = self.brandListTable.frame;
    frame.origin.y = self.header.frame.size.height;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = self.view.frame.size.height - self.header.frame.size.height;
    self.brandListTable.frame = frame;
    self.brandListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //改变索引的颜色
    self.brandListTable.sectionIndexColor = [ColorUtils colorWithHexString:light_gray_text_color];
    //改变索引选中的背景颜色
    self.brandListTable.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    //    索引的背景
    self.brandListTable.sectionIndexBackgroundColor = [UIColor whiteColor];
    
    [self.brandListTable registerClass:[BrandCell class] forCellReuseIdentifier:@"BrandCell"];
    
}


-(void)renderBrandListTable{
    LoadingStatusView *loading = [[LoadingStatusView alloc] initWithFrame:loading_frame];
    [loading updateStatus:network_status_loading animating:YES];
    [self.view addSubview:loading];
    [OrganizationStore getBrands:^(NSArray *brands, NSError *err) {
        if(err == nil){
            self.brands = [[NSMutableArray alloc] initWithArray:brands];
            [self configureSections];
            [self.brandListTable reloadData];

            loading.hidden = YES;
        }else{
            [loading updateStatus:network_unconnect_note animating:NO];
        }
    } pageNo:1 pageSize:1000];
}

-(void)configureSections
{
    self.theCollation = [UILocalizedIndexedCollation currentCollation];
    int index,sectionTitlesCount = [[self.theCollation sectionTitles] count];
    self.sectionArray = [[NSMutableArray alloc] init];
    self.sectionIndexTitleArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *newSectionArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    for (index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *itemArray = [[NSMutableArray alloc] init];
        [newSectionArray addObject:itemArray];
    }
    for (Brand *brand in self.brands) {
        NSInteger sectionNum = [self.theCollation sectionForObject:brand collationStringSelector:@selector(name)];
        [[newSectionArray objectAtIndex:sectionNum] addObject:brand];
    }
    for (index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *itemArray = [newSectionArray objectAtIndex:index];
        NSArray *sortedBrandItemArray = [self.theCollation sortedArrayFromArray:itemArray collationStringSelector:@selector(name)];
        if (sortedBrandItemArray.count>0) {
            //依次添加数组到self.sectionArray，组成二维数组
            [self.sectionArray addObject:sortedBrandItemArray];
            //每个section的title
            [self.sectionIndexTitleArray addObject:[self.theCollation.sectionIndexTitles objectAtIndex:index]];
        }
    }
}

#pragma mark -----dataSource----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.sectionArray[section] count]+1)/2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return brand_cell_height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return brand_cell_header_height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, brand_cell_header_height)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(general_margin, 0, screen_width, brand_cell_header_height)];
    title.text = self.sectionIndexTitleArray[section];
    title.font = [UIFont systemFontOfSize:default_font_size];
    title.textColor = [ColorUtils colorWithHexString:black_text_color];
    title.backgroundColor = [UIColor clearColor];
    [view addSubview:title];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, splite_line_height)];
    topLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [view addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, brand_cell_header_height, screen_width, splite_line_height)];
    bottomLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [view addSubview:bottomLine];
    return view;
}

//品牌索引
-(NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionIndexTitleArray;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BrandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //左边品牌
    Brand *leftBrand = [[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:2*indexPath.row];
    cell.leftBrandItem.delegate = self;
    //右边品牌
    Brand *rightBrand = nil;
    if ([self.sectionArray[indexPath.section] count]/2 > indexPath.row) {
        rightBrand = [[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:2*indexPath.row + 1];
        cell.rightBrandItem.delegate = self;
    }
    
    //渲染cell
    [cell initLeftBrand:leftBrand rightBrand:rightBrand];
    return cell;
}

#pragma mark ------- OrganizationDelegate---
-(void)gotoSameOrganizationListController:(UIViewController *)viewController
{
    
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark ---delegate----
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString *)getPageName{
    return page_name_all_brand;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
