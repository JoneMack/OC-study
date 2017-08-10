//
//  HoneInOneCategoryCollectionViewCell.h
//  Golf
//
//  Created by xubojoy on 16/7/11.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCategoryCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLabel;

- (void)renderCustomCategoryCollectionViewCellWithItem:(NSInteger)item;



@end
