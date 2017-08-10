//
//  MapInfo.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/23.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MapInfo
@end

@interface MapInfo : JSONModel


@property (nonatomic , strong) NSString<Optional> *key;
@property (nonatomic , strong) NSString<Optional> *name;


@end
