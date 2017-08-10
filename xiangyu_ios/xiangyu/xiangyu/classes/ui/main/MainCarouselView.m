//
//  MainCarouselView.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/8.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MainCarouselView.h"
#import "MainCarouselCollectionViewCell.h"
#import "Banner.h"
#import "GlobalSearchViewController.h"
#import "ActivePageViewController.h"

#define cellMaxSections 100
#define carousel_height (screen_width/5*4)

static NSString *mainCarouselCellId = @"mainCarouselCellId";

@implementation MainCarouselView

-(instancetype) initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;  // 水平滚动
    flowLayout.itemSize = CGSizeMake(screen_width , frame.size.height);
    flowLayout.minimumLineSpacing = 0;  // 取消cell之间的间距
    self = [super initWithFrame:frame];
    if(self){
        self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        self.frame = frame;
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
    
    
    // 设置轮播时的起点位置
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:cellMaxSections/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.center = CGPointMake(screen_width * 0.5, carousel_height -10);
    self.pageControl.bounds = CGRectMake(0, 0, 150, 40);
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    self.pageControl.enabled = NO;
    self.pageControl.numberOfPages = self.banners.count;
    
    [self addSubview:self.pageControl];
    
    // 创建一个定时器
    [self addTimer];
    
}

-(void) initSearchView{
    CGRect frame = CGRectMake(20, carousel_height - 60, screen_width - 40, 40);
    
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

-(void) addTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer ;
    
}


#pragma mark 删除定时器
-(void) removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

-(void) nextpage{
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:cellMaxSections/2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    NSInteger nextItem = currentIndexPathReset.item +1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem==self.banners.count) {
        nextItem=0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return cellMaxSections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.banners.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MainCarouselCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:mainCarouselCellId forIndexPath:indexPath];
    Banner *banner = self.banners[indexPath.item];
    [cell renderView:banner];
    return cell;
}


-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

#pragma mark 当用户停止的时候调用
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
    
}

#pragma mark 设置页码
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%self.banners.count;
    self.pageControl.currentPage =page;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Banner *banner = self.banners[indexPath.item];
    
    // TODO 点击banner后的下一页面
    ActivePageViewController *activePageViewController = [[ActivePageViewController alloc] init];
    activePageViewController.banner = banner;
    [self.navigationController pushViewController:activePageViewController animated:YES];
    
}


-(void) renderData:(NSArray *)banners{
    self.banners = banners;
    if([self.banners count] != 0){
        [self initView];
        [self.collectionView reloadData];
        [self initSearchView];
    }
    
}

-(void) globalSearch
{
    GlobalSearchViewController *globalSearchController = [[GlobalSearchViewController alloc] init];
    [self.navigationController pushViewController:globalSearchController animated:YES];
}



@end
