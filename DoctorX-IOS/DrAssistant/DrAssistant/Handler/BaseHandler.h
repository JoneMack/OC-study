//
//  BaseHandler.h
//  DrAssistant
//
//  Created by hi on 15/8/27.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"
#import "GRNetworkAgent.h"

typedef NS_ENUM(NSInteger, RequestTag) {

     RequestTag_Default,
};

typedef void(^RequestSuccessBlock)(BaseEntity *object);
typedef void(^RequestFailBlock)(id object);

@interface BaseHandler : NSObject


@end
