//
//  Contacts.h
//  Golf
//
//  Created by xubojoy on 15/4/8.
//  Copyright (c) 2015年 xubojoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Contact
@end

@interface Contact : JSONModel

@property  (nonatomic, assign) int userId;
@property  (nonatomic ,copy) NSString *name;
@property  (nonatomic ,copy) NSString *phone;
@property  (nonatomic, assign) int userGender;
@property  (nonatomic, assign) int contactsType; //联系方式类别: 0:用户联系方式，用于商品邮寄地址，1：球友联系方式，用于预约球场


-(NSString *)getJsonString;

@end
