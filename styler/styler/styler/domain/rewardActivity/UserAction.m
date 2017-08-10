//
//  UserAction.m
//  styler
//
//  Created by 冯聪智 on 14-9-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "UserAction.h"
#import <ThirdFramework/jsonkit/JSONKit.h>

@implementation UserAction

-(id) initWithActionType:(ShareSceneType *) shareSceneType{
    
    self = [super init];
    if (self) {
        self.actionType = shareSceneType.sharedContentType;
        NSMutableDictionary *actionParams = [NSMutableDictionary new];
        [actionParams setObject:@(shareSceneType.getValueOfSharedChannelType) forKey:@"sharePlatform"];
        self.actionParams = actionParams;
    }
    return self;
}

-(NSString *) getJsonString{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    [params setObject:@(self.actionType) forKey:@"actionType"];
    
    if (self.actionParams != nil) {
        [params setObject:self.actionParams forKey:@"actionParams"];
    }
    
    return [params JSONString];
}


@end
