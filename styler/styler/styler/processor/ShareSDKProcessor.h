//
//  ShareSDKProcessor.h
//  styler
//
//  Created by wangwanggy820 on 14-8-8.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareContent.h"
#import "ShareSceneType.h"
#import "RewardActivity.h"

@protocol ShareResultDelegate <NSObject>

@optional
-(void)sharedSuccess;
-(void)sharedFail;
-(void)sharedCancel;

@end


@interface ShareSDKProcessor : NSObject<ISSShareViewDelegate>

@property (nonatomic, strong) id<ShareResultDelegate> delegate;

- (void)share:(ShareContent *)shareContent hideShareTypes:(NSMutableArray *)hideShareTypes shareViewDelegate:(id)shareViewDelegate sender:(id)sender shareSuccessBlock:(void(^)(ShareSceneType *shareSceneType))shareSuccessBlock;

+(void)customShareView:(UIViewController *)viewController shareType:(ShareType)shareType;

+(void)followSinaWeiBo;

+(void)initShareSDK;

-(void)followWeiXinTimeLine:(id)sender
               shareContent:(ShareContent *)shareContent
          shareSuccessBlock:(void(^)())shareSuccessBlock;

@end
