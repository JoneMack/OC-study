//
//  BaseEntity.h
//  DrAssistant
//
//  Created by hi on 15/8/27.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserContext.h"

UIKIT_EXTERN NSString *const SecureKey;

@interface BaseEntity : NSObject

@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *msg;

- (NSDictionary *)dictionaryOfEntity;

- (NSMutableDictionary *)basePramsDictionary;

+ (NSDictionary *)sign:(NSArray *)prams;

@end
