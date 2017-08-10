//
//  OwnerDeposit.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/29.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OwnerDeposit : NSObject


/* 业主ID */
@property (nonatomic , strong) NSString<Optional> *ownerId;
/* 被推荐人姓名 */
@property (nonatomic , strong) NSString<Optional> *ownerName;
/* 被推荐人电话 */
@property (nonatomic , strong) NSString<Optional> *contact;
/* 户型 */
@property (nonatomic , strong) NSString<Optional> *layout;
/* 房屋朝向 */
@property (nonatomic , strong) NSString<Optional> *houseOrientation;
/* 年代 */
@property (nonatomic , strong) NSString<Optional> *age;
/* 期望价格 */
@property (nonatomic , strong) NSString<Optional> *hopePrice;
/*小区ID（选择小区时，有小区ID）  */
@property (nonatomic , strong) NSString<Optional> *projectId;
/*小区名（手输入小区时，只有小区名没有ID）  */
@property (nonatomic , strong) NSString<Optional> *village;
/* 楼号 */
@property (nonatomic , strong) NSString<Optional> *floorNO;
/* 单元号 */
@property (nonatomic , strong) NSString<Optional> *unit;
/* 房间号 */
@property (nonatomic , strong) NSString<Optional> *houseNO;
/* 房屋面积*/
@property (nonatomic , strong) NSString<Optional> *space;
/* 出租方式 */
@property (nonatomic , strong) NSString<Optional> *rentType;
/* 室内设施 app端以","分隔--家电*/
@property (nonatomic , strong) NSString<Optional> *indoorFacilities;
/* 室内设施 app端以","分隔--家具*/
@property (nonatomic , strong) NSString<Optional> *indoorFacilitiesJJ;
/* 其他要求*/
@property (nonatomic , strong) NSString<Optional> *otherRequirement;
/* 商圈*/
@property (nonatomic , strong) NSString<Optional> *circle;
/*区域*/
@property (nonatomic , strong) NSString<Optional> *area;
/*物业类型*/
@property (nonatomic , strong) NSString<Optional> *propertyType;
/*周边交通*/
@property (nonatomic , strong) NSString<Optional> *surroundingTraffic;
/*是否业主isowner*/
@property (nonatomic , strong) NSString<Optional> *isOwner;
/*朱冰冰 推荐时间*/
@property (nonatomic , strong) NSString<Optional> *createTime;
/*房源图片--朱冰冰*/
@property (nonatomic , strong) NSString<Optional> *photoUrl;
/*是否在租 0:否 1：是*/
@property (nonatomic , assign) int isRent;
/*到租日期*/
@property (nonatomic , strong) NSString<Optional> *leaseEndDay;
/*验证码*/
@property (nonatomic , strong) NSString<Optional> *verificationCode;

@end
