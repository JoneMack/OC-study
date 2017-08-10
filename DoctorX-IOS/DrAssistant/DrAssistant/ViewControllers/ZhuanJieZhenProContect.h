//
//  ZhuanJieZhenProContect.h
//  DrAssistant
//
//  Created by Seiko on 15/10/10.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhuanJieZhenEntity.h"
@interface ZhuanJieZhenProContect : NSObject

@property(nonatomic ,retain)ZhuanJieZhenEntity *dataEntity;
@property(nonatomic ,retain)NSMutableArray *modelArray;
- (NSMutableArray *)packageDataWithObject:(id)json;

@end
