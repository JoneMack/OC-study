//
//  RewardActivity.h
//  styler
//
//  Created by 冯聪智 on 14-9-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define action_activity_result_no_reward 2
#define action_activity_result_has_reward 3
#define action_activity_result_has_rewarded 4

#import <Foundation/Foundation.h>
#import "RedEnvelopeSeed.h"

@protocol RewardActivity
@end

@interface RewardActivity : JSONModel <NSCoding>

@property int id;
@property int actionType;    //  动作类型 1:分享商户；2：分享发型师；3：分享作品
@property (nonatomic , strong) NSDictionary<Optional> *actionParams;    // Map类型动作特征
@property (nonatomic , strong) NSNumber *startTime;
@property (nonatomic , strong) NSNumber<Optional> *endTime;
@property int redEnvelopeSeedId;    //  奖励红包对应的种子
@property int secondRedEnvelopeSeedId;   //分享的红包种子
//@property int rewardType;    //  奖励类型 1:红包；2：红包种子（目前只有1）
@property (nonatomic, copy) NSString *bannerUrl;
@property (nonatomic , strong) NSNumber<Optional>  *viewCount;   // 查看红包提醒的次数

@property (nonatomic , strong) RedEnvelopeSeed<Optional> *redEnvelopeSeed;


-(BOOL) canDisplay;
-(void) viewCountIncrease;
-(int) getRedEnvelopeAmount;
-(BOOL) hasRedEnvelopeSeed;
@end
