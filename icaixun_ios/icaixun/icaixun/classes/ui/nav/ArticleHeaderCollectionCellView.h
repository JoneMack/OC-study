//
//  ArticleHeaderCollectionCellView.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/20.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface ArticleHeaderCollectionCellView : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *articleLogo;

@property (strong, nonatomic) IBOutlet UILabel *articleTitle;


@property (strong, nonatomic) Article *article;


-(void) renderArticle:(Article *)article;

@end
