//
//  MyNewsDetailModel.h
//  DrAssistant
//
//  Created by Seiko on 15/10/17.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyNewsModel.h"
@interface MyNewsDetailModel : NSObject

@property(nonatomic ,retain)MyNewsModel *dataEntity;
@property(nonatomic ,retain)NSMutableArray *modelArray;
- (NSMutableArray *)packageDataWithObject:(id)json;


@end
