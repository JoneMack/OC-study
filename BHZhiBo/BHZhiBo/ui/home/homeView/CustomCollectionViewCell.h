//
//  CustomCollectionViewCell.h
//  BHZhiBo
//
//  Created by xubojoy on 2017/1/6.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
@interface CustomCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

- (void)renderCustomCategoryCollectionViewCellWithItem:(NSInteger)item withArticleArray:(NSMutableArray *)articleArray;
@end
