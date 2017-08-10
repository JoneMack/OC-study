//
//  ShareSceneType.h
//  styler
//
//  Created by 冯聪智 on 14-9-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareContentType.h"

@interface ShareSceneType : NSObject

@property ShareContentType sharedContentType;   // 分享的内容类型  （ 比如分享发型师、分享商户）
@property ShareType sharedChannelType;   // 分享的渠道方法  （ 比如微信分享、新浪微博分享）

-(id) init __attribute__((unavailable("Must use initWithType: instead.")));

-(id) initWithType:(ShareContentType) sharedContentType sharedChannelType:(ShareType) sharedChannelType;

-(int) getValueOfSharedChannelType;  // 这个方法是用于获取自已后台对应的平台的值

@end
