//
//  SocialShareStore.m
//  styler
//
//  Created by aypc on 13-12-16.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "SocialShareStore.h"

@implementation SocialShareStore
+(SocialShareStore *)shareInstance
{
    static SocialShareStore * socialShareStore = nil;
    if (!socialShareStore) {
        socialShareStore = [[SocialShareStore alloc]init];
    }
    return socialShareStore;
}

-(void)shareToSinaWeiboWith:(NSString *)shareText andImage:(UIImage *)shareImage  presentedController:(UIViewController *)presentedController completeBlock:(void(^)(BOOL shareSuccess))completeBlock
{
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:[NSArray arrayWithObjects:UMShareToSina, nil] content:shareText image:shareImage location:nil urlResource:nil presentedController:presentedController completion:^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            completeBlock(YES);
//        }else
//        {
//            completeBlock(NO);
//        }
//    }];
    
}
@end
