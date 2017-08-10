//
//  ContentSort.m
//  styler
//
//  Created by System Administrator on 14-1-9.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "ContentSort.h"
#import "ChildContentSort.h"

@implementation ContentSort

//-(id)initWithJsonDictionary:(NSDictionary *)dic
//{
//    self = [self init];
//    [self readWithJsonDic:dic];
//    return self;
//}
//
//-(void)readWithJsonDic:(NSDictionary *)jsonDict
//{
//    self.name = [jsonDict objectForKey:@"name"];
//    if((NSNull *)[jsonDict objectForKey:@"childSorts"] != [NSNull null]){
//        NSMutableArray *childSortArray = [jsonDict objectForKey:@"childSorts"];
//        [self setChildSorts:[ChildContentSort readFromJsonDictionayArray: childSortArray]];
//    }
//}
//
//+(NSArray *) readFromJsonDictionayArray: (NSArray *)jsonDictArray{
//    NSMutableArray *result = [[NSMutableArray alloc] init];
//    for(int i = 0; i < [jsonDictArray count]; i++){
//        ContentSort *contentSort = [[ContentSort alloc] initWithJsonDictionary:[jsonDictArray objectAtIndex:i]];
//        [result addObject:contentSort];
//    }
//    return result;
//}

@end
