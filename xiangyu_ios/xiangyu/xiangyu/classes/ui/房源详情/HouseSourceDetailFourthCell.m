//
//  HouseSourceDetailFourthCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/17.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "HouseSourceDetailFourthCell.h"
#import "HouseSourceDetailFourthCellTableSubCell.h"
#import "RoomShip.h"



static NSString *houseSourceDetailFourthCellTableSubCellId = @"houseSourceDetailFourthCellTableSubCellId";

@implementation HouseSourceDetailFourthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.heZuInfos.delegate = self;
    self.heZuInfos.dataSource = self;
    
    [self.heZuInfos setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.heZuInfos setScrollEnabled:NO];
    
    [self.heZuInfos registerClass:[HouseSourceDetailFourthCellTableSubCell class] forCellReuseIdentifier:houseSourceDetailFourthCellTableSubCellId];
    
    [self.contentView addSubview:self.heZuInfos];
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.houseInfo.roomShip count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41.5;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseSourceDetailFourthCellTableSubCell *cell = [tableView dequeueReusableCellWithIdentifier:houseSourceDetailFourthCellTableSubCellId forIndexPath:indexPath];
    NSArray<RoomShip *> *roomShips = [self.houseInfo getRoomShips];
    RoomShip *roomShip = roomShips[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell renderData:roomShip];
    return cell;
}



-(void) renderData:(HouseInfo *) houseInfo{

    
    self.houseInfo = houseInfo;
    
    [self.heZuInfos reloadData];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
