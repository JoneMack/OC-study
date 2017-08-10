//
//  ShareSceneType.m
//  styler
//
//  Created by 冯聪智 on 14-9-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "ShareSceneType.h"

@implementation ShareSceneType


-(id) initWithType:(ShareContentType)sharedContentType sharedChannelType:(ShareType)sharedChannelType{
    self = [super init];
    if (self) {
        self.sharedContentType = sharedContentType;
        self.sharedChannelType = sharedChannelType;
    }
    return self;
}

-(int) getValueOfSharedChannelType{
    
    switch (self.sharedChannelType) {
        case ShareTypeSinaWeibo:
            return 2;
        case ShareTypeWeixiFav:
            return -1;
        case ShareTypeWeixiSession:
            return -1;
        case ShareTypeWeixiTimeline:
            return 1;
        case ShareTypeSMS:
            return -1;
        default:
            break;
    }
    return -1;
}

@end
