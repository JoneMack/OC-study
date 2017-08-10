//
//  DistributeStrage.h
//  styler
//
//  Created by 冯聪智 on 14-9-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DistributeStrage

@end

@interface DistributeStrage : JSONModel <NSCoding>
@property int amountType;  //派发金额类型，定额、区间
@property BOOL differentiateUser; //是否区别对待新老用户
@property (nonatomic ,copy) NSString *perAmount;  // 后台定义的是一个区间值，现在是看成一个定额，不用考虑区间值。
@property (nonatomic ,copy) NSString *oldUserPerAmount;//老用户获得红包金额

//perAmount 每个红包金额，如果是定额则是一个金额，如果不是定额则是一个区间值，例如1,10 指的是1块到10块
@end
