//
//  ExpertMessage.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/24.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ExpertMessage.h"

@implementation ExpertMessage


-(void) fillPics
{
    if (self.expertMassageImages.count >0) {
        self.expertMassageImages = [ExpertMessageImage arrayOfModelsFromDictionaries:self.expertMassageImages];
    }
}

-(void) fillPraiseStatus
{
    NSString *praisedIds = [AppStatus sharedInstance].praisedExpertMessageIds;
    NSArray *ids = [praisedIds componentsSeparatedByString:@","];
    for (NSString *praiseId in ids) {
        if ([praiseId isEqualToString:self.id]) {
            self.praiseStatus = @"YES";
            return;
        }
    }
    self.praiseStatus = @"NO";
}


-(NSString *) getPraiseCountStr
{
    return [NSString stringWithFormat:@"   赞（%d）" , self.praiseCount];
}

@end
