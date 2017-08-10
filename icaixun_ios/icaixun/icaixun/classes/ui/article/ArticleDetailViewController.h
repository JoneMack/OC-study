//
//  ArticleDetailViewController.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/19.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface ArticleDetailViewController : UIViewController

@property (nonatomic , strong) HeaderView *headerView;
@property (nonatomic , strong) UIView *bodyView;

@property (nonatomic , strong) UIView *titleBlock;
@property (nonatomic , strong) UILabel *titleLabe;
@property (nonatomic , strong) UILabel *createTimeAndReadCountLabel;
@property (strong, nonatomic) UIView *separatorLine;
@property (strong, nonatomic) UIImageView *downArrow;

//@property (nonatomic , strong) UIWebView *webView;
@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (nonatomic, strong) UILabel *introduceLab;


@property (nonatomic , strong) Article *article;

@end
