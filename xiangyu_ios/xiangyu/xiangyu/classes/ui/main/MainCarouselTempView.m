//
//  MainCarouselView.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/8.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MainCarouselTempView.h"
#import "MainCarouselCollectionViewCell.h"
#import "Banner.h"
#import "GlobalSearchViewController.h"
#import "ActivePageViewController.h"

#define cellMaxSections 100
#define carousel_height (screen_width/5*4)

static NSString *mainCarouselCellId = @"mainCarouselCellId";

@implementation MainCarouselTempView

-(instancetype) initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;  // 水平滚动
    flowLayout.itemSize = CGSizeMake(screen_width , frame.size.height);
    flowLayout.minimumLineSpacing = 0;  // 取消cell之间的间距
    self = [super initWithFrame:frame];
    if(self){
        self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        self.frame = frame;
        [self initView];
        [self initSearchView];
    }
    return self;
}

-(void) initView{
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // 设置自动分页
    self.collectionView.pagingEnabled = YES;
    // 是否显示水平滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    // 设置是否有边界
    self.collectionView.bounces = NO;
    [self addSubview:self.collectionView];
    
    
    UINib *nib = [UINib nibWithNibName:@"MainCarouselCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:mainCarouselCellId];
    
    
}

-(void) initSearchView{
    CGRect frame = CGRectMake(20, carousel_height - 50, screen_width - 40, 40);
    
    self.searchBtn = [[UIButton alloc] initWithFrame:frame];
    self.searchBtn.layer.cornerRadius=20;
    [self.searchBtn setTitle:@"请输入商圈、小区名、地铁站等......" forState:UIControlStateNormal];
    [self.searchBtn setTitleColor:[ColorUtils colorWithHexString:@"a6a6a6"] forState:UIControlStateNormal];
    [self.searchBtn setBackgroundColor:[UIColor whiteColor]];
    [self.searchBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    self.searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft; // 文字居左
    [self addSubview:self.searchBtn];
    
    [self.searchBtn addTarget:self action:@selector(globalSearch) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MainCarouselCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:mainCarouselCellId forIndexPath:indexPath];
    [cell.imageView setImage:[UIImage imageNamed:@"index_header_img"]];
    return cell;
}


-(void) globalSearch
{
    GlobalSearchViewController *globalSearchController = [[GlobalSearchViewController alloc] init];
    [self.navigationController pushViewController:globalSearchController animated:YES];
}



@end
