//
//  MyContractViewCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/8.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MyContractViewCell.h"

@implementation MyContractViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.topBlock setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
    
    [self.firstLineView setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    [self.secondLineView setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    [self.smallLineView setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    
    [self.address setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    [self.rentType setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    
    [self.status setTextColor:[ColorUtils colorWithHexString:text_color_green2]];
    
    [self.heTongNo setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    [self.heTongNoVal setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    [self.rentDate setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    [self.rentDateVal setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    [self.rentMoney setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    [self.rentMoneyVal setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    [self.guanJia setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    [self.guanJiaVal setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}

- (void)renderMyContractViewCellWithContractInfoList:(ContractInfoList *)contractInfoList{
    self.address.text = contractInfoList.houseAdminAddress;
    self.rentType.text = contractInfoList.rentType[@"name"];
    NSArray *historyInfoList = contractInfoList.historyInfoList;
    if (historyInfoList.count > 0) {
        NSDictionary *historyInfoListDict = historyInfoList[0];
        self.heTongNoVal.text = historyInfoListDict[@"id"];
        NSArray *startTimeArray = [historyInfoListDict[@"contractStartTime"] componentsSeparatedByString:@" "];
        NSArray *endTimeArray = [historyInfoListDict[@"contractEndTime"] componentsSeparatedByString:@" "];
        
        NSString *startStr = startTimeArray[0];
        NSString *endStr = endTimeArray[0];
        NSLog(@">>>>>>>>>>>>%@======%@",startStr,endStr);
        NSDate *startDate = [DateUtils getDateByFormatterString:[NSString stringWithFormat:@"%@ 00:00",startStr]];
        NSDate *endDate = [DateUtils getDateByFormatterString:[NSString stringWithFormat:@"%@ 00:00",endStr]];
        long long int startLongTime = [DateUtils longlongintFromDate:startDate];
        NSString *lastTime = [DateUtils dateWithStringFromLongLongInt:startLongTime];
        NSString *chaStr = [self intervalFromLastDate:lastTime toTheDate:endDate];
        NSLog(@">>>>namenamenamenamename>>>>>>>>%@======%@------%@",chaStr,startDate,endDate);
        self.rentDateVal.text = [NSString stringWithFormat:@"%@（%@-%@）",chaStr,startTimeArray[0],endTimeArray[0]];
    }

}
//计算两个date的差值
- (NSString *)intervalFromLastDate: (NSString *) startString toTheDate:(NSDate *) endDate
{
    NSTimeInterval dayCountTime = [DateUtils getUTCFormateDate:startString currentDate:endDate];
    
    int month=((int)dayCountTime)/(3600*24*30);
    int days=((int)dayCountTime)/(3600*24);
    int hours=((int)dayCountTime)%(3600*24)/3600;
    int minute=((int)dayCountTime)%(3600*24)/60;
    int second = ((int)dayCountTime)%(3600*24)%3600%60;
    NSLog(@"time=%f",(double)dayCountTime);
    NSString *dateContent;
    if(month!=0){
        dateContent = [NSString stringWithFormat:@"%d%@",month,@"个月"];
        
    }else if(days!=0){
        dateContent = [NSString stringWithFormat:@"%d%@",days,@"天"];
    }else if(hours!=0){
        dateContent = [NSString stringWithFormat:@"%d%@",hours,@"小时"];
    }else if(minute != 0){
        dateContent = [NSString stringWithFormat:@"%d%@",minute,@"分钟"];
    }else{
        dateContent = [NSString stringWithFormat:@"%d%@",second,@"秒"];
    }
    return dateContent;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)contactGuanJiaEvent:(id)sender {
}
@end
