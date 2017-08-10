//
//  SocialShareStore.h
//  styler
//
//  Created by aypc on 13-12-16.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

@interface SocialShareStore : NSObject
+(SocialShareStore *)shareInstance;
-(void)shareToSinaWeiboWith:(NSString *)shareText andImage:(UIImage *)shareImage  presentedController:(UIViewController *)presentedController completeBlock:(void(^)(BOOL shareSuccess))completeBlock;
@end
