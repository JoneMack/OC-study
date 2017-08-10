//
//  Expert.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/19.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"
#import "JSONModel.h"
#import "NSArray+JSONModel.h"
#import "ExpertPriceList.h"
#import "UserExpertRelation.h"


@protocol Expert
@end

@interface Expert : JSONModel

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, assign) int userGender;
@property (nonatomic, copy) NSString<Optional> *shortIntroduction;  //专家认证
@property (nonatomic, copy) NSString<Optional> *introduction;       //专家成就
@property (nonatomic, assign) int followCount;            //关注数量
@property (nonatomic, assign) int subscribeCount;         //当前订阅量
@property (nonatomic, assign) int historySubscribeCount;  //历史订阅量
@property (nonatomic, assign) int msgCount;               //消息数量
@property (nonatomic, strong) NSArray<ExpertPriceList> *expertPriceLists;

@property (nonatomic, copy) NSString<Optional> *relationStatus;  // 与专家的状态 , 关注:Follow , 收藏:Subscribe , 没有关注：None
@property (nonatomic, copy) NSString<Optional> *massageReceiveStatus; // 接收消息的状态，allOn：全部接收，secretOn：私密接收，off：禁止接收
@property (nonatomic, strong) UserExpertRelation<Optional> *userExpertRelation;

@end
