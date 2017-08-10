//
//  Article.h
//  CrazyDoctor
//
//  Created by xubojoy on 16/5/19.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol Article
@end
@interface Article : JSONModel
@property (nonatomic ,assign) int id;
@property (nonatomic ,strong) NSString<Optional> *title;
@property (nonatomic ,assign) long long int createTime;
//@property (nonatomic ,assign) long long int lastUpdateTime;
@property (nonatomic ,strong) NSString<Optional> *content;
@property (nonatomic ,strong) NSString<Optional> *intro;
@property (nonatomic ,strong) NSString<Optional> *articleLogo;
@property (nonatomic ,strong) NSString<Optional> *articleType;


@end
