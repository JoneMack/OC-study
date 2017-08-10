//
//  OrderLookHouseInfo.m
//  xiangyu
//
//  Created by xubojoy on 16/8/8.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "OrderLookHouseInfo.h"

@implementation OrderLookHouseInfo
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        _isSelected = NO;
        _houseId = [dictionary[@"houseId"] intValue];
        _roomId = dictionary[@"roomId"];
        _fmpic = dictionary[@"fmpic"];
        _rentPrice = dictionary[@"rentPrice"];
        _createTime = dictionary[@"createTime"];
        _customerId = [dictionary[@"customerId"] intValue];
        _houseCircle = dictionary[@"houseCircle"];
        _houseFewHall = [dictionary[@"houseFewHall"] intValue];
        _houseFewRoom = [dictionary[@"houseFewRoom"] intValue];
        _houseId = [dictionary[@"houseId"] intValue];
        _houseInDistrict = dictionary[@"houseInDistrict"];
        _houseKeeperId = [dictionary[@"houseKeeperId"] intValue];
        _houseLayout = dictionary[@"houseLayout"];
        _houseProjectName = dictionary[@"houseProjectName"];
        _houseSpace = [dictionary[@"houseSpace"] intValue];
        _id = [dictionary[@"id"] intValue];
        _lastModifiedDate = dictionary[@"lastModifiedDate"];
        _orderId = [dictionary[@"orderId"] intValue];
        _orderStatus = dictionary[@"orderStatus"];
        _orderType = dictionary[@"orderType"];
        _rentPrice = dictionary[@"rentPrice"];
        _rentType = dictionary[@"rentType"];
        _roomId = dictionary[@"roomId"];
        _roomSpace = dictionary[@"roomSpace"];
        
        _roomType = dictionary[@"roomType"];
        _tenantId = dictionary[@"tenantId"];
    }
    return self;
}

-(NSString *) getName{
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
        
        if(self.houseProjectName.length >8){
            return [NSString stringWithFormat:@"%@...", [self.houseProjectName substringWithRange:NSMakeRange(0, 7)]];
        }
    }else if(IS_IPHONE_6){
        if(self.houseProjectName.length >12){
            return [NSString stringWithFormat:@"%@...", [self.houseProjectName substringWithRange:NSMakeRange(0, 11)]];
        }
    }
    return self.houseProjectName;
}
@end
