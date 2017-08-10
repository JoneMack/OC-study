//
//  TenantAppointment.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/30.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TenantAppointment : NSObject

//房源信息ID
@property (nonatomic , strong) NSString<Optional> *houseInfoId;
//房间ID
@property (nonatomic , strong) NSString<Optional> *roomId;
//租客Id
@property (nonatomic , strong) NSString<Optional> *tenantInfoId;
/* 管家姓名 */
@property (nonatomic , strong) NSString<Optional> *houseKeeperName;
//创建预约时间
@property (nonatomic , strong) NSString<Optional> *createAppointmentTime;
//预约看房时间
@property (nonatomic , strong) NSString<Optional> *appointmentTime;
/* 签约开始时间*/
@property (nonatomic , strong) NSString<Optional> *startTime;
/* 签约结束时间*/
@property (nonatomic , strong) NSString<Optional> *endTime;
/* 租客手机*/
@property (nonatomic , strong) NSString<Optional> *mobile;
/* 租客名字*/
@property (nonatomic , strong) NSString<Optional> *tenantName;
/*1整租 2合租*/
@property (nonatomic , strong) NSString<Optional> *rentType;
/* 管家ID */
@property (nonatomic , strong) NSString<Optional> *tawSystemUserId;
/* 通过正常渠道过来的预约：1 通过管家推荐过来的：2 */
@property (nonatomic , strong) NSString<Optional> *resourceType;
//租金
@property (nonatomic , strong) NSString<Optional> *rentPrice;
// 预约联系人
@property (nonatomic , strong) NSString<Optional> *contactsUser;

@end
