//
//  SearchStore.m
//  styler
//
//  Created by aypc on 13-10-7.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "SearchStore.h"
@implementation SearchStore
+(SearchStore *)shareStore
{
    static SearchStore * searchStore = nil;
    if (searchStore == nil) {
        searchStore = [[SearchStore alloc]init];
    }
    return searchStore;
}
-(void) getSearchResultList:(void (^)(NSArray *works, NSError *err))completionBlock
                        uri:(NSString*)uri
                    refresh:(BOOL)refresh
{
    
}

+(NSString *)getSearchUriWith:(NSString *)searchKey
{
    NSString * uri = [NSString stringWithFormat:@"/stylists/searcher?query=%@&pageSize=%d&dataStatus=2", [searchKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], stylist_list_page_size];
    return uri;
}
@end
