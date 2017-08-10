//
//  RedEnvelopeProcessor.h
//  styler
//
//  Created by 冯聪智 on 14-9-9.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareSceneType.h"
#import "RewardActivityResultView.h"
#import "RewardActivity.h"

#define constant_amount_type 0
#define interval_amount_type 1

@interface RewardActivityProcessor : NSObject<NSCoding,ISSShareViewDelegate>

@property (nonatomic , strong) NSMutableDictionary *currentRewardActivities;
@property (nonatomic , strong) NSMutableArray *joinedRewardActivities;

-(void) checkoutRedEnvelopeActivity;
-(void) tryDisplayMovement:(UIViewController *)vc;
/**
 *  分享后判断是否有奖励活动
 */
-(BOOL) hasRewardActivy:(ShareSceneType *) shareSceneType;
-(void) showSharedSuccessResult:(NSNotification *) notification;
-(void) cleanLocalData;
/**
 *  分享前判断是否有奖励活动
 */
-(BOOL) hasRewardActivityInSharedContentType:(int)sharedContentType;
-(RewardActivity *) getRewardActivityByActionType:(int)actionType;

/**
 * 通过活动类型(发型师活动、作品活动等等) 获取奖励活动的banner
 */
-(NSString *)getActivityBannerUrl:(ShareContentType)actionType;

+(void) initRewardActivityProcessorObserver;
+(RewardActivityProcessor *)sharedInstance;
+(NSString *) savedPath;

@end
