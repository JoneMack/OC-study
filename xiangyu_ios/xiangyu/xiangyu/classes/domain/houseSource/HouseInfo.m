//
//  HouseInfo.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/23.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "HouseInfo.h"

@implementation HouseInfo



-(int) getPicNum{

    return [self.pic count];
}


-(NSArray<RoomShip *> *) getRoomShips{
    NSArray<RoomShip *> *children = [RoomShip arrayOfModelsFromDictionaries:self.roomShip];
    return children;
    
}


-(NSString *) getFewRoom{
    if([self.fewRoom isEqualToString:@"1"]){
        return @"一居室";
    }else if([self.fewRoom isEqualToString:@"2"]){
        return @"二居室";
    }else if([self.fewRoom isEqualToString:@"3"]){
        return @"三居室";
    }else if([self.fewRoom isEqualToString:@"4"]){
        return @"四居室";
    }else if([self.fewRoom isEqualToString:@"5"]){
        return @"五居室";
    }
    return @"";
}

@end
