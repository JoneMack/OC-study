//
//  FindExpertsHeaderView.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/25.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "FindExpertsHeaderView.h"
#import "ExpertSmallCardCell.h"
#import "ExpertStore.h"
#import "ExpertDetailViewController.h"
#import "MyExpertsController.h"

static NSString *expertSmallCardCellId = @"expertSmallCardCellId";

@implementation FindExpertsHeaderView


-(instancetype) initWithNavigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self) {
        self.navigationController = navigationController;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_big_header_750@2x.jpg"]];
        
        [self initTableView];
    }
    return self;
}

-(void) initTableView
{
    float y = 0;
    if (CURRENT_SYSTEM_VERSION >= 7) {
        y=status_bar_height;
    }
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;  // 水平滚动
    
    self.expertsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, y, screen_width - 30, 120) collectionViewLayout:flowLayout];
    flowLayout.itemSize = CGSizeMake(80, 90);
    self.expertsCollectionView.delegate = self;
    self.expertsCollectionView.dataSource = self;
    self.expertsCollectionView.showsHorizontalScrollIndicator = NO;
    self.expertsCollectionView.backgroundColor = [UIColor clearColor];
    
    
    UINib *nib = [UINib nibWithNibName:@"ExpertSmallCardCell"
                                bundle: [NSBundle mainBundle]];
    [self.expertsCollectionView registerNib:nib
                 forCellWithReuseIdentifier:expertSmallCardCellId];
    
    [self addSubview:self.expertsCollectionView];
    
    self.moreBtn = [[UIButton alloc] init];
    self.moreBtn.frame = CGRectMake((screen_width - 43)/2, self.expertsCollectionView.bottomY+2,
                                    43, 17);
    [self.moreBtn setBackgroundColor:[UIColor clearColor]];
    [self.moreBtn setTitle:@"更 多" forState:UIControlStateNormal];
    [self.moreBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    self.moreBtn.layer.masksToBounds = YES;
    self.moreBtn.layer.borderWidth = 1;
    self.moreBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.moreBtn.layer.cornerRadius = 8.5;
    [self addSubview:self.moreBtn];
    
    [self.moreBtn addTarget:self action:@selector(showMoreExperts) forControlEvents:UIControlEventTouchUpInside];
 
    [self loadData];
    
}

-(void) loadData
{
    ExpertQuery *expertQuery = [[ExpertQuery alloc] initWithPageSize:5];
    [ExpertStore getExperts:^(NSArray *experts, NSError *err) {
        NSLog(@"获取专家列表 完成");
        self.experts = experts;
        [self.expertsCollectionView reloadData];
    } query:expertQuery];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.experts.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    Expert *expert = self.experts[indexPath.row];
    ExpertSmallCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:expertSmallCardCellId
                                                                          forIndexPath:indexPath];
    [cell renderWithExpert:expert];
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Expert *expert = self.experts[indexPath.row];
    
    ExpertDetailViewController *expertDetailController = [[ExpertDetailViewController alloc] initWithExpert:expert];
    [self.navigationController pushViewController:expertDetailController animated:YES];
    
}

-(void) showMoreExperts
{
    MyExpertsController *expertsController = [[MyExpertsController alloc] init];
    [self.navigationController pushViewController:expertsController animated:YES];
}


@end
