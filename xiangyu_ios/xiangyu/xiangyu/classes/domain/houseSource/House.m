//
//  House.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/22.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "House.h"
#import "NSNumber+Utils.h"

@implementation House



-(NSString *) getAddressStr
{
    return [NSString stringWithFormat:@"%@ %@ %@㎡" , self.inDistrictName , self.circle , self.space];
}


-(NSString *) getHouseStyle{
    NSNumber *fewRoom = @([self.fewRoom integerValue]);
    NSNumber *fewHall = @([self.fewHall integerValue]);
    return [NSString stringWithFormat:@"%@室%@厅" , [fewRoom getChineseCharacter] , [fewHall getChineseCharacter]];
}

-(NSString *) getName{
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
        
        if(self.projectName.length >8){
            return [NSString stringWithFormat:@"%@...", [self.projectName substringWithRange:NSMakeRange(0, 7)]];
        }
    }else if(IS_IPHONE_6){
        if(self.projectName.length >12){
            return [NSString stringWithFormat:@"%@...", [self.projectName substringWithRange:NSMakeRange(0, 11)]];
        }
    }
    return self.projectName;
}

-(NSString *) getDistanceStr
{
    if([NSStringUtils isBlank:self.distance]){
        return @"";
    }
    int distanceInt = [self.distance intValue];
    if(distanceInt < 1000){
        return [NSString stringWithFormat:@"距您:%@米" , self.distance];
    }
    return [NSString stringWithFormat:@"距您:%d千米" , distanceInt/1000];
    
}

@end
