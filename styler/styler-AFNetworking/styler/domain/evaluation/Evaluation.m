//
//  Evaluation.m
//  styler
//
//  Created by aypc on 13-12-17.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "Evaluation.h"
#import "EvaluationPicture.h"
#import "AppStatus.h"

@implementation Evaluation


//根据属性名判断是否可选
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}


+(NSString *)getScoreText:(int)score
{
    NSString *text = nil;
    switch (score) {
        case 1:
            text = @"很差";
            break;
        case 2:
            text = @"差";
            break;
        case 3:
            text = @"一般";
            break;
        case 4:
            text = @"较好";
            break;
        case 5:
            text = @"很好";
            break;
        default:
            break;
    }
    return text;
}

@end

@implementation OrganizationEvaluation

@end


@implementation StylistEvaluation

-(BOOL)hasContent{
    return ((NSNull *)self.content != [NSNull null]) && self.content.length > 0;
}

-(NSString *) honorName
{
    NSString *userNameStr = [self.userName substringToIndex:1];
    
    if (self.userGender == 0)
    {
        return [NSString stringWithFormat:@"%@女士", userNameStr];
    }else{
        
        return [NSString stringWithFormat:@"%@先生", userNameStr];
    }
    
}

@end

@implementation NewEvaluation

-(NSString *)getJsonString
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(self.userId) forKey:@"userId"];
    [params setObject:@(self.stylistId) forKey:@"stylistId"];
    if (![self.content isEqualToString:@""]) {
        [params setObject:self.content forKey:@"content"];
    }
    [params setObject:@(self.orderId) forKey:@"orderId"];
    [params setObject:[NSString stringWithFormat:@"%d",self.effectScore] forKey:@"effectScore"];
    [params setObject:[NSString stringWithFormat:@"%d",self.attitudeScore] forKey:@"attitudeScore"];
    [params setObject:[NSString stringWithFormat:@"%d",self.promoteReasonableScore] forKey:@"promoteReasonableScore"];
    [params setObject:[NSString stringWithFormat:@"%d",self.trafficScore] forKey:@"trafficScore"];
    [params setObject:[NSString stringWithFormat:@"%d",self.environmentScore] forKey:@"environmentScore"];
    [params setObject:[NSString stringWithFormat:@"%d",self.organizationId] forKey:@"organizationId"];
    
    return [params JSONString];
}



@end


