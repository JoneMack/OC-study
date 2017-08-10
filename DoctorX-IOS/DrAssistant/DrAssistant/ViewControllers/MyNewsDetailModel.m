//
//  MyNewsDetailModel.m
//  DrAssistant
//
//  Created by Seiko on 15/10/17.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "MyNewsDetailModel.h"

@implementation MyNewsDetailModel
- (NSMutableArray *)packageDataWithObject:(id)json
{
    self.modelArray = [NSMutableArray arrayWithCapacity:0];
    
    NSDictionary *jsonDic = (NSDictionary *)json;
    
    NSArray *memberArray = [jsonDic objectForKey:@"rows"];
    for (NSDictionary *dic in memberArray)
    {
        self.dataEntity = [[MyNewsModel alloc] init];
        
        self.dataEntity.ID = [dic objectForKey:@"ID"];
        self.dataEntity.title = [dic objectForKey:@"title"];
        self.dataEntity.content = [dic objectForKey:@"content"];
        self.dataEntity.create_time = [dic objectForKey:@"create_time"];
        self.dataEntity.creator = [dic objectForKey:@"creator"];
        self.dataEntity.type = [dic objectForKey:@"type"];
        
        [_modelArray addObject:self.dataEntity];
    }
    return _modelArray;
    
}
@end
