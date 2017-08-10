//
//  ArticleHeaderCollectionCellView.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/20.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ArticleHeaderCollectionCellView.h"

@implementation ArticleHeaderCollectionCellView

- (void)awakeFromNib {
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
}


-(void) renderArticle:(Article *)article
{
    self.article = article;
    [self.articleLogo sd_setImageWithURL:[NSURL URLWithString:article.logoUrl]
                        placeholderImage:[UIImage imageNamed:@"news_bg_big.jpg"]];
    self.articleTitle.text = article.title;
}

@end
