//
//  RewardActivity.m
//  styler
//
//  Created by 冯聪智 on 14-9-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define reward_activity_remind_count 2

#import "RewardActivity.h"

@implementation RewardActivity


-(BOOL)canDisplay{
//    if ([self.viewCount intValue] >= reward_activity_remind_count){  // 超过提醒次数
//        return NO;
//    }
    if (self.redEnvelopeSeed.exhaused) {  // 种子枯竭
        return NO;
    }
    return YES;
}

-(void)viewCountIncrease{
    self.viewCount = [NSNumber numberWithInt:[self.viewCount intValue] + 1] ;
}


-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.id forKey:@"id"];
    [aCoder encodeInt:self.actionType forKey:@"actionType"];
    [aCoder encodeObject:self.actionParams forKey:@"actionParams"];
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
    [aCoder encodeObject:self.endTime forKey:@"endTime"];
    [aCoder encodeInt:self.redEnvelopeSeedId forKey:@"redEnvelopeSeedId"];
    [aCoder encodeInt:self.secondRedEnvelopeSeedId forKey:@"secondRedEnvelopeSeedId"];
    [aCoder encodeObject:self.bannerUrl forKey:@"bannerUrl"];
    [aCoder encodeObject:self.viewCount forKey:@"viewCount"];
    [aCoder encodeObject:self.redEnvelopeSeed forKey:@"redEnvelopeSeed"];
}


-(id)initWithCoder:(NSCoder *)aDecoder{

    self = [super init];
    if(self){
        self.id = [aDecoder decodeIntForKey:@"id"];
        self.actionType = [aDecoder decodeIntForKey:@"actionType"];
        self.actionParams = [aDecoder decodeObjectForKey:@"actionParams"];

        self.startTime = [aDecoder decodeObjectForKey:@"startTime"];
        self.endTime = [aDecoder decodeObjectForKey:@"endTime"];
        self.redEnvelopeSeedId = [aDecoder decodeIntForKey:@"redEnvelopeSeedId"];
        self.secondRedEnvelopeSeedId = [aDecoder decodeIntForKey:@"secondRedEnvelopeSeedId"];
        self.bannerUrl = [aDecoder decodeObjectForKey:@"bannerUrl"];
        self.viewCount = [aDecoder decodeObjectForKey:@"viewCount"];
        self.redEnvelopeSeed = [aDecoder decodeObjectForKey:@"redEnvelopeSeed"];
        if (self.actionParams == nil) {
            self.actionParams = [NSDictionary new];
        }
        if (self.viewCount == nil) {
            self.viewCount = [[NSNumber alloc] initWithInt:0];
        }
    }
    return self;
}

-(int) getRedEnvelopeAmount{
    return [self.redEnvelopeSeed.distributeStrage.perAmount intValue];
}

-(BOOL) hasRedEnvelopeSeed{
    if (self.redEnvelopeSeed != nil && !self.redEnvelopeSeed.exhaused) {
        return YES;
    }
    return NO;
}

@end
