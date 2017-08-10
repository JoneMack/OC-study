//
//  Station.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/1.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Station
@end


@interface Station : JSONModel

@property (nonatomic , strong) NSString *id;
@property (nonatomic , strong) NSString *stationName;


@end






