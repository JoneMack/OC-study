//
//  CustomCollectionViewCell.m
//  BHZhiBo
//
//  Created by xubojoy on 2017/1/6.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)renderCustomCategoryCollectionViewCellWithItem:(NSInteger)item withArticleArray:(NSMutableArray *)articleArray{
//    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:article.articleLogo] placeholderImage:nil];
    
    for (Article *article in articleArray) {
        if (item == 0) {
            if (article.id == 7) {
                [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:article.articleLogo] placeholderImage:nil];
            }
        }else if (item == 1){
            if (article.id == 8){
                [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:article.articleLogo] placeholderImage:nil];
            }
        }else{
            if (article.id == 9){
                [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:article.articleLogo] placeholderImage:nil];
            }
        }
    }
    
    

}


@end
