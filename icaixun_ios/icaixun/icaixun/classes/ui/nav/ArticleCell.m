//
//  ArticleCell.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/19.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ArticleCell.h"

@implementation ArticleCell

- (void)awakeFromNib {
    // Initialization code
}


-(void) renderArticle:(Article *)article
{
    self.article = article;
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:self.article.logoUrl]
                     placeholderImage:[UIImage imageNamed:@"news_bg_small.jpg"]];
    self.titleLabel.text = self.article.shortTitle;
    self.introductLabel.text = self.article.introduce;
    self.introductLabel.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.createTimeLabel.text = [DateUtils stringFromLongLongIntAndFormat:self.article.createTime
                                                               dateFormat:@"yyyy-MM-dd HH:mm"];
    self.tagLabel.text = article.tag;
    self.tagLabel.textColor = [ColorUtils colorWithHexString:@"#ee7aa1"];
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:gray_black_line2_color];
    self.separatorLine.frame = CGRectMake(10, 96.5 , screen_width - 10,splite_line_height);
    [self.contentView addSubview:self.separatorLine];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
