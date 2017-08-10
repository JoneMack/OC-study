//
//  HouseSourceDetailThirdCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/17.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "HouseSourceDetailThirdCell.h"
#import "HouseSourceIndoorIconCell.h"

static NSString *houseSourceIndoorIconCellId = @"houseSourceIndoorIconCellId";

@implementation HouseSourceDetailThirdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initCollectionView];
}


-(void) initCollectionView
{
    [self.icons setBackgroundColor:[UIColor whiteColor]];
    self.icons.delegate = self;
    self.icons.dataSource = self;
    self.icons.scrollEnabled = NO;
    UINib *nib = [UINib nibWithNibName:@"HouseSourceIndoorIconCell" bundle:nil];
    [self.icons registerNib:nib forCellWithReuseIdentifier:houseSourceIndoorIconCellId];
    
}


-(void) renderData:(HouseInfo *)houseInfo
{
    self.houseInfo = houseInfo;
    
    [self.mianji setText:[NSString stringWithFormat:@"%@㎡" , houseInfo.space]];
    [self.jushi setText:[NSString stringWithFormat:@"%@" , [houseInfo getFewRoom]]];
    [self.chaoxiang setText:[NSString stringWithFormat:@"%@" , houseInfo.houseOrientation]];
    [self.louceng setText:[NSString stringWithFormat:@"%@层" , houseInfo.floor ]];
    [self.icons reloadData];
    
}


#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(self.houseInfo != nil &&
       ([NSStringUtils isNotBlank:self.houseInfo.indoorsNames] || [NSStringUtils isNotBlank:self.houseInfo.indoorsJJNames])){
        NSArray *icons1 = [self.houseInfo.indoorsNames componentsSeparatedByString:@","];
        NSArray *icons2 = [self.houseInfo.indoorsJJNames componentsSeparatedByString:@","];
        self.totalIcons = [[NSMutableArray alloc] init];
        [self.totalIcons addObjectsFromArray:icons1];
        [self.totalIcons addObjectsFromArray:icons2];
        NSLog(@"collection count :%ld" , [self.totalIcons count]);
        return [self.totalIcons count];
    }else{
        NSLog(@"collection count :0");
        return 0;
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HouseSourceIndoorIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:houseSourceIndoorIconCellId
                                                                                     forIndexPath:indexPath];
    NSString *iconName = self.totalIcons[indexPath.row];
    [cell renderData:iconName];
    return cell;
}

//定义每个Item 的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((screen_width-40)/5, 50);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
