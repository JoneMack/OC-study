//
//  HouseSourceDetailSixCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/17.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "HouseSourceDetailSixCell.h"
#import "MainHouseSourceTableCellViewTableViewCell.h"
#import "HouseSourceDetailViewController.h"

static NSString *houseSourceDetailRecommendCellId = @"houseSourceDetailRecommendCellId";

@implementation HouseSourceDetailSixCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void) renderData:(CGRect)frame houses:(NSArray<House *> *)houses navigationController:(UINavigationController *)navigationController
{
    self.houses = houses;
    self.navigationController = navigationController;
    
    if(self.recommendTableView == nil){
        
        self.recommendTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.recommendTableView.delegate = self;
        self.recommendTableView.dataSource = self;
        
        UINib *nib = [UINib nibWithNibName:@"MainHouseSourceTableCellViewTableViewCell" bundle:nil];
        [self.recommendTableView registerNib:nib
                      forCellReuseIdentifier:houseSourceDetailRecommendCellId];
        
        [self.recommendTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.recommendTableView setScrollEnabled:NO];
        [self.contentView addSubview:self.recommendTableView];
    }else{
        [self.recommendTableView reloadData];
    }
    
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.houses count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainHouseSourceTableCellViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:houseSourceDetailRecommendCellId forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    House *house = self.houses[indexPath.row];
    [cell renderData:house];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    House *house = self.houses[indexPath.row];
    HouseSourceDetailViewController *detailViewController = [[HouseSourceDetailViewController alloc] init];
    detailViewController.houseId= house.houseId;
    detailViewController.roomId = house.roomsID;
    detailViewController.rentType = house.rentType;
    [self.navigationController pushViewController:detailViewController animated:YES];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
