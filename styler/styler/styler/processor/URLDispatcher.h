//
//  URLDispatcher.h
//  styler
//
//  Created by System Administrator on 14-2-15.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeveyTabBarController.h"
#import "ChildContentSort.h"

@interface URLDispatcher : NSObject

+(BOOL) dispatch:(NSURL *)url nav:(UINavigationController *)nav;
+(BOOL) dispatchWithContentSort:(int)contentSortId
                contentSortName:(NSString *)contentSortName
                    extendParam:(NSString *)extendParam
                contentModeType:(int)contentModeType
                            nav:(UINavigationController *)nav;


@end
