//
//  Article.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/19.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "Article.h"

@implementation Article


-(NSString *) getCreateTimeAndReadCount
{
    
    return [NSString stringWithFormat:@"%@     阅读%d" , [DateUtils stringFromLongLongIntAndFormat:self.createTime dateFormat:@"yyyy-MM-dd  HH:mm"],self.readCount];
}
@end
