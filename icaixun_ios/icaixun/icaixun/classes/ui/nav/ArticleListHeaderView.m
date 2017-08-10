//
//  ArticleListHeaderView.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/20.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ArticleListHeaderView.h"
#import "ArticleHeaderCollectionCellView.h"
#import "ArticleDetailViewController.h"

static NSString *articleListHeaderCellId = @"articleListHeaderCellId";

@implementation ArticleListHeaderView

-(instancetype) initWithArticles:(NSArray *)articles navigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"ArticleListHeaderView" owner:self options:nil] objectAtIndex:0];
        self.articles = articles;
        self.navigationController = navigationController;
        [self initCollectionView];
    }
    return self;
}

-(void) initCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;  // 水平滚动
    flowLayout.itemSize = CGSizeMake(screen_width ,screen_width/2+2*splite_line_height);
    flowLayout.minimumLineSpacing = 0;  // 取消cell之间的间距
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    UINib *nib = [UINib nibWithNibName:@"ArticleHeaderCollectionCellView" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:articleListHeaderCellId];
    [self addSubview:self.collectionView];
    
    self.currentArtitleTitle.text = [self.articles[0] title];
    self.currentArtitleTitle.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.currentArtitleTitle];
    
    self.pageControl.numberOfPages = self.articles.count;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [ColorUtils colorWithHexString:gray_text_color];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    [self addSubview:self.pageControl];
    
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:gray_black_line2_color];
    self.separatorLine.frame = CGRectMake(0, screen_width/2 + 25 ,
                                          screen_width,
                                          splite_line_height);
    [self addSubview:self.separatorLine];
    
    
    // 创建一个定时器
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(nextArticle) userInfo:nil repeats:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


#pragma mark 一共有多少个items
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.articles.count;
}

#pragma mark 渲染cell
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleHeaderCollectionCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:articleListHeaderCellId forIndexPath:indexPath];
    Article *article = self.articles[indexPath.row];
    [cell renderArticle:article];
    return cell;
}

#pragma mark 选择了cell的事件
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = self.articles[indexPath.row];
    ArticleDetailViewController *articleDetailController = [[ArticleDetailViewController alloc] init];
    articleDetailController.article = article;
    [self.navigationController pushViewController:articleDetailController animated:YES];
}

#pragma mark 监听collection view的滚动事件
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    offsetX = offsetX + screen_width/2;
    int page = offsetX / screen_width ;
    self.pageControl.currentPage = page;
    [self.currentArtitleTitle setText:[self.articles[page] title]];
}

#pragma mark 下一个banner
-(void) nextArticle
{
    NSInteger currentPage= self.pageControl.currentPage;
    if (currentPage == self.pageControl.numberOfPages -1) {
        currentPage = 0;
    }else{
        currentPage++;
    }
    self.pageControl.currentPage = currentPage;
    [self.currentArtitleTitle setText:[self.articles[currentPage] title]];
    CGFloat offsetX = currentPage * screen_width;
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}



@end
