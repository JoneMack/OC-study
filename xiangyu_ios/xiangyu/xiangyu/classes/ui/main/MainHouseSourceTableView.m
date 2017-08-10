//
//  MainHouseSourceTableView.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/13.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MainHouseSourceTableView.h"
#import "MainHouseSourceTableCellViewTableViewCell.h"
#import "MainRecommendHouseSourceCell.h"
#import "HouseSourceDetailViewController.h"
#import "AreaFindHousesViewController.h"
#import "House.h"


static NSString *houseSourceNearCellId = @"houseSourceNearCellId";
static NSString *houseSourceRecommendCellId = @"houseSourceRecommendCellId";


@implementation MainHouseSourceTableView

-(instancetype) init
{
    self = [super init];
    if(self){
        
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.scrollEnabled = NO;
        self.dataSource = self;
        self.delegate = self;
        self.houseSourceType = house_source_type_recommend;
        if([self.houseSourceType isEqualToString:house_source_type_recommend]){
            self.frame = CGRectMake(0, 0, screen_width, 1150+20+39-230);
            
        }else{
            self.frame = CGRectMake(0, 0, screen_width, 139*[self.nearHouses count] +62+39);
        }
        
        UINib *nearNib = [UINib nibWithNibName:@"MainHouseSourceTableCellViewTableViewCell" bundle:nil];
        [self registerNib:nearNib forCellReuseIdentifier:houseSourceNearCellId];
        
        UINib *recommendNib = [UINib nibWithNibName:@"MainRecommendHouseSourceCell" bundle:nil];
        [self registerNib:recommendNib forCellReuseIdentifier:houseSourceRecommendCellId];
        
        
    }
    return self;
}

#pragma mark   返回 section 的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark   返回每个 section 中 cell 的个数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([self.houseSourceType isEqualToString:house_source_type_recommend]){
        return 2;
    }else{
        return [self.nearHouses count];
    }

}


#pragma mark  返回 section 的高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 39;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if([self.houseSourceType isEqualToString:house_source_type_recommend]){
        return 20;
    }else{
        return 62;
    }
}

#pragma mark  返回 cell 的高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.houseSourceType isEqualToString:house_source_type_recommend]){
        return 230;
    }else{
        return 136;
    }
}

#pragma mark   渲染 section header view
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] init];
    [view.contentView setBackgroundColor:[UIColor whiteColor]];
    
    self.recommendHouseSourceBtn = [UIButton new];
    self.recommendHouseSourceBtn.frame = CGRectMake(10, 0, screen_width/2-10, 39);
    [self.recommendHouseSourceBtn setTitle:@"推荐房源" forState:UIControlStateNormal];
    [self.recommendHouseSourceBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:self.recommendHouseSourceBtn];
    
    [self.recommendHouseSourceBtn addTarget:self
                                     action:@selector(selectedRecommendHouseSource) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *separatorLine = [[UIView alloc] init];
    [separatorLine setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color ]];
    separatorLine.frame = CGRectMake(screen_width/2-0.5, 10, 0.5, 39-20);
    [view.contentView addSubview:separatorLine];
    
    self.nearHouseSourceBtn = [UIButton new];
    self.nearHouseSourceBtn.frame = CGRectMake(screen_width/2, 0, screen_width/2-10, 39);
    [self.nearHouseSourceBtn setTitle:@"附近房源" forState:UIControlStateNormal];
    [self.nearHouseSourceBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:self.nearHouseSourceBtn];
    
    [self.nearHouseSourceBtn addTarget:self action:@selector(selectedNearHouseSourceBtn) forControlEvents:UIControlEventTouchUpInside];
    
    separatorLine = [[UIView alloc] init];
    [separatorLine setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color ]];
    separatorLine.frame = CGRectMake(0, 38.5, screen_width, splite_line_height);
    [view.contentView addSubview:separatorLine];
    
    if([self.houseSourceType isEqualToString:house_source_type_recommend]){
        [self.recommendHouseSourceBtn setTitleColor:[ColorUtils colorWithHexString:text_color_purple]
                                           forState:UIControlStateNormal];
        
        [self.nearHouseSourceBtn setTitleColor:[ColorUtils colorWithHexString:text_color_gray]
                                      forState:UIControlStateNormal];
        
    }else{
        [self.recommendHouseSourceBtn setTitleColor:[ColorUtils colorWithHexString:text_color_gray]
                                           forState:UIControlStateNormal];
        
        [self.nearHouseSourceBtn setTitleColor:[ColorUtils colorWithHexString:text_color_purple]
                                      forState:UIControlStateNormal];
    }
    
    return view;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if([self.houseSourceType isEqualToString:house_source_type_recommend]){
        UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] init];
        return view;
    }else{
        UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] init];
        UILabel *textView = [UILabel new];
        [view.contentView setBackgroundColor:[ColorUtils colorWithHexString:@"e6e6e6"]];
        [textView setText:@"点击查看附近更多房源..."];
        [textView setTextColor:[ColorUtils colorWithHexString:text_color_purple]];
        [textView setFont:[UIFont systemFontOfSize:12]];
        textView.frame = CGRectMake(0, 20, screen_width, 12);
        [textView setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:textView];
        return view;
    }
    
    
}

#pragma mark 渲染 cell
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.houseSourceType isEqualToString:house_source_type_recommend]){
        MainRecommendHouseSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:houseSourceRecommendCellId];
        if(indexPath.row == 0){
            [cell.pic setImage:[UIImage imageNamed:@"yangguangfang"]];
        }else if(indexPath.row == 1){
            [cell.pic setImage:[UIImage imageNamed:@"kuandafang"]];
        }
//        else if(indexPath.row == 0){
////            [cell.pic setImage:[UIImage imageNamed:@"tongqinzhaofang"]];
//        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }else{
        House *house = self.nearHouses[indexPath.row];
        MainHouseSourceTableCellViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:houseSourceNearCellId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell renderData:house];
        return cell;
    }
}

/**
 * 点击了推荐房源
 */
- (void) selectedRecommendHouseSource
{
    self.houseSourceType = house_source_type_recommend;
    [self.fydelegate changeHouseSourceType:@"test" height:100];
    [self reloadData];
    
}

/**
 * 点击了附近房源
 */
-(void) selectedNearHouseSourceBtn
{
    self.houseSourceType = house_source_type_near;
    [self.fydelegate changeHouseSourceType:@"test" height:100];
    [self reloadData];

}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.houseSourceType isEqualToString:house_source_type_near]){
        House *house = self.nearHouses[indexPath.row];
        HouseSourceDetailViewController *detailController = [HouseSourceDetailViewController new];
        detailController.houseId= house.houseId;
        detailController.roomId = house.roomsID;
        detailController.rentType = house.rentType;
        detailController.house = house;
        [self.navigationController pushViewController:detailController animated:YES];
    }else{
        if( indexPath.row == 0){
            // 阳光房
            AreaFindHousesViewController *areaController = [AreaFindHousesViewController new];
            areaController.recommendType = @"rientation";
            [self.navigationController pushViewController:areaController animated:YES];
        }else if( indexPath.row == 1){
            // 宽大房
            AreaFindHousesViewController *areaController = [AreaFindHousesViewController new];
            areaController.recommendType = @"area";
            [self.navigationController pushViewController:areaController animated:YES];
        }
    }
}


@end
