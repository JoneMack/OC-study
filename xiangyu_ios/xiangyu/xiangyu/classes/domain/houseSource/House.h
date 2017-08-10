//
//  House.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/22.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol House
@end

@interface House : JSONModel

/** 房源ID */
@property (nonatomic , strong) NSString<Optional> *houseId;
/** 房源编号 */
@property (nonatomic , strong) NSString<Optional> *houseCode;
/** 房间ID */
@property (nonatomic , strong) NSString<Optional> *roomsID;

/** 小区ID */
@property (nonatomic , strong) NSString<Optional> *projectId;

/** 小区名称 */
@property (nonatomic , strong) NSString<Optional> *projectName;

@property (nonatomic , strong) NSString<Optional> *inDistrictName;
/** 城区ID */
@property (nonatomic , strong) NSString<Optional> *inDistrict;
/** 商圈 ID*/
@property (nonatomic , strong) NSString<Optional> *circleId;
/** 商圈名称 */
@property (nonatomic , strong) NSString<Optional> *circle;
/** 居室 */
@property (nonatomic , strong) NSString<Optional> *fewRoom;
/** 厅 */
@property (nonatomic , strong) NSString<Optional> *fewHall;

/** 平米 */
@property (nonatomic , strong) NSString<Optional> *space;

/** 出租类型（1：整租 2：分租） */
@property (nonatomic , strong) NSString<Optional> *rentType;
/** 出租价钱 */
@property (nonatomic , strong) NSString<Optional> *rentPrice;
/** 是否地铁附近 */
@property (nonatomic , strong) NSString<Optional> *yerOrnoSubway;
/** 特色标签 */
@property (nonatomic , strong) NSArray<Optional> *tabList;
/** 是否直播 (1：有 0：无)*/
@property (nonatomic , strong) NSString<Optional> *liveFlg;
/** 朝向 */
@property (nonatomic , strong) NSString<Optional> *rientation;
/** 朝向Name */
@property (nonatomic , strong) NSString<Optional> *rientationName;
/** 是否有独卫 */
@property (nonatomic , strong) NSString<Optional> *isToilet;
/** 是否有独立阳台 */
@property (nonatomic , strong) NSString<Optional> *isBalcony;
/** 封面图 */
@property (nonatomic , strong) NSString<Optional> *fmpic;
/** 距离 */
@property (nonatomic , strong) NSString<Optional> *distance;


-(NSString *) getAddressStr;
-(NSString *) getHouseStyle;
-(NSString *) getDistanceStr;
-(NSString *) getName;

@end
