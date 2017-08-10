//
//  IndexHeaderView.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/30.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "IndexHeaderView.h"
#import "ExpertSmallCardCell.h"
#import "ExpertStore.h"
#import "HasNotAttentionExpertViewController.h"
#import "ExpertDetailViewController.h"
#import "AddAttentionExpertViewController.h"
#import "LoginViewController.h"
#import "PayStore.h"

static NSString *indexExpertSmallCardCellId = @"indexExpertSmallCardCellId";

@implementation IndexHeaderView


-(instancetype) initWithNavigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self) {
        self.navigationController = navigationController;
        [self initView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAttitionExpert:)
                                                     name:notification_name_update_attention_expert
                                                   object:nil];
    }
    return self;
}

-(void) initView
{
    UIImage *bgImg = [UIImage imageNamed:@"bg_big_header@2x.jpg"];
    self.layer.contents = (id) bgImg.CGImage;
    
    // 初始化头部
    self.headerView = [[HeaderView alloc] initWithTitle:@"爱财讯"
                                   navigationController:self.navigationController];
    self.headerView.backBut.hidden = YES;
    [PayStore getPaymentType:^(NSDictionary *paymentType, NSError *err) {
        NSString *payType = paymentType[@"pay"];
        if ([payType isEqualToString:@"true"]) {
           [self.headerView renderOtherBtn:pay];
        }
    }];
    [self addSubview:self.headerView];
    
    // 推荐专家
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;  // 水平滚动
    
    self.expertsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, self.headerView.bottomY-10, screen_width - 30, 120)
                                                    collectionViewLayout:flowLayout];
    flowLayout.itemSize = CGSizeMake(80, 90);
    self.expertsCollectionView.delegate = self;
    self.expertsCollectionView.dataSource = self;
    self.expertsCollectionView.showsHorizontalScrollIndicator = NO;
    self.expertsCollectionView.backgroundColor = [UIColor clearColor];
    
    UINib *nib = [UINib nibWithNibName:@"ExpertSmallCardCell"
                                bundle: [NSBundle mainBundle]];
    [self.expertsCollectionView registerNib:nib
                 forCellWithReuseIdentifier:indexExpertSmallCardCellId];
    
    [self addSubview:self.expertsCollectionView];

    [self loadData];
}

-(void) loadData
{
    [ExpertStore getMyAttentionExperts:^(NSArray *experts, NSError *err) {
        
        if (experts.count == 0) {
//            if (![AppStatus sharedInstance].logined) {
//                LoginViewController *loginViewController = [[LoginViewController alloc] init];
//                [self.navigationController pushViewController:loginViewController animated:YES];
// 
//            }else{
                HasNotAttentionExpertViewController *hasNotAttentionExpertController = [[HasNotAttentionExpertViewController alloc] init];
                [self.navigationController pushViewController:hasNotAttentionExpertController animated:NO];
//            }
            
            return;
        }
        self.experts = experts;
        
        // 通知代理
        if([self.delegate respondsToSelector:@selector(getExpertsMessages:)]){
            [self.delegate getExpertsMessages:self.experts];
        }
        
        [self.expertsCollectionView reloadData];
        
        
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.experts.count+1;

}


-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ExpertSmallCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indexExpertSmallCardCellId
                                                                          forIndexPath:indexPath];
    
    if (indexPath.row == self.experts.count) {
        [cell renderAddExpert];
    }else{
        Expert *expert = self.experts[indexPath.row];
        [cell renderWithExpert:expert];
    }
    
    return cell;
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.experts.count){
        AddAttentionExpertViewController *addExpertController = [AddAttentionExpertViewController new];
        [self.navigationController pushViewController:addExpertController animated:YES];
    }else{
        Expert *expert = self.experts[indexPath.row];
        ExpertDetailViewController *expertDetailViewController = [[ExpertDetailViewController alloc] initWithExpert:expert];
        [self.navigationController pushViewController:expertDetailViewController animated:YES];
    }
}


-(void) updateAttitionExpert:(NSNotification *) notification
{
    [self loadData];
}


@end
