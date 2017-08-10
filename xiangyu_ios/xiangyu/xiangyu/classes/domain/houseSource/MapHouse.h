//
//  MapHouse.h
//  xiangyu
//
//  Created by xubojoy on 16/6/24.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MapHouse
@end
@interface MapHouse : JSONModel

@property (nonatomic ,assign) int forRentCount;
@property (nonatomic ,strong) NSString<Optional> *projectName;
@property (nonatomic ,strong) NSString<Optional> *x; //经度  大的
@property (nonatomic ,strong) NSString<Optional> *y; //纬度 小的


@end
