//
//  SocialAccountStore.h
//  styler
//
//  Created by aypc on 13-11-26.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

@interface SocialAccountStore : NSObject
+(SocialAccountStore*)shareInstance;
-(void)removeSocialAccountCache;
@end
