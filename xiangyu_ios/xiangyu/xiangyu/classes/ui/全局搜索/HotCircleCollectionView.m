//
//  HotCircleCollectionView.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/5.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "HotCircleCollectionView.h"
#import "CircleStore.h"
#import "AreaFindHousesViewController.h"

static NSString *hotCircleCellId = @"hotCircleCellId";

@implementation HotCircleCollectionView

-(instancetype) init{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;  // 水平滚动

    flowLayout.minimumLineSpacing = 0;  // cell之间的间距
    flowLayout.minimumInteritemSpacing = 0;
//    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    self = [super initWithFrame:CGRectMake(10, 10, screen_width-20, 22) collectionViewLayout:flowLayout];
    if(self){
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:hotCircleCellId];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self loadData];
//        [self setScrollEnabled:NO];
    }
    return self;
}

-(void) loadData{
    
    [[CircleStore sharedStore] getHotCircles:^(NSArray<HotCircle *> *hotCircles, NSError *err) {
        if(err == nil){
            self.hotCircles = hotCircles;
            [self reloadData];
        }else{
        }
    }];
}


#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.hotCircles.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotCircleCellId
                                                                                     forIndexPath:indexPath];
    HotCircle *hotCircle = self.hotCircles[indexPath.row];
    
    UILabel *text = [UILabel new];
    [text setText:hotCircle.buscirName];
    [text setFont:[UIFont systemFontOfSize:13]];
    text.frame = CGRectMake(0, 0, [text realWidth]+30, 22);
    [text setTextColor:[ColorUtils colorWithHexString:text_color_gray]];
    [cell.contentView addSubview:text];
    return cell;
}

//定义每个Item 的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotCircle *hotCircle = self.hotCircles[indexPath.row];
    return CGSizeMake(hotCircle.buscirName.length * 10+30, 22);
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    HotCircle *hotCircle = self.hotCircles[indexPath.row];
    AreaFindHousesViewController *areaFindHousesViewController = [[AreaFindHousesViewController alloc] init];
    areaFindHousesViewController.searchStr = hotCircle.buscirName;
    [self.navigationController pushViewController:areaFindHousesViewController animated:YES];
    
}


@end
