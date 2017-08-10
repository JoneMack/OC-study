//
//  RoomShip.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/23.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol RoomShip
@end

@interface RoomShip : JSONModel



/** 卧室名称 */
@property (nonatomic , strong) NSString<Optional> *roomName;
/** 租客性别 */
@property (nonatomic , strong) NSString<Optional> *sex;
/** 卧室编号 */
@property (nonatomic , strong) NSString<Optional> *roomSeq;
/** 租客星座 */
@property (nonatomic , strong) NSString<Optional> *star;
/** 卧室面积 */
@property (nonatomic , strong) NSString<Optional> *roomArea;
/** 是否入住 1：已入住，0：未入住 */
@property (nonatomic , strong) NSString<Optional> *alreadyStay;






@end
