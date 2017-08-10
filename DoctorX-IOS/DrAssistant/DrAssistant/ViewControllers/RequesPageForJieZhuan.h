//
//  RequesPageForJieZhuan.h
//  DrAssistant
//
//  Created by Seiko on 15/10/10.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "BaseHandler.h"
#import "ZhuanJieZhenProContect.h"

typedef void (^reSultBlock)(id response);
@interface RequesPageForJieZhuan : BaseHandler
@property(nonatomic ,copy)reSultBlock resultBlockArray;

/*
 get 转诊记录
 */
//+ (void)startRequestWithStringWithDataArraySuccess:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;

+ (void)startRequestWithStringWithDataArray:(reSultBlock)dataBlock withErrorBlock:(reSultBlock)errorBlock;

+ (void)saveZhuanJieZhenDataUpLoad:(NSDictionary *)dictionary withSuccess:(reSultBlock)dataBlock withErrorBlock:(reSultBlock)errorBlock;

+ (void)searchHospital:(NSString *)hospitalName withSuccess:(reSultBlock)dataBlock withErrorBlock:(reSultBlock)errorBlock;

+ (void)searchDoctor:(NSString *)HospitalID withSuccess:(reSultBlock)dataBlock withErrorBlock:(reSultBlock)errorBlock;
@end
