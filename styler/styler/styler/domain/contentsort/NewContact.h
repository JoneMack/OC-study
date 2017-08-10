//
//  NewContact.h
//  Golf
//
//  Created by xubojoy on 15/4/20.
//  Copyright (c) 2015年 xubojoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewContact
@end

@interface NewContact : JSONModel

@property  (nonatomic, assign) int userId;
@property  (nonatomic ,copy) NSString *name;
@property  (nonatomic ,copy) NSString *phone;
@property  (nonatomic, assign) int userGender;
@property  (nonatomic, assign) int contactsType; //联系方式类别: 0:用户联系方式，用于商品邮寄地址，1：球友联系方式，用于预约球场

@end
