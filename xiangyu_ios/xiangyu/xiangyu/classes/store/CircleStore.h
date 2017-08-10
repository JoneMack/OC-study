//
//  CircleStore.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/20.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Circle.h"
#import "HotCircle.h"

@interface CircleStore : NSObject



+ (CircleStore *) sharedStore;


-(void) getCircles:(void(^)(Circle *circle, NSError *err))completionBlock;


-(void) getHotCircles:(void(^)(NSArray<HotCircle *> *hotCircles , NSError *err))completionBlock;

@end
