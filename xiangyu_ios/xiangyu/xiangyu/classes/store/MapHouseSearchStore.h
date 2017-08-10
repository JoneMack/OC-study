//
//  MapHouseSearchStore.h
//  xiangyu
//
//  Created by xubojoy on 16/6/22.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MapHouseSearchStore : NSObject

+(void) getHouseMapSearchByprojectnames:(void(^)(NSDictionary *dict, NSError *err))completionBlock projectnames:(NSString *)projectnames;

@end
