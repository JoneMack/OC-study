//
//  NSString+Utils.h
//  ESD
//
//  Created by ap2 on 15/6/30.
//  Copyright (c) 2015年 zac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

// md5 32位 加密 （小写）
- (NSString *)md532BitLower;
- (NSString*)md532BitUpper;
//判断是否为整形：
- (BOOL)isPureInt;

//是否为纯数字
- (BOOL)isPureNumText;

@end
