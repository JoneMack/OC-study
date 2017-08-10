//
//  SearchStore.h
//  styler
//
//  Created by aypc on 13-10-7.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

@interface SearchStore : NSObject
+(SearchStore *)shareStore;
-(void) getSearchResultList:(void (^)(NSArray *works, NSError *err))completionBlock
                      uri:(NSString*)uri
                  refresh:(BOOL)refresh;
+(NSString *)getSearchUriWith:(NSString *)searchKey;
@end
