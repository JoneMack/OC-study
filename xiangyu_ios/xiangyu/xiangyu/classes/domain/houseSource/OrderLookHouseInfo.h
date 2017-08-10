//
//  OrderLookHouseInfo.h
//  xiangyu
//
//  Created by xubojoy on 16/8/8.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderLookHouseInfo : NSObject

@property (nonatomic) BOOL isSelected;
@property (nonatomic ,strong) NSString<Optional> *createTime;
@property (nonatomic ,assign) int customerId;
@property (nonatomic ,strong) NSString<Optional> *fmpic;
@property (nonatomic ,strong) NSString<Optional> *houseCircle;
@property (nonatomic ,assign) int houseFewHall;
@property (nonatomic ,assign) int houseFewRoom;
@property (nonatomic ,assign) int houseId;
@property (nonatomic ,strong) NSString<Optional> *houseInDistrict;
@property (nonatomic ,assign) int houseKeeperId;
@property (nonatomic ,strong) NSString<Optional> *houseLayout;
@property (nonatomic ,strong) NSString<Optional> *houseProjectName;
@property (nonatomic ,assign) int houseSpace;
@property (nonatomic ,assign) int id;
@property (nonatomic ,strong) NSString<Optional> *lastModifiedDate;
@property (nonatomic ,assign) int orderId;
@property (nonatomic ,strong) NSDictionary<Optional> *orderStatus;

@property (nonatomic ,strong) NSDictionary<Optional> *orderType;
@property (nonatomic ,strong) NSString<Optional> *rentPrice;
@property (nonatomic ,strong) NSDictionary<Optional> *rentType;
@property (nonatomic ,strong) NSString<Optional> *roomId;
@property (nonatomic ,strong) NSString<Optional> *roomSpace;
@property (nonatomic ,strong) NSString<Optional> *roomType;
@property (nonatomic ,strong) NSString<Optional> *tenantId;

-(NSString *) getName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
