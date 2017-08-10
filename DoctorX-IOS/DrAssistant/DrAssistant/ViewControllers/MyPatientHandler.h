//
//  MyPatientHandler.h
//  DrAssistant
//
//  Created by ap2 on 15/9/15.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseHandler.h"
#import "GroupListEntity.h"

@interface MyPatientHandler : BaseHandler

+ (void)getAllGroupWithType:(NSInteger)type success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;

+ (void)deleteFriendByAccount:(NSString *)account friendLoginName:(NSString *)friendLoginName success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;
+ (void)changeGroupByAccount:(NSString *)account friendLoginName:(NSString *)friendId groupId:(NSString *)groupId success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;
+ (void)checkWhetherJoinedClubWithType:(NSInteger)type success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;

+ (void)getClubDetailDataByDoctorId:(NSString *)doctorId success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;
+ (void)getHealthDataByFriendId:(NSString *)friendId success:(RequestSuccessBlock)success fail:(RequestFailBlock)fail;
@end
