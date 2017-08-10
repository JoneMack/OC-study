//
//  CustomerInfo.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/14.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomerInfo

@end

@interface CustomerInfo : JSONModel

@property (nonatomic , strong) NSString<Optional> *mobile;
@property (nonatomic , strong) NSString<Optional> *birthDay;

@property (nonatomic , strong) NSString<Optional> *userName;
@property (nonatomic , strong) NSString<Optional> *nickName;
@property (nonatomic , strong) NSString<Optional> *sex;
@property (nonatomic , strong) NSString<Optional> *headPic;
/** 身份证号*/
@property (nonatomic , strong) NSString<Optional> *idNo;
/** 紧急联系人*/
@property (nonatomic , strong) NSString<Optional> *emergencyContactName;
/** 联系人电话*/
@property (nonatomic , strong) NSString<Optional> *emergencyContactPhone;
/** 联系人关系*/
@property (nonatomic , strong) NSString<Optional> *contactRelation;
/** 认证状态 0：未认证 1：已认证 */
@property (nonatomic , strong) NSString<Optional> *authenticationFlg;
/** 身份证正面照 */
@property (nonatomic , strong) NSString<Optional> *idCardFrontPic;
/** 身份证反面照 */
@property (nonatomic , strong) NSString<Optional> *idCardBackPic;
/** 手持身份证照 */
@property (nonatomic , strong) NSString<Optional> *idCardHandheldPic;
/** 签约状态 0：未签约 1：已签约 */
@property (nonatomic , strong) NSString<Optional> *signFlg;

@end
