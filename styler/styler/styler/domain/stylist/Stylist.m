//
//  Expert.m
//  iUser
//
//  Created by System Administrator on 13-4-23.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "Stylist.h"
#import "ServicePicture.h"
#import "StylistWork.h"

@implementation Stylist

//根据属性名判断是否可选
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(NSString *) getTotalScoreStr{
    float averageScore = [self.expertTotalCount getAverageScore];
    if (averageScore == 0) {
        return [NSString stringWithFormat:@"50%%"];
    }
    else
    {
        return [NSString stringWithFormat:@"%.0f%%",[self.expertTotalCount getAverageScore]];
    }
}

-(NSMutableAttributedString *)getStylistScore{
    float attitudeScore,promoteReasonableScore,effectScore;
    if (self.expertTotalCount.receivedEvaluationCount == 0) {
        attitudeScore = 3;
        promoteReasonableScore = 3;
        effectScore = 3;
    }else{
        attitudeScore = self.expertTotalCount.attitudeScore/self.expertTotalCount.receivedEvaluationCount;
        promoteReasonableScore = self.expertTotalCount.promoteReasonableScore/self.expertTotalCount.receivedEvaluationCount;
        effectScore = self.expertTotalCount.effectScore/self.expertTotalCount.receivedEvaluationCount;
    }
    NSString *scoreTxt = [NSString stringWithFormat:@"服务态度 %.1f        ",attitudeScore];
    int length1 = scoreTxt.length;
    scoreTxt = [NSString stringWithFormat:@"%@合理推销 %.1f       ",scoreTxt,promoteReasonableScore];
    int length2 = scoreTxt.length;
    scoreTxt = [NSString stringWithFormat:@"%@美发效果 %.1f",scoreTxt,effectScore];
    int length3 = scoreTxt.length;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:scoreTxt];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[ColorUtils colorWithHexString:black_text_color] range:NSMakeRange(0, 4)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[ColorUtils colorWithHexString:red_color] range:NSMakeRange(4, length1-4)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[ColorUtils colorWithHexString:black_text_color] range:NSMakeRange(length1, 4)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[ColorUtils colorWithHexString:red_color] range:NSMakeRange(length1+4, length2-length1-4)];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:[ColorUtils colorWithHexString:black_text_color] range:NSMakeRange(length2, 4)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[ColorUtils colorWithHexString:red_color] range:NSMakeRange(length2+4, length3-length2-4)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:big_font_size] range:NSMakeRange(0, length3)];
    return attrStr;

}

-(NSString *) getHairCutPriceInfoText{
    NSString *text = [NSString stringWithFormat:@"剪发￥%d",self.hairCutPriceInfo.price];
    return text;
}

-(NSString *) getHairCutSpecialOfferPriceText{
    NSString *text = [self getHairCutPriceInfoText];
    text = [text stringByAppendingString:[NSString stringWithFormat:@" ￥%d",self.hairCutPriceInfo.specialOfferPrice]];
    return text;
}

-(NSMutableAttributedString *)getStylistHairCutPrice{
    NSString *text = [self getHairCutPriceInfoText];
    int length1 = text.length;
    text = [self getHairCutSpecialOfferPriceText];
    int length2 = text.length;
    //        text = [text stringByAppendingString:[NSString stringWithFormat:@"            %d个作品",stylist.expertTotalCount.worksCount]];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    //设置字体颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:[ColorUtils colorWithHexString:gray_text_color] range:NSMakeRange(0,text.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[ColorUtils colorWithHexString:red_color] range:NSMakeRange(length1,length2 - length1)];
    //设置字体大小
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:small_font_size] range:NSMakeRange(0, text.length)];
    return attrStr;
}

-(CGSize) getSize{
     NSString *text = [self getHairCutPriceInfoText];
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:small_font_size] constrainedToSize:CGSizeMake(screen_width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

-(NSArray *)daysCanDate{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    int i = 0;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];

    while ([result count] < 20) {
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(24*60*60*i)];
        
        if (self.closeDates != nil) {
            BOOL isInCloseDate = NO;
            for (CloseDate *closeDate in self.closeDates) {
                if ([closeDate isInCloseDate:date]) {
                    isInCloseDate = YES;
                    break;
                }
            }
            if (isInCloseDate) {

                i++;
                continue;
            }
        }
                
        if (i == 0) {
            NSDate *date = [NSDate date];
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            comps = [gregorian components:NSHourCalendarUnit fromDate:date];
            if(comps.hour > 18){
                i++;
                continue;
            }
        }
        NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
        int weekday = [weekdayComponents weekday];
        if(self.offdays == nil){
            [result addObject:date];
        }else{
            BOOL isOffday = NO;
            for (NSString *offday in self.offdays) {
                if(weekday == (offday.intValue+1)){
                    isOffday = YES;
                }
            }
            if (!isOffday) {
                [result addObject:date];
            }
        }
        i++;
    }
    return result;
}

-(NSArray *)hoursCanDate:(NSDate *)date{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSDate *now = [NSDate new];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *nowComponents = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit fromDate:now];
    int nowYear = [nowComponents year];
    int nowMonth = [nowComponents month];
    int nowDay = [nowComponents day];
    int nowHour = [nowComponents hour];
    
    NSDateComponents *dateComponents = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit fromDate:date];
    int year = [dateComponents year];
    int month = [dateComponents month];
    int day = [dateComponents day];
    if (nowYear == year && nowMonth == month && nowDay == day) {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        comps = [gregorian components:NSMinuteCalendarUnit fromDate:now];
        BOOL halfPassed = comps.minute>30?YES:NO;
    
        for(int i = self.workHourStart; i <= self.workHourEnd; i++){
            //NSLog(@">>>> add hour:%d, end hour:%d", i, self.workHourEnd);
            if (i > nowHour) {
                if (i == (nowHour+1) && halfPassed) {
                }else{
                    [result addObject:[NSNumber numberWithInt:i]];
                }
                [result addObject:[NSNumber numberWithFloat:(i+0.5)]];
            }
        }
    }else{
        for(int i = self.workHourStart; i <= self.workHourEnd; i++){
            [result addObject:[NSNumber numberWithInt:i]];
            [result addObject:[NSNumber numberWithFloat:(i+0.5)]];
        }
    }
    
    return result;
}

-(BOOL) hasCloseDate{
    
    if (self.closeDates == nil || self.closeDates.count==0) {
        return NO;
    }
    
    NSDate *currentDate = [NSDate date];
    CloseDate *closeDate = [self.closeDates lastObject];
    if ([DateUtils compare:[DateUtils dateFromLongLongInt:closeDate.start] date2:currentDate] == 1
        && [DateUtils compare:[DateUtils dateFromLongLongInt:closeDate.end] date2:currentDate] == 2) {
        return YES;
    }
    return NO;
}

-(NSString *) getCloseStartDate{
    if ([self hasCloseDate]) {
        CloseDate *closeDate = [self.closeDates lastObject];
        return [DateUtils stringFromLongLongIntAndFormat:closeDate.start dateFormat:@"M月d日"];
    }
    return @"";
}

-(NSString *) getCloseEndDate{
    if ([self hasCloseDate]) {
        CloseDate *closeDate = [self.closeDates lastObject];
        return [DateUtils stringFromLongLongIntAndFormat:closeDate.end dateFormat:@"M月d日"];
    }
    return @"";

}

-(NSString*)description
{
    return [NSString stringWithFormat:@"expert:id = %d,name = %@,nickName = %@ , profile = %@ jobTitle = %@"  ,self.id,self.name,self.nickName, self.authorizedInfo, self.jobTitle];
}
@end
