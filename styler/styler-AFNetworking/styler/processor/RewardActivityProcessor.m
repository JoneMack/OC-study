//
//  RedEnvelopeProcessor.m
//  styler
//
//  Created by 冯聪智 on 14-9-9.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "RewardActivityProcessor.h"
#import "RedEnvelopeStore.h"
#import "OrganizationDetailInfoController.h"
#import "StylistProfileController.h"
#import "WorkDetailController.h"
#import "RedEnvelopeActivityRemindView.h"
#import "RewardActivityInputMobileNoView.h"
#import "RewardActivityOverView.h"
#import "RewardActivityStore.h"
#import "UserAction.h"
#import "NSStringUtils.h"
#import "ShareSceneType.h"
#import "ShareContentType.h"
#import "RewardObject.h"
#import "ShareSDKProcessor.h"


@implementation RewardActivityProcessor
{
    int i;
    NSArray *actionTypes;
    ShareSceneType *currentShareSceneType;
    RewardActivityResultView *rewardActivityResultView;
    RewardActivityInputMobileNoView *rewardActivityInputMobileNoView;
    RewardActivityOverView *rewardActivityOverView;
    NSString *bannerUrlStr;
    NSString *remindContent;
}

+(void) initRewardActivityProcessorObserver{
    
    // 分享成功后的监听
    [[NSNotificationCenter defaultCenter] addObserver:[RewardActivityProcessor sharedInstance]
                                             selector:@selector(showSharedSuccessResult:)
                                                 name:notification_name_user_shared_success_show_reward_activity
                                               object:nil];
    // 未登录用户奖励活动填写完手机号后的监听
    [[NSNotificationCenter defaultCenter] addObserver:[RewardActivityProcessor sharedInstance]
                                             selector:@selector(finishInputMobileNoReadyGetUserActionReward:)
                                                 name:notification_name_reward_activity_after_input_mobile_no
                                               object:nil];
    
    
}

-(void) checkoutRedEnvelopeActivity{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        if (actionTypes == nil) {
            actionTypes = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", shareOrganizationPage],
                           [NSString stringWithFormat:@"%d", shareStylistPage],
                           [NSString stringWithFormat:@"%d", shareStylistWorkPage],
                           [NSString stringWithFormat:@"%d", shareOrganizationPage],
                           [NSString stringWithFormat:@"%d", shareHdcPage],
                           nil];
        }
        for (NSString *actionType in actionTypes) {
            NSNumber *startTime = [self getLastRewardActivityStartTime:actionType];
            [RewardActivityStore getRewardActivity:^(RewardActivity *rewardActivity, NSError *error) {
                if (rewardActivity != nil && rewardActivity.id > 0) {
                    // 查看奖励活动对应的红包种子
                    bannerUrlStr = rewardActivity.bannerUrl;
                    [RedEnvelopeStore getRedEnvelopeSeedById:^(RedEnvelopeSeed *redEnvelopeSeed, NSError *error) {
                        rewardActivity.redEnvelopeSeed = redEnvelopeSeed;
                        [self updateRewardActivity:rewardActivity];

                    } redEnvelopeSeedId:rewardActivity.redEnvelopeSeedId];
                }else {
                    // 如果没有这个类型的活动，则查看之前的活动队列里是否有这个类型的活动，如果有，则干掉，说明该活动已过期。
                    [self setCurrentRewardActivity2joinedRewardActivityQueue:[actionType intValue]];
                }
            } actionType:[actionType intValue] startTime:startTime ];
        }
    });
}

-(void) tryDisplayMovement:(UIViewController *)vc{
    
    int currentActionTypeShared = -1;
    ShareContent *shareContent = nil;
    if ([vc isKindOfClass:[OrganizationDetailInfoController class]]) {
        remindContent = @"商户";
        currentActionTypeShared = shareOrganizationPage;
        OrganizationDetailInfoController *organizationDetailInfoController = (OrganizationDetailInfoController *)vc;
        shareContent = [organizationDetailInfoController collectionShareContent];
    }else if([vc isKindOfClass:[StylistProfileController class]]){
        remindContent = @"发型师";
        currentActionTypeShared = shareStylistPage;
        StylistProfileController *stylistProfileController = (StylistProfileController *)vc;
        shareContent = [stylistProfileController collectionShareContent];
    }else if([vc isKindOfClass:[WorkDetailController class]]){
        remindContent = @"作品";
        currentActionTypeShared = shareStylistWorkPage;
        WorkDetailController *workDetailController = (WorkDetailController *)vc;
        shareContent = [workDetailController collectionShareContent];
    }
    
    if ([NSStringUtils isNotBlank:remindContent] && currentActionTypeShared>0) {
        RewardActivity *rewardActivity = [self getRewardActivityByActionType:currentActionTypeShared];
        
//        NSLog(@">>>>>rewardActivity>>>>>%@",rewardActivity);

        if (rewardActivity == nil || !rewardActivity.canDisplay) {
            return;
        }
        if (rewardActivity == nil) {
            return;
        }
        NSString *perAmount = rewardActivity.redEnvelopeSeed.distributeStrage.perAmount;
        int maxAmount = [[[perAmount componentsSeparatedByString:@","] lastObject] intValue];
        NSString *activityDescription = [NSString stringWithFormat:@"推荐此%@到微信朋友圈得红包，最多%d元！",
                               remindContent,maxAmount];

        RedEnvelopeActivityRemindView *rmv = [[RedEnvelopeActivityRemindView alloc] initWithShareContent:shareContent
                                                                                     activityDescription:activityDescription
                                                                                                  amount:maxAmount];
        rmv.frame = [[UIApplication sharedApplication].keyWindow frame];
        rmv.remindView.center = [[UIApplication sharedApplication].keyWindow center];
        [[UIApplication sharedApplication].keyWindow addSubview:rmv];
//        [rewardActivity viewCountIncrease];
        [self saveRewardActivitiesQueres];
    }
}

/**
    判断是否有奖励活动
 */
-(BOOL) hasRewardActivy:(ShareSceneType *) shareSceneType{
    if ([self.currentRewardActivities objectForKey:[NSString stringWithFormat:@"%d",shareSceneType.sharedContentType]] != nil) {
        RewardActivity *rewardActivity = [self getRewardActivityByActionType:shareSceneType.sharedContentType];
        if (rewardActivity==nil || rewardActivity.actionParams == nil) {  // 不限制分享类型
            return NO;
        }
        if (![rewardActivity hasRedEnvelopeSeed]) {
            return NO;
        }
        NSDictionary *actionParams = rewardActivity.actionParams;
        int sharePlatform = [[actionParams objectForKey:@"sharePlatform"] intValue];   // 现在每个活动只有一种分享类型，不需要考虑多个
        if ([shareSceneType getValueOfSharedChannelType ] == sharePlatform) {
            return YES;
        }
        return NO;
    }
    return NO;
}

-(BOOL) hasRewardActivityInSharedContentType:(int)sharedContentType{
    if ([self.currentRewardActivities objectForKey:[NSString stringWithFormat:@"%d",sharedContentType]] != nil) {
        RewardActivity *rewardActivity = [self getRewardActivityByActionType:sharedContentType];
        if (rewardActivity==nil || rewardActivity.actionParams == nil) {  // 不限制分享类型
            return NO;
        }
        if (![rewardActivity hasRedEnvelopeSeed]) {  // 没有红包种子了
            return NO;
        }
        return YES;
    }
    return NO;
}

-(NSString *)getActivityBannerUrl:(ShareContentType)actionType{
    RewardActivity *rewardActivity = [[RewardActivityProcessor sharedInstance] getRewardActivityByActionType:actionType];
    return  rewardActivity.bannerUrl;
}

-(NSNumber *) getLastRewardActivityStartTime:activityType{
    
    if (self.joinedRewardActivities != nil) {
        for (RewardActivity *rewardActivity in self.joinedRewardActivities) {
            if (rewardActivity.actionType == [activityType intValue]){
                return rewardActivity.startTime;
            }
        }
        return nil;
    }
    return nil;
}

-(RewardActivity *) getRewardActivityByActionType:(int)actionType{
    if (self.currentRewardActivities == nil) {
        return nil;
    }
    return [self.currentRewardActivities objectForKey:[NSString stringWithFormat:@"%d" ,actionType]];
}

-(void) updateRewardActivity:(RewardActivity *)newRewardActivity{
    // 一个类型的活动只能有一个。
    
    if (self.currentRewardActivities == nil) {
        self.currentRewardActivities = [NSMutableDictionary new];
    }
    RewardActivity *rewardActivity = [self.currentRewardActivities objectForKey:[NSString stringWithFormat:@"%d" ,newRewardActivity.actionType]];
    if (rewardActivity != nil && rewardActivity.id == newRewardActivity.id) {
        newRewardActivity.viewCount = rewardActivity.viewCount;
    }
    
    [self.currentRewardActivities setValue:newRewardActivity forKey:[NSString stringWithFormat:@"%d" , newRewardActivity.actionType]];
    [self saveRewardActivitiesQueres];
}


-(void) saveRewardActivitiesQueres{
    [NSKeyedArchiver archiveRootObject:[RewardActivityProcessor sharedInstance] toFile:[RewardActivityProcessor savedPath]];
}


#pragma mark 分享成功后的处理逻辑
-(void) showSharedSuccessResult:(NSNotification *) notification{
    currentShareSceneType = (ShareSceneType *)notification.object;
    // 先查看是否有该活动
    if ([self hasRewardActivy:currentShareSceneType]) {
        // 创建userAction用户触发事件 并获取奖励
        [self createUserActionAndGetReward];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"分享成功" duration:0.5];
    }
}

-(void)createUserActionAndGetReward{
    [SVProgressHUD showWithStatus:network_status_loading maskType:SVProgressHUDMaskTypeGradient];
    
    [RewardActivityStore postUserAction:^(UserAction *userAction, NSError *error) {
        if (error == nil) {
            AppStatus *appStatus = [AppStatus sharedInstance];
               // 如果登录的话，就请求用户触发事件 , 直接进入结果页面
            if (appStatus.logined) {
                [self getUserActionReward:userAction];  // 轮询获取奖励
            }else{ // 如果未登录 ， 先显示输入手机号的页面，输入手机号 , 将手机号和actionId 一起发到后台，然后再开始轮训奖励
                [self showInputMobileNoAndGetReward:userAction];
                
            }
        }
    } shareSceneType:currentShareSceneType];
}

#pragma mark 未登录的用户显示输入手机号并获取奖励的页面
-(void)showInputMobileNoAndGetReward:(UserAction *)userAction{
    [SVProgressHUD dismiss:^{
        RewardActivity *rewardActivity = [self getRewardActivityByActionType:currentShareSceneType.sharedContentType];
        NSString *perAmount = rewardActivity.redEnvelopeSeed.distributeStrage.perAmount;
        int maxAmount = [[[perAmount componentsSeparatedByString:@","] lastObject] intValue];
        
        NSString *title = [NSString stringWithFormat:@" 推荐此%@到微信朋友圈得红包，最多%d元！",remindContent,maxAmount];
        rewardActivityInputMobileNoView = [[RewardActivityInputMobileNoView alloc] initWithTitle:title userAction:userAction withAmount:maxAmount];
        [[UIApplication sharedApplication].keyWindow addSubview:rewardActivityInputMobileNoView];
    }];
    
}

#pragma mark 未登录用户输入完手机号准备开始轮询获取奖励
-(void) finishInputMobileNoReadyGetUserActionReward:(NSNotification *) notification{
    UserAction *userAction = (UserAction *)notification.object;
    [self getUserActionReward:userAction];
}


#pragma mark  轮询并返回活动结果页面
-(void)getUserActionReward:(UserAction *)userAction{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0);
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [RewardActivityStore getUserAction:^(UserAction *userAction, NSError *error) {
            if (userAction.rewardStatus == action_activity_result_no_reward ) {
                [self displayNoRewardResultView];
            }else if (userAction.rewardStatus == action_activity_result_has_reward){
                [RewardActivityStore getRewardObjectByActionId:^(RewardObject *rewardObject, NSError *error) {
                    NSString *result = [NSString stringWithFormat:@"%@元红包到手！\n美发可以不！花！钱！",[rewardObject.reward valueForKey:@"amount"]];
//                    NSLog(@">>>>>>>>>object amount:%d",rewardObject.reward.amount);
                    [self displayhasRewardResultView:result];
                } ActionId:userAction.id];
            }else if(userAction.rewardStatus == action_activity_result_has_rewarded){
                [self displayhasRewardResultView:has_rewarded_text];
            }else{
                [self getUserActionReward:userAction];
            }
        } userActionId:userAction.id];
    });
}

-(void) displayNoRewardResultView{
    [SVProgressHUD dismiss:^{
        rewardActivityOverView = [[RewardActivityOverView alloc] init];
        [[UIApplication sharedApplication].keyWindow addSubview:rewardActivityOverView];
        [self setCurrentRewardActivity2joinedRewardActivityQueue:currentShareSceneType.sharedContentType];
        
        //分享完成后把当前参加的活动加到已参加的对列里，调用以下代理方法去reload当前页
        if ([self.delegate respondsToSelector:@selector(shareSuccessed)]) {
            [self.delegate shareSuccessed];
        }
    }];
}

-(void) displayhasRewardResultView:(NSString *)result{
    [SVProgressHUD dismiss:^{
        RewardActivity *rewardActivity = [self getRewardActivityByActionType:currentShareSceneType.sharedContentType];
        NSString *perAmount = rewardActivity.redEnvelopeSeed.distributeStrage.perAmount;
        int maxAmount = [[[perAmount componentsSeparatedByString:@","] lastObject] intValue];
        rewardActivityResultView = [[RewardActivityResultView alloc] initWithReceiveDesc:result
                                                                                  amount:maxAmount
                                                                 secondRedEnvelopeSeedId:rewardActivity.secondRedEnvelopeSeedId];
        [[UIApplication sharedApplication].keyWindow addSubview:rewardActivityResultView];
        [self setCurrentRewardActivity2joinedRewardActivityQueue:currentShareSceneType.sharedContentType];
        
        //分享完成后把当前参加的活动加到已参加的对列里，调用以下代理方法去reload当前页
        if ([self.delegate respondsToSelector:@selector(shareSuccessed)]) {
            [self.delegate shareSuccessed];
        }
    }];
}

-(void) setCurrentRewardActivity2joinedRewardActivityQueue:(int) actionType{
    RewardActivity *rewardActivity = [self getRewardActivityByActionType:actionType];
    if (rewardActivity == nil) {
        return;
    }
    if (self.joinedRewardActivities == nil) {
        self.joinedRewardActivities = [[NSMutableArray alloc] init];
    }
    [self.joinedRewardActivities addObject:rewardActivity];
    [self.currentRewardActivities removeObjectForKey:[NSString stringWithFormat:@"%d",actionType]];
    
    [self saveRewardActivitiesQueres];
}

-(void) encodeWithCoder:(NSCoder *)aCoder{		
    
    [aCoder encodeObject:self.currentRewardActivities forKey:@"currentRewardActivities"];
    [aCoder encodeObject:self.joinedRewardActivities forKey:@"joinedRewardActivities"];
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.joinedRewardActivities = [aDecoder decodeObjectForKey:@"joinedRewardActivities"];
        self.currentRewardActivities = [[NSMutableDictionary alloc] initWithDictionary:[aDecoder decodeObjectForKey:@"currentRewardActivities"]];
    }
    return self;
}

-(void) cleanLocalData{
    self.currentRewardActivities = nil;
    self.joinedRewardActivities = nil;
    [self saveRewardActivitiesQueres];
}

+(RewardActivityProcessor *)sharedInstance{
    static RewardActivityProcessor *sharedInstance = nil;
    if(sharedInstance == nil){
        NSString *path = [RewardActivityProcessor savedPath];
        sharedInstance = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if(sharedInstance == nil)
            sharedInstance = [[RewardActivityProcessor alloc] init];
    }
    return sharedInstance;
}

+(NSString *) savedPath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"rewardActivity.archive"];
    return documentDirectory;
}

@end
