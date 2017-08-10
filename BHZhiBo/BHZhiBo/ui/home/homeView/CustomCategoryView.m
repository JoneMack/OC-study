//
//  HoneInOneCategoryView.m
//  Golf
//
//  Created by xubojoy on 16/3/16.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import "CustomCategoryView.h"
#import "CustomCategoryCollectionViewCell.h"
static NSString *customCategoryCollectionViewCellId = @"CustomCategoryCollectionViewCell";

@implementation CustomCategoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self = [[[NSBundle mainBundle] loadNibNamed:@"HoneInOneCategoryView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        [self initGameCategoryCollectionView];
    }
    return self;
}

- (void)initGameCategoryCollectionView{
    // 推荐专家
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0.0;//item间距(最小值)
    flowLayout.minimumLineSpacing = 0.0;//行间距(最小值)
    self.customCategoryViewCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)
                                                         collectionViewLayout:flowLayout];
    self.customCategoryViewCollectionView.delegate = self;
    self.customCategoryViewCollectionView.dataSource = self;
    self.customCategoryViewCollectionView.showsHorizontalScrollIndicator = NO;
    
    self.customCategoryViewCollectionView.backgroundColor = [ColorUtils colorWithHexString:common_bg_color];
    
    UINib *nib = [UINib nibWithNibName:@"CustomCategoryCollectionViewCell" bundle: nil];
    [self.customCategoryViewCollectionView registerNib:nib
                      forCellWithReuseIdentifier:customCategoryCollectionViewCellId];
    
    [self addSubview:self.customCategoryViewCollectionView];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:customCategoryCollectionViewCellId forIndexPath:indexPath];
    [cell renderCustomCategoryCollectionViewCellWithItem:indexPath.item];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0.0;
    if (screen_height >= 568) {
        height = 80;
    }else{
        height = 70;
    }
    return CGSizeMake(self.frame.size.width/4,height);
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>%ld",(long)indexPath.item);
    
    CustomCategoryCollectionViewCell *cell = (CustomCategoryCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@">>>>>>>>>>>>>>>>>分类名>>>>>>>>>>%@",cell.categoryTitleLabel.text);
    if ([self.delegate respondsToSelector:@selector(didSelectedCustomCategoryViewItem:categoryTitle:)]) {
        [self.delegate didSelectedCustomCategoryViewItem:indexPath.item categoryTitle:cell.categoryTitleLabel.text];
    }
    
}


@end
