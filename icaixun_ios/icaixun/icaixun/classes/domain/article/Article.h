//
//  Article.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/19.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : JSONModel

@property (nonatomic , copy) NSString *id;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *shortTitle;
@property (nonatomic , copy) NSString *introduce;
@property (nonatomic , copy) NSString *logoUrl;
@property (nonatomic , copy) NSString *content;
@property (nonatomic , copy) NSString *tag;
@property (nonatomic , assign) BOOL status;
@property (nonatomic , assign) BOOL banner;
@property (nonatomic , assign) int readCount;

@property (nonatomic , assign) long long int createTime;

-(NSString *) getCreateTimeAndReadCount;


@end
