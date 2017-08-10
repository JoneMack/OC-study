//
//  ArticleCell.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/19.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface ArticleCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *logoView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *introductLabel;

@property (strong, nonatomic) IBOutlet UILabel *tagLabel;

@property (strong, nonatomic) IBOutlet UILabel *createTimeLabel;

@property (strong, nonatomic) UIView *separatorLine;

@property (nonatomic , weak) Article *article;

-(void) renderArticle:(Article *)article;

@end
