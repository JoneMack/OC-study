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


@interface ShareSDKProcessor : NSObject<ISSShareViewDelegate>

- (void)share:(ShareContent *)shareContent shareViewDelegate:(id)shareViewDelegate sender:(id)sender shareSuccessBlock:(void(^)(ShareSceneType *shareSceneType))shareSuccessBlock;

+(void)customShareView:(UIViewController *)viewController shareType:(ShareType)shareType;

+(void)followSinaWeiBo;

+(void)initShareSDK;

-(void)followWeiXinTimeLine:(id)sender
               shareContent:(ShareContent *)shareContent
          shareSuccessBlock:(void(^)())shareSuccessBlock;

@end
