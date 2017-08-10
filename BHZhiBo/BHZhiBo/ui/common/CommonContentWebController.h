//
//  CommonContentWebController.h
//  BHZhiBo
//
//  Created by xubojoy on 2017/1/6.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
@interface CommonContentWebController : BaseViewController<UIWebViewDelegate,UIScrollViewDelegate,NSURLConnectionDelegate>
@property (nonatomic, strong) HeaderView *headerView;
@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic ,strong) Article *article;
@property (nonatomic ,strong) NSString *titleName;
- (instancetype)initWithArticle:(Article *)article title:(NSString *)title;
@end
