//
//  ExpertWork.h
//  styler
//
//  Created by System Administrator on 13-7-20.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#define work_detail_info_type_service_items 1
#define work_detail_info_type_special_offers 2
#define work_detail_info_type_notes 3
#define work_detail_info_type_service_time 4


#import <Foundation/Foundation.h>
#import "JSONSerializable.h"
#import "Stylist.h"
#import "TargetServiceItems.h"
#import "ServicePicture.h"
#import "Tag.h"

#define work_publish_status_out_of_stack 1
#define work_publish_status_published 2

@protocol StylistWork
@end

@interface StylistWork : JSONModel

@property int id;//作品id
@property int coverPictureId;
@property int stylistId;
@property (nonatomic, strong) Stylist<Optional> *stylist;
@property int collectedCount;//收藏统计 显示给用户看
@property (nonatomic, strong) NSString *title;//作品标题
@property (nonatomic, strong) TargetServiceItems *targetServiceItemSuite;//标的服务项目
@property (nonatomic, strong) NSArray<ServicePicture> *servicePictures;//
@property (nonatomic, retain) ServicePicture<Ignore> *cover;//图片
@property (nonatomic, strong) NSArray<Tag> *tags;//作品标签名
@property (nonatomic, strong) NSArray<Optional> *tagNames;//作品标签名
@property int publishStatus;//发布状态
@property (nonatomic, assign) long long int createTime;


-(ServicePicture *)getCover;
-(NSArray *) getWorkDetailCommonItemTxtsFromWorkStylistWork;
@end
