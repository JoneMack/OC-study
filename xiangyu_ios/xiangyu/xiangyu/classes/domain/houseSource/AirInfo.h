//
//  AirInfo.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/24.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AirInfo

@end

@interface AirInfo : JSONModel


@property (nonatomic , strong) NSString<Optional> *anchor;
@property (nonatomic , strong) NSString<Optional> *anchorId;
@property (nonatomic , strong) NSString<Optional> *anchorPic;
@property (nonatomic , strong) NSString<Optional> *anchorRole;
@property (nonatomic , strong) NSString<Optional> *houseId;
@property (nonatomic , strong) NSString<Optional> *id;
@property (nonatomic , strong) NSString<Optional> *launchTime;
@property (nonatomic , strong) NSString<Optional> *onairStatus;
@property (nonatomic , strong) NSString<Optional> *onairStatusNm;
@property (nonatomic , strong) NSString<Optional> *roomId;
@property (nonatomic , strong) NSString<Optional> *url;


@end
