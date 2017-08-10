//
//  UserActiveNotifier.h
//  styler
//
//  Created by System Administrator on 14-6-22.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserActiveNotifier : NSObject

+(void) sendActiveNotify:(NSString *)location;

@end
