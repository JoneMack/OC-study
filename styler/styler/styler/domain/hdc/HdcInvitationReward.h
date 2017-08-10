//
//  HdcInvitationReward.h
//  styler
//
//  Created by 冯聪智 on 14-10-16.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define hdc_invitation_reward_status_rewarded    @"rewarded"
#define hdc_invitation_reward_status_received    @"received"

#import <Foundation/Foundation.h>

@protocol HdcInvitationReward

@end

@interface HdcInvitationReward : JSONModel

@property (nonatomic , copy) NSString *invationStatus;
@property (nonatomic , copy) NSString<Optional> *invitationUrl;
@property (nonatomic , copy) NSString *userHdcNum;
@property (nonatomic , strong) NSNumber<Optional> *rewardTime;
@property (nonatomic , strong) NSNumber<Optional> *receiveTime;
@property (nonatomic , strong) NSNumber<Optional> *invationTime;

@property int doneeId;    // 获赠人
@property int sponsorId;  // 转赠人


@end
