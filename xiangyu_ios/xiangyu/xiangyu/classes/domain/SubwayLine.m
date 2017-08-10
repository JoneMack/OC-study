//
//  SubwayLine.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/1.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "SubwayLine.h"

@implementation SubwayLine


-(NSArray<Station *> *) getStationList{
    NSArray<Station *> *children = [Station arrayOfModelsFromDictionaries:self.stationList];
    return children;
    
}
@end
