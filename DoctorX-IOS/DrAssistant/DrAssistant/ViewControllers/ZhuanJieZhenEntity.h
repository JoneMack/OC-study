//
//  ZhuanJieZhenEntity.h
//  DrAssistant
//
//  Created by Seiko on 15/10/10.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "BaseEntity.h"

@interface ZhuanJieZhenEntity : BaseEntity
/*
 {
 "IN_ORG": "河南省人民医院",
 "RECEIVE_USER": "于红淘",
 "SEND_USER": "",
 "RECEIVE_THUMB": "http://172.21.102.199:8080/doctorx/upload/2015/09/08/14/42c9a539-fa7f-4ed0-a3df-52d998b9bd32_mmexport1441692142073.jpg",
 "ID": 40,
 "SEX": 0,
 "PHONE": "患得患失",
 "MEDICAL_INTRODUCTION": "家校互動不",
 "OUT_ORG_ID": -1,
 "IN_ORG_ID": 3,
 "RECEIVE_USER_ID": 4,
 "RECEIVE_DEPT_ID": 0,
 "SEND_USER_ID": 948,
 "SEND_DEPT_ID": 0,
 "STATUS": 0,
 "type": 0
 }
 */
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *IN_ORG;
@property (nonatomic,copy) NSString *IN_ORG_ID;
@property (nonatomic,copy) NSString *MEDICAL_INTRODUCTION;
@property (nonatomic,copy) NSString *OUT_ORG_ID;
@property (nonatomic,copy) NSString *OUT_ORG;
@property (nonatomic,copy) NSString *PHONE;
@property (nonatomic,copy) NSString *RECEIVE_DEPT_ID;
@property (nonatomic,copy) NSString *RECEIVE_THUMB;
@property (nonatomic,copy) NSString *RECEIVE_USER;
@property (nonatomic,copy) NSString *RECEIVE_USER_ID;
@property (nonatomic,copy) NSString *SEND_DEPT_ID;
@property (nonatomic,copy) NSString *SEND_USER;
@property (nonatomic,copy) NSString *SEND_USER_ID;
@property (nonatomic,copy) NSString *SEX;
@property (nonatomic,copy) NSString *STATUS;
@property (nonatomic,copy) NSString *SEND_THUMB;
@property (nonatomic,copy) NSString *type;// 1代表转诊，0代表接诊

@end
