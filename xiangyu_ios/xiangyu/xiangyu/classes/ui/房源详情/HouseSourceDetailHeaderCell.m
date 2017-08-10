//
//  HouseSourceDetailHeaderCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/16.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "HouseSourceDetailHeaderCell.h"
#import "MainCarouselCollectionViewCell.h"

#define cellMaxSections 100

static NSString *houseSourceDetailCarouselCellId = @"houseSourceDetailCarouselCellId";

@implementation HouseSourceDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headerBg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
    
    self.priceBg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
    
    self.pageNo.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
    
    [self.price setTextColor:[ColorUtils colorWithHexString:text_color_yellow]];
    
    [self.timeLeft setTextColor:[UIColor whiteColor]];
    
    self.pageNo.layer.masksToBounds = YES;
    self.pageNo.layer.cornerRadius = 10;
    
    
}


-(void) renderData:(HouseInfo *)houseInfo
{
    self.houseInfo = houseInfo;
    [self.price setText:houseInfo.rentPrice];
    [self.pageNo setText:[NSString stringWithFormat:@"1 / %d" , [houseInfo getPicNum]]];
    
    if(self.houseInfo != nil ){
        [self initCarouse];
    }
}


-(void) initCarouse{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;  // 水平滚动
    flowLayout.itemSize = CGSizeMake(screen_width , 258);
    flowLayout.minimumLineSpacing = 0;  // 取消cell之间的间距
    [self.carouselList setCollectionViewLayout:flowLayout];
    self.frame = CGRectMake(0, 0, screen_width, 258);
    self.carouselList.delegate = self;
    self.carouselList.dataSource = self;
    
    // 设置自动分页
    self.carouselList.pagingEnabled = YES;
    // 是否显示水平滚动条
    self.carouselList.showsHorizontalScrollIndicator = NO;
    // 设置是否有边界
    self.carouselList.bounces = NO;
    
    
    UINib *nib = [UINib nibWithNibName:@"MainCarouselCollectionViewCell" bundle:nil];
    [self.carouselList registerNib:nib forCellWithReuseIdentifier:houseSourceDetailCarouselCellId];
    
    [self.carouselList setBackgroundColor:[UIColor whiteColor]];
    
    // 设置轮播时的起点位置
    if(self.houseInfo != nil && self.houseInfo.pic != nil && [self.houseInfo.pic count] >0){
        [self.carouselList scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:cellMaxSections/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        // 创建一个定时器
        [self addTimer];
        
    }
    
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
    NSIndexPath *currentIndexPath = [[self.carouselList indexPathsForVisibleItems] lastObject];
    
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:cellMaxSections/2];
    [self.carouselList scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    NSInteger nextItem = currentIndexPathReset.item +1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem==self.houseInfo.pic.count) {
        nextItem=0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    [self.carouselList scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [self.pageNo setText:[NSString stringWithFormat:@"%d / %d" , nextItem+1 , [self.houseInfo getPicNum]]];
}

#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return cellMaxSections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.houseInfo != nil && self.houseInfo.pic.count > 0){
        return self.houseInfo.pic.count;
    }
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MainCarouselCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:houseSourceDetailCarouselCellId
                                                                                     forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
    if(self.houseInfo != nil && self.houseInfo.pic != nil && [self.houseInfo.pic count] > 0){
        NSArray *pics = self.houseInfo.pic;
        [cell renderViewWithUrl:pics[indexPath.row]];
    }else{
        [cell renderViewWithImgName:@"zhanweitu_big"];
    }
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
//    int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%self.houseInfo.pic.count;
//    self.pageControl.currentPage =page;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
