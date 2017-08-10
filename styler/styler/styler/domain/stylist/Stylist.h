//
//  Expert.h
//  iUser
//
//  Created by System Administrator on 13-4-23.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"
#import "Organization.h"
#import "ServicePicture.h"
#import "OrderedTimeRange.h"
#import "StylistCount.h"
#import "CloseDate.h"
#import "JSONModel.h"
#import "HairCutPriceInfo.h"

#define stylist_data_status_open 2
#define stylist_data_status_out_of_stack 3

@protocol Stylist
@end


@interface Stylist : JSONModel

@property int id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *mobileNo;
@property (nonatomic, copy) NSString<Optional> *avatarUrl;
@property (nonatomic, copy) NSString<Optional> *offdaysStr;
@property (nonatomic, copy) NSArray<Optional> *offdays;
@property (nonatomic, copy) NSString *jobTitle;
@property (nonatomic, copy) NSString *haircutPrice;
@property int workHourStart;
@property int workHourEnd;
@property (nonatomic, copy) NSString *authorizedInfo;
@property (nonatomic, strong) Organization *organization;
@property int dataStatus;
@property long long int lastOrderTime;
@property (nonatomic, strong) StylistCount<Optional> * expertTotalCount;
@property (nonatomic, strong) NSArray<CloseDate,Optional> *closeDates;
@property (strong, nonatomic) HairCutPriceInfo<Optional> *hairCutPriceInfo;

-(NSString *) getTotalScoreStr;
-(NSArray *) daysCanDate;
-(NSArray *) hoursCanDate:(NSDate *)date;
-(BOOL) hasCloseDate;
-(NSString *) getCloseStartDate;
-(NSString *) getCloseEndDate;
-(NSMutableAttributedString *) getStylistScore;

-(NSMutableAttributedString *) getStylistHairCutPrice;
-(CGSize) getSize;
-(NSString *) getHairCutSpecialOfferPriceText;

@end

