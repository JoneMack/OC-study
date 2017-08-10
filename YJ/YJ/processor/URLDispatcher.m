//
//  URLDispatcher.m
//  CrazyDoctor
//
//  Created by xubojoy on 16/4/8.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import "URLDispatcher.h"
#import "AppDelegate.h"
#import "NSString+stringPlus.h"

@implementation URLDispatcher
+(BOOL) dispatch:(NSURL *)url nav:(UINavigationController *)nav
{
    NSLog(@"点用了连接:%@",url);
    NSString *path = [url path];
    NSString *params = [url query];
    NSString *host = [url host];
    if ([host isEqualToString:[AppStatus sharedInstance].hostUrl]) {
        NSLog(@">>>>>>>path>>>>>%@",path);
        
    }else if([host isEqualToString:@"safepay"]){
        NSLog(@">>>>>> app alipay back:%@, path:%@, query:%@", url, [url path], [url query]);
        return YES;
    }
    return NO;
}

//OrderDoctorFillController

+(BOOL) dispatchWithContentSort:(int)contentSortId
                contentSortName:(NSString *)contentSortName
                    extendParam:(NSString *)extendParam
                contentModeType:(int)contentModeType
                            nav:(UINavigationController *)nav{
    //NSLog(@"contentSortId:%d, name:%@, extendParam:%@, modeType:%d", contentSortId, contentSortName, extendParam, contentModeType);
    
    switch (contentModeType) {
        case 1://标签作品；
            break;
        case 2://指定作品
            break;
        default:
            return NO;
    }
    return YES;
}

@end
