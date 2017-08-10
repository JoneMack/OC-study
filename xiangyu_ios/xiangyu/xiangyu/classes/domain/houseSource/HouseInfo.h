//
//  HouseInfo.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/23.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomShip.h"
#import "MapInfo.h"
#import "AirInfo.h"

@protocol HouseInfo
@end

@interface HouseInfo : JSONModel

// 业主ID
@property (nonatomic , strong) NSString<Optional> *ownerId;
// 默认业主姓名
@property (nonatomic , strong) NSString<Optional> *ownerNmDefault;
// 默认业主电话
@property (nonatomic , strong) NSString<Optional> *ownerPhoneDefault;
// 小区ID
@property (nonatomic , strong) NSString<Optional> *projectId;
// 小区名称
@property (nonatomic , strong) NSString<Optional> *projectName;
//// 房屋ID
@property (nonatomic , strong) NSString<Optional> *houseId;
// 房屋编号
@property (nonatomic , strong) NSString<Optional> *houseCode;
// 房间ID
@property (nonatomic , strong) NSString<Optional> *roomId;

// 房屋朝向
@property (nonatomic , strong) NSString<Optional> *houseOrientation;
// 电梯数量
@property (nonatomic , strong) NSString<Optional> *elevatorInfo;
// 电梯户数
@property (nonatomic , strong) NSString<Optional> *elevatorHouseholds;
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
// 房屋号（门牌号）
@property (nonatomic , strong) NSString<Optional> *houseNO;

// 总楼层
@property (nonatomic , strong) NSString<Optional> *totalFloor;
// 户型结构
@property (nonatomic , strong) NSString<Optional> *structure;
// 供暖方式
@property (nonatomic , strong) NSString<Optional> *heating;
// 房屋建筑面积
@property (nonatomic , strong) NSString<Optional> *space;
// 门锁类型
@property (nonatomic , strong) NSString<Optional> *lockType;
// 产权地址
@property (nonatomic , strong) NSString<Optional> *propertyAddress;
// 行政地址
@property (nonatomic , strong) NSString<Optional> *adminAddress;
// 房评介绍
@property (nonatomic , strong) NSString<Optional> *persIntroduction;
// 房屋状态
@property (nonatomic , strong) NSString<Optional> *signingState;
// 租赁方式
@property (nonatomic , strong) NSString<Optional> *rentType;
// 卧室类型
@property (nonatomic , strong) NSString<Optional> *roomType;
// 卧室朝向
@property (nonatomic , strong) NSString<Optional> *roomOrientation;


// 图片地址列表
@property (nonatomic , strong) NSArray<Optional> *pic;
// 是否着火房 1着火房 0非着火房
@property (nonatomic , strong) NSString<Optional> *isFire;
// 城区
@property (nonatomic , strong) NSString<Optional> *inDistrict;
// 价格
@property (nonatomic , strong) NSString<Optional> *rentPrice;
@property (nonatomic , strong) NSString<Optional> *otherRequest;
@property (nonatomic , strong) NSString<Optional> *indoors;
@property (nonatomic , strong) NSString<Optional> *indoorsNames;
@property (nonatomic , strong) NSString<Optional> *indoorsJJ;
@property (nonatomic , strong) NSString<Optional> *indoorsJJNames;
@property (nonatomic , strong) NSString<Optional> *traffic;
@property (nonatomic , strong) NSString<Optional> *fmpic;

// 经度
@property (nonatomic , strong) NSString<Optional> *x;
// 维度
@property (nonatomic , strong) NSString<Optional> *y;
// 服务费
@property (nonatomic , strong) NSString<Optional> *serviceCharge;
// 押金
@property (nonatomic , strong) NSString<Optional> *depositMoney;
// 风格
@property (nonatomic , strong) NSString<Optional> *templateId;
// 房屋类型 卧室 公共区域 卫生间 厨房
@property (nonatomic , strong) NSString<Optional> *houseType;
// 我的室友
@property (nonatomic , strong) NSArray<Optional> *myRoommate;
// 室友
@property (nonatomic , strong) NSArray<RoomShip *><Optional> *roomShip;
// 周边交通
@property (nonatomic , strong) NSString<Optional> *surroundingTraffic;
// 公交信息
@property (nonatomic , strong) NSString<Optional> *transitInfo;
// 地铁信息
@property (nonatomic , strong) NSString<Optional> *subwayInfo;
// 轮播图
@property (nonatomic , strong) NSString<Optional> *advertMap;
// 管家说
@property (nonatomic , strong) NSString<Optional> *content;
// 发布时间
@property (nonatomic , strong) NSString<Optional> *createTime;
// 付款方式
@property (nonatomic , strong) NSString<Optional> *payType;
// 付款方式付名
/** 付款方式名 */
@property (nonatomic , strong) NSString<Optional> *payTypeNm;
// 押金方式
@property (nonatomic , strong) NSString<Optional> *depositType;
/** 押金方式押名 */
@property (nonatomic , strong) NSString<Optional> *depositTypeNm;

// 房间名称
@property (nonatomic , strong) NSString<Optional> *roomName;
// 是否可整租
@property (nonatomic , strong) NSString<Optional> *entireRent;
// 物业类型
@property (nonatomic , strong) NSString<Optional> *propertyType;

// 商圈字段
@property (nonatomic , strong) NSString<Optional> *circle;
@property (nonatomic , strong) NSString<Optional> *circleId;

// 标签
@property (nonatomic , strong) NSString<Optional> *tabInfo;
@property (nonatomic , strong) NSString<Optional> *tabInfoName;

/* 收藏ID */
@property (nonatomic , strong) NSString<Optional> *collectionId;
/* 签约开始时间 */
@property (nonatomic , strong) NSString<Optional> *startTime;
/* 签约结束时间 */
@property (nonatomic , strong) NSString<Optional> *endTime;
/* 业主名字 */
@property (nonatomic , strong) NSString<Optional> *customerName;
/* 预约ID */
@property (nonatomic , strong) NSString<Optional> *appointmentId;
/* 定价 */
@property (nonatomic , strong) NSString<Optional> *priceCap;
/* 房屋朝向字典值 */
@property (nonatomic , strong) NSString<Optional> *orientationId;

// 2015/10/19 LIUHUI ADD START
/**
 * 是否可预定 Y：可预定|N：不可预定
 */
@property (nonatomic , strong) NSString<Optional> *isReservation;

/**
 * 出房前置定价
 */
@property (nonatomic , strong) NSString<Optional> *cfPricingPrice;

/**
 * 出房合同-月租金
 */
@property (nonatomic , strong) NSString<Optional> *cfMonthRent;

/**
 * 出房合同-付款方式（押X付Y的Y）
 */
@property (nonatomic , strong) NSString<Optional> *cfPaymentType;

/**
 * 出房前置定价-发布付款方式
 */
@property (nonatomic , strong) MapInfo<Optional> *cfPricingPublishPayType;
// 2015/10/19 LIUHUI ADD END
/**
 * 收房前置定价
 */
@property (nonatomic , strong) NSString<Optional> *sfPricingPrice;

@property (nonatomic , strong) NSString<Optional> *sfContractId;
/**
 * 出租签约价格
 */
@property (nonatomic , strong) NSString<Optional> *sfRentPrice;
/**
 * 承租签约价格
 */
@property (nonatomic , strong) NSString<Optional> *cfRentPrice;
/**
 * 佣金
 */
@property (nonatomic , strong) NSString<Optional> *serviceFee;
// 对应的楼盘房屋id
@property (nonatomic , strong) NSString<Optional> *buildingHouseId;

/** 收房定价开关 */
@property (nonatomic , strong) NSString<Optional> *sfPriceFixingFlg;

/** 可租期 */
@property (nonatomic , strong) NSString<Optional> *canBeRentedPeriod;

@property (nonatomic , strong) AirInfo<Optional> *airInfoVO;

@property (nonatomic , strong) NSString<Optional> *houseName;


-(int) getPicNum;

/**
 * 获取居室
 */
-(NSString *) getFewRoom;

-(NSArray<RoomShip *> *) getRoomShips;

@end
