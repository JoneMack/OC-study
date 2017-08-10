//
//  ColumnStore.h
//  styler
//
//  Created by aypc on 13-10-2.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "ContentSort.h"

@interface ContentSortStore : NSObject
+(ContentSortStore *)sharedStore;

-(void) getColumn:(void (^)(NSArray *column, NSError *err))completionBlock
     targetPageId:(int)targetPageId
               refresh:(BOOL)refresh;

-(void) getContentSort:(void (^)(NSArray *column, NSError *err))completionBlock
     targetPageId:(int)targetPageId
          refresh:(BOOL)refresh;

-(void)getContentSortInfo:(void(^)(ContentSort * contentSort,NSError * err)) completeBlock contentSortId:(NSString *)contentSortId
                  refresh:(BOOL)refresh;
@end
