//
//  SubwayLine.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/1.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Station.h"


@protocol SubwayLine
@end

@interface SubwayLine : JSONModel

@property (nonatomic , strong) NSString *id;
@property (nonatomic , strong) NSString *lineName;
@property (nonatomic , strong) NSArray<Station *> *stationList;


-(NSArray<Station *> *) getStationList;



@end
