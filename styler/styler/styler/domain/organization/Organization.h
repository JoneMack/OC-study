//
//  Organization.h
//  iUser
//
//  Created by System Administrator on 13-5-8.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"
#import "JSONModel.h"
@class HairDressingCard;

@protocol Picture
@end


@interface Picture : JSONModel

@property (copy, nonatomic) NSString *picUrl;
@property int organizationId;
@property float width;
@property float height;
@property BOOL coverPictureFlag;
@property long long int createTime;

@end


@protocol Organization
@end
@interface Organization : JSONModel

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *name;
@property int id;//商户id
@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString *cityDistrictName;
@property (copy, nonatomic) NSString *businessCirclesName;//商圈
@property int expertCount;//商户的专家数量
@property (strong, nonatomic) NSArray<Picture,Optional> *pictures;
@property (copy,nonatomic) NSString *brandName;
@property long long int createTime;
@property (copy, nonatomic) NSString *remark;
@property (copy, nonatomic) NSString *lngLatPoi;
@property (copy, nonatomic) NSString *poi;
@property (nonatomic, copy) NSString *phoneNo;
@property (nonatomic, copy) NSString *poiAddress;
@property float distance;
@property (copy, nonatomic) NSString *storeName;
@property (copy, nonatomic) NSString *branchName;
@property (copy, nonatomic) NSString *basicPriceInfo;
@property (copy, nonatomic) NSString *discountInfo;
@property (copy, nonatomic) NSString *hairCutPrice;
@property float trafficScore;
@property float environmentScore;
@property int receivedEvaluationCount;
@property (copy, nonatomic) NSString<Optional> *content;
@property (strong, nonatomic) NSMutableArray<Optional> *hdcs;

-(double) lat;
-(double) lng;
-(BOOL) hasContent;
-(NSString *) simpleInfoStr;
-(NSString *) getOrganizationName;
-(float) getEvaluationAvgScore;
-(NSString *) getDistanceTxt;
-(Picture *) getCoverPicture;
-(HairDressingCard *) getFistDisplayHairDressingCard;
-(HairDressingCard *) getNextHairDressingCard:(int) index;

-(void) addHairDressingCard:(HairDressingCard *)hairDressingCard;
-(NSString *) getBrandName;
-(void)tidyHdcSort:(NSArray *)hdcTypes;
@end



