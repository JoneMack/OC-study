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

// TODO : 创建一个代理
@protocol RewardActivityProcessorDelegate <NSObject>
-(void)shareSuccessed;

@end

@interface RewardActivityProcessor : NSObject<NSCoding,ISSShareViewDelegate>

@property (nonatomic , strong) NSMutableDictionary *currentRewardActivities;
@property (nonatomic , strong) NSMutableArray *joinedRewardActivities;
@property (nonatomic , assign) id <RewardActivityProcessorDelegate>delegate;
// TODO : 定义一个代理

-(void) checkoutRedEnvelopeActivity;
-(void) tryDisplayMovement:(UIViewController *)vc;
-(BOOL) hasRewardActivy:(ShareSceneType *) shareSceneType;
-(void) showSharedSuccessResult:(NSNotification *) notification;
-(void) cleanLocalData;
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
