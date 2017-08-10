//  Created by 郭煜 on 13-7-20.
//  Copyright (c) 2013年 郭煜. All rights reserved.

#import <Foundation/Foundation.h>

#ifndef __has_feature
#define __has_feature(x) 0
#endif

#if __has_feature(objc_arc)
#define TK_WEAK     weak
#define TK_STRONG   strong
#else
#define TK_WEAK     assign
#define TK_STRONG   retain
#endif

#if __has_feature(objc_arc)
#define TK_SAFE_RELEASE(obj)
#define TK_AUTORELEASE(obj)
#define TK_RETAIN(obj)
#define TK_RETAIN_AUTORELEASE(obj)
#define TK_BRIDGE   __bridge
#else
#define TK_SAFE_RELEASE(obj) do{[obj release]; obj = nil;}while(0)
#define TK_AUTORELEASE(obj) [obj autorelease]
#define TK_RETAIN(obj) [obj retain]
#define TK_RETAIN_AUTORELEASE(obj) [[obj retain]autorelease]
#define TK_BRIDGE
#endif

#ifdef __cplusplus
extern "C" {
#endif

//确认对象是否实现了指定的方法
void TKAssertSelectorNilOrImplementedWithArgs(id obj, SEL sel, ...);
//
NSString * TKGenerateUUID(void);
NSString * TKGetiOSDocumentDirectoryPath(void);
NSString * TKGetiOSCacheDirectoryPath(void);
NSString * TKGetiOSAppDirectoryPath(void);

#ifdef __cplusplus
}
#endif


