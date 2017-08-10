//
//  CfContractXS.h
//  xiangyu
//
//  Created by 冯聪智 on 16/8/3.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CfContractXS

@end


@interface CfContractXS : JSONModel


/** 出房合同Id*/
@property (nonatomic , strong) NSString<Optional> *cfContractId;
/** 收房合同Id*/
@property (nonatomic , strong) NSString<Optional> *sfContractId;
/** 租赁方式*/
@property (nonatomic , strong) NSString<Optional> *rentType;
/** 房屋ID*/
@property (nonatomic , strong) NSString<Optional> *houseId;
/** 房间ID*/
@property (nonatomic , strong) NSString<Optional> *roomId;
/** 小区ID*/
@property (nonatomic , strong) NSString<Optional> *projectId;
/** 小区名称*/
@property (nonatomic , strong) NSString<Optional> *projectName;
/** 商圈ID*/
@property (nonatomic , strong) NSString<Optional> *circleId;
/** 商圈名称*/
@property (nonatomic , strong) NSString<Optional> *circleName;
/** 几室*/
@property (nonatomic , strong) NSString<Optional> *fewRoom;
/** 房屋建筑面积*/
@property (nonatomic , strong) NSString<Optional> *area;
/** 房租月租金*/
@property (nonatomic , strong) NSString<Optional> *monthRent;
/** 付款方式（押X付Y的Y）*/
@property (nonatomic , strong) NSString<Optional> *paymentType;
/** 付款方式*/
@property (nonatomic , strong) NSString<Optional> *paymentTypeDisp;
/** 合同开始日*/
@property (nonatomic , strong) NSString<Optional> *contractStartDate;
/** 合同截至日期*/
@property (nonatomic , strong) NSString<Optional> *contractEndDate;
/** 首期租金*/
@property (nonatomic , strong) NSString<Optional> *firstRent;
@property (nonatomic , strong) NSString<Optional> *firstRentCode;
/** 押金*/
@property (nonatomic , strong) NSString<Optional> *payDeposit;
@property (nonatomic , strong) NSString<Optional> *payDepositCode;
/** 佣金*/
@property (nonatomic , strong) NSString<Optional> *serviceFee;
@property (nonatomic , strong) NSString<Optional> *serviceFeeCode;
/** 租客姓名*/
@property (nonatomic , strong) NSString<Optional> *tenantName;
/** 租客电话*/
@property (nonatomic , strong) NSString<Optional> *tenantPhone;
/** 租客证件类型*/
@property (nonatomic , strong) NSString<Optional> *tenantCredentialType;
/** 租客证件号码*/
@property (nonatomic , strong) NSString<Optional> *tenantCredentailNo;
/** 出房经纪人ID*/
@property (nonatomic , strong) NSString<Optional> *roompeopleid;

-(NSString *) getRentDate;

@end
