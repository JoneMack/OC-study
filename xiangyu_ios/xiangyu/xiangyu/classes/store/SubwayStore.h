//
//  SubwayStore.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/1.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubwayLine.h"

@interface SubwayStore : NSObject

+ (SubwayStore *) sharedStore;


-(void) getSubways:(void(^)(NSArray<SubwayLine *> *subwayLines, NSError *err))completionBlock;






@end
