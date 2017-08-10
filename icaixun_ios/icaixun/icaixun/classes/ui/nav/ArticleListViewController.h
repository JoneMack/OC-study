//
//  ArticleListViewController.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/19.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "ArticleListHeaderView.h"

@interface ArticleListViewController : UIViewController <UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong) HeaderView *headerView;

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) ArticleListHeaderView *articleListHeaderView;


@property (nonatomic , strong) NSMutableArray *bannerArticles;
@property (nonatomic , strong) NSMutableArray *articles;

@end
