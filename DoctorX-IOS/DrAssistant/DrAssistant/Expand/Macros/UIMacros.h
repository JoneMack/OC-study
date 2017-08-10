//
//  UIMacros.h
//  DrAssistant
//
//  Created by hi on 15/8/30.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#ifndef DrAssistant_UIMacros_h
#define DrAssistant_UIMacros_h

#define COLOR(R,G,B,A) [UIColor colorWithRed:(R/255.0) green:(G/255.0) blue:(B/255.0) alpha:A]

// 屏幕的宽和高，导航和状态条高度
#define kSCREEN_WIDTH           [[UIScreen mainScreen] bounds].size.width
#define kSCREEN_HEIGHT          [[UIScreen mainScreen] bounds].size.height
#define kNAVIGATIONG_HEIGHT     44.0f
#define kSTATURSBAR_HEIGHT      [[UIApplication sharedApplication] statusBarFrame].size.height
#define kVIEW_NOSTATURS_HEIGHT  (kSCREEN_HEIGHT - kSTATURSBAR_HEIGHT)   // 除去状态条
#define kVIEW_NONAVI_HEIGHT     (kSCREEN_HEIGHT - kNAVIGATIONG_HEIGHT - kSTATURSBAR_HEIGHT)// 除去导航和状态条
// 没有数据的占位
#define PLACEHOLDERINSCROLL     @"nomessage.png"
#endif
