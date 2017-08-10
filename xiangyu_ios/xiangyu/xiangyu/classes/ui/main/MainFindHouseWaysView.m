//
//  MainFindHouseWaysView.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/12.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MainFindHouseWaysView.h"
#import "MainFindWayCellView.h"
#import "AreaFindHousesViewController.h"
#import "MapFindHouseController.h"
#import "SubwayFindHousesViewController.h"
#import "PARKViewController.h"

static NSString *mainFindWayCellId = @"MainFindWayCellView";

@implementation MainFindHouseWaysView


-(instancetype) initWithFrame:(CGRect)frame navigationController:(UINavigationController *)navigationController{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;  // 水平滚动
    flowLayout.itemSize = CGSizeMake(screen_width/4 , frame.size.height);
    flowLayout.minimumLineSpacing = 0;  // 取消cell之间的间距
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    self.navigationController = navigationController;
    if(self){
        self.frame = frame;
        [self initView];
        self.separatorLine = [[UIView alloc] init];
        [self.separatorLine setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
        self.separatorLine.frame = CGRectMake(0, frame.size.height-0.5, screen_width, splite_line_height);
        [self addSubview:self.separatorLine];
    }
    
    return self;
}

-(void) initView{

    self.delegate = self;
    self.dataSource = self;
    self.pagingEnabled = NO;
    self.showsHorizontalScrollIndicator = NO;
    UINib *nib = [UINib nibWithNibName:@"MainFindWayCellView" bundle:nil];
    [self registerNib:nib forCellWithReuseIdentifier:mainFindWayCellId];
    
    [self setBackgroundColor:[UIColor whiteColor]];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark 一共有多少个items
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

#pragma mark 渲染cell
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MainFindWayCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:mainFindWayCellId
                                                                          forIndexPath:indexPath];
    if(indexPath.row == 0){
        [cell setLogoAndName:@"quyuzhaofang" name:@"区域找房"];
    }else if(indexPath.row == 1){
        [cell setLogoAndName:@"ditiezhaofang" name:@"地铁找房"];
    }else if(indexPath.row == 2){
        [cell setLogoAndName:@"xiangyupark" name:@"相寓PARK"];
    }else if(indexPath.row == 3){
        [cell setLogoAndName:@"dituzhaofang" name:@"地图找房"];
    }
    [cell.name setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    return cell;
}

#pragma mark 选择了cell的事件
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 3) {
        
        MapFindHouseController *mfvc = [[MapFindHouseController alloc] init];
        [self.navigationController pushViewController:mfvc animated:YES];
        
    }else if(indexPath.item == 2){
        
        PARKViewController *parkViewController = [[PARKViewController alloc] init];
        [self.navigationController pushViewController:parkViewController animated:YES];
        
    }else if(indexPath.item == 1){
        
        SubwayFindHousesViewController *subwayFindHousesViewController = [[SubwayFindHousesViewController alloc] init];
        [self.navigationController pushViewController:subwayFindHousesViewController animated:YES];
        
    }else{
        
        AreaFindHousesViewController *areaFindHousesViewController = [[AreaFindHousesViewController alloc] init];
        [self.navigationController pushViewController:areaFindHousesViewController animated:YES];
        
    }
}

@end
