//
//  Object.m
//  CustomTableViewEditor
//
//  Created by 高波 on 15/11/24.
//  Copyright © 2015年 高波. All rights reserved.
//

#import "CollectionModel.h"

@implementation CollectionModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        _isSelected = NO;
        _collectionId = dictionary[@"collectionId"];
        _collectionDate = dictionary[@"collectionDate"];
        _ownerId = dictionary[@"ownerId"];
        _projectName = dictionary[@"projectName"];
        _projectId = dictionary[@"projectId"];
        _houseId = dictionary[@"houseId"];
        _roomId = dictionary[@"roomId"];
        _fewRoom = dictionary[@"fewRoom"];
        _fewHall = dictionary[@"fewHall"];
        _fewKitchen = dictionary[@"fewKitchen"];
        _signingState = dictionary[@"signingState"];
        _inDistrict = dictionary[@"inDistrict"];
        _circle = dictionary[@"circle"];
        _space = dictionary[@"space"];
        _fmpic = dictionary[@"fmpic"];
        _rentPrice = dictionary[@"rentPrice"];
        _tabInfo = dictionary[@"tabInfo"];
        _rentStatus = dictionary[@"rentStatus"];
    }
    return self;
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


@end
