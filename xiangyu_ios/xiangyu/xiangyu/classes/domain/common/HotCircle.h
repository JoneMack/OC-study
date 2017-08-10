//
//  HotCircle.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/5.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HotCircle
@end


@interface HotCircle : JSONModel

//buscirCode: "110155",
//buscirName: "望京",
//inDistrict: "11000005",
//hotOrder: 1

@property (nonatomic , strong) NSString *buscirCode;
@property (nonatomic , strong) NSString *buscirName;
@property (nonatomic , strong) NSString *inDistrict;
@property (nonatomic , strong) NSString *hotOrder;

@end
