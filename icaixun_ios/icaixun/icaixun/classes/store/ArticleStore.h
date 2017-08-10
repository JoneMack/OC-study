//
//  ArticleStore.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/19.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"

@interface ArticleStore : NSObject

+(ArticleStore *) sharedInstance;


-(void) getBannerArticles:(void (^)(Page *page , NSError *err))completionBlock;
-(void) getArticles:(void (^)(Page *page , NSError *err))completionBlock pageNo:(int)pageNo pageSize:(int)pageSize;

-(void) postReadCount:(void (^)(Article *article , NSError *err))completionBlock articleId:(int)articleId;

@end
