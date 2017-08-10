//
//  SocialAccountStore.m
//  styler
//
//  Created by aypc on 13-11-26.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "SocialAccountStore.h"

static SocialAccountStore * sociaAccountStore;

@implementation SocialAccountStore

+(SocialAccountStore *)shareInstance
{
    if (sociaAccountStore == nil) {
        sociaAccountStore = [[SocialAccountStore alloc]init];
    }
    return sociaAccountStore;
}

-(void)removeSocialAccountCache
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:share_to_sina_weibo_key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:binding_sina_weibo_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
