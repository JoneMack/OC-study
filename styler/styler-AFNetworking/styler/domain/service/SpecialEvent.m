//
//  SpecialEvent.m
//  styler
//
//  Created by System Administrator on 13-6-8.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "SpecialEvent.h"

@implementation SpecialEvent

-(id)initWithTypeAndName:(int)type name:(NSString *)name{
    self = [super init];
    if(self){
        self.eventType = type;
        self.eventName = name;
    }
    return self;
}

+(NSString *) getEventName:(int)type{
    NSArray *allEvents = [SpecialEvent allEvents];
    for(int i = 0; i < [allEvents count]; i++){
        SpecialEvent *event = (SpecialEvent *)[allEvents objectAtIndex:i];
        if(event.eventType == type)
            return event.eventName;
    }
    return @"";
}

+(NSArray *)allEvents{
    static NSMutableArray *allEvents = nil;
    if(allEvents == nil){
        allEvents = [[NSMutableArray alloc] init];
        SpecialEvent *event1 = [[SpecialEvent alloc] initWithTypeAndName:1 name:@"日常"];
        [allEvents addObject:event1];
        
        SpecialEvent *event2 = [[SpecialEvent alloc] initWithTypeAndName:2 name:@"商务"];
        [allEvents addObject:event2];
        
        SpecialEvent *event3 = [[SpecialEvent alloc] initWithTypeAndName:3 name:@"聚会"];
        [allEvents addObject:event3];
        
        SpecialEvent *event4 = [[SpecialEvent alloc] initWithTypeAndName:4 name:@"旅行"];
        [allEvents addObject:event4];
        
        SpecialEvent *event5 = [[SpecialEvent alloc] initWithTypeAndName:5 name:@"生日"];
        [allEvents addObject:event5];
        
        SpecialEvent *event6 = [[SpecialEvent alloc] initWithTypeAndName:6 name:@"结婚"];
        [allEvents addObject:event6];
    }
    return allEvents;
}

@end
