//
//  Object.h
//  CustomTableViewEditor
//
//  Created by 高波 on 15/11/24.
//  Copyright © 2015年 高波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionModel : NSObject

@property (nonatomic) BOOL isSelected;
@property (nonatomic ,strong) NSString<Optional> *collectionId;

@property (nonatomic ,strong) NSString<Optional> *collectionDate;
// 业主ID
@property (nonatomic , strong) NSString<Optional> *ownerId;
// 小区ID
@property (nonatomic , strong) NSString<Optional> *projectId;
// 小区名称
@property (nonatomic , strong) NSString<Optional> *projectName;
//// 房屋ID
@property (nonatomic , strong) NSString<Optional> *houseId;
// 房屋编号
// 房间ID
@property (nonatomic , strong) NSString<Optional> *roomId;
// 房屋建筑面积
@property (nonatomic , strong) NSString<Optional> *space;
// 房屋状态
@property (nonatomic , strong) NSString<Optional> *signingState;
// 楼号
@property (nonatomic , strong) NSString<Optional> *floorNO;
// 单元
@property (nonatomic , strong) NSString<Optional> *unit;
// 楼层
@property (nonatomic , strong) NSString<Optional> *floor;
// 几室
@property (nonatomic , strong) NSString<Optional> *fewRoom;
// 几厅
@property (nonatomic , strong) NSString<Optional> *fewHall;
// 几厨
@property (nonatomic , strong) NSString<Optional> *fewKitchen;
// 几卫
@property (nonatomic , strong) NSString<Optional> *fewToilet;

// 城区
@property (nonatomic , strong) NSString<Optional> *inDistrict;
// 价格
@property (nonatomic , strong) NSString<Optional> *rentPrice;
@property (nonatomic , strong) NSString<Optional> *fmpic;

// 商圈字段
@property (nonatomic , strong) NSString<Optional> *circle;

// 标签
@property (nonatomic , strong) NSString<Optional> *tabInfo;
@property (nonatomic ,strong) NSString<Optional> *rentStatus;


@property (nonatomic , strong) NSString<Optional> *houseName;

-(NSString *) getName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
