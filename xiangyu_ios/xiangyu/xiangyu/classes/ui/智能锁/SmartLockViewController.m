//
//  SmartLockViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "SmartLockViewController.h"
#import "SmartLockCell.h"
#import "PassLockViewController.h"


static NSString *smartLockCellId = @"smartLockCellId";

@interface SmartLockViewController ()

@end

@implementation SmartLockViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initHeaderView];
    [self initBodyView];

}

-(void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"智能锁" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
}

-(void) initBodyView{
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 64, screen_width, screen_height-64);
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgView];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;  // 水平滚动
    flowLayout.itemSize = CGSizeMake((screen_width-40)/2 , 202 );
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    self.bodyView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 64+20, screen_width-40, screen_height-64-20) collectionViewLayout:flowLayout];
    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    [self.bodyView setBackgroundColor:[UIColor whiteColor]];
    
    UINib *nib = [UINib nibWithNibName:@"SmartLockCell" bundle:nil];
    [self.bodyView registerNib:nib forCellWithReuseIdentifier:smartLockCellId];
    
    [self.view addSubview:self.bodyView];
    
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
// 列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return -20;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SmartLockCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:smartLockCellId forIndexPath:indexPath];
    if(indexPath.item%2 == 0){
        [cell.line2View setHidden:NO];
    }else{
        
        [cell.line2View setHidden:YES];
    }
    return cell;
    
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    PassLockViewController *passLockViewController = [[PassLockViewController alloc] init];
//    [self.navigationController pushViewController:passLockViewController animated:YES];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
