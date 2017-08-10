//
//  CfContractXS.m
//  xiangyu
//
//  Created by 冯聪智 on 16/8/3.
//  Copyright © 2016年 相寓. All rights reserved.
//

/**
 * 合同对象
 */

#import "CfContractXS.h"

@implementation CfContractXS




-(NSString *) getRentDate{
    NSString *startDate = self.contractStartDate;
    NSString *endDate = self.contractEndDate;
    
    NSArray *startDateArr  = [startDate componentsSeparatedByString:@"-"];
    NSArray *endDateArr  = [endDate componentsSeparatedByString:@"-"];
    
    return [NSString stringWithFormat:@"%@年%@月%@日--%@年%@月%@日" , startDateArr[0] , startDateArr[1] , startDateArr[2],
            endDateArr[0] , endDateArr[1] , endDateArr[2]];
    
}




@end
