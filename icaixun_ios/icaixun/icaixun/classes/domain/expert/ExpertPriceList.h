//
//  ExpertPriceList.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/10.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ExpertPriceList
@end

@interface ExpertPriceList : JSONModel

@property (nonatomic , assign) int id;
@property (nonatomic , assign) int expertId;
@property (nonatomic , copy) NSString *priceType;
@property (nonatomic , assign) int point;
@property (nonatomic , assign) int dayCount;

@end
