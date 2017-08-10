//
//  SpecialEvent.h
//  styler
//
//  Created by System Administrator on 13-6-8.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialEvent : NSObject

@property int eventType;
@property (nonatomic, retain) NSString *eventName;

-(id)initWithTypeAndName:(int)type name:(NSString *)name;

+(NSString *) getEventName:(int)type;

+(NSArray *) allEvents;

@end
