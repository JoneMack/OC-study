//
//  ASIHTTPRequestProcessor.m
//  styler
//
//  Created by System Administrator on 14-8-26.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "ASIHTTPRequestProcessor.h"
#import "GaodeMapProcessor.h"

@implementation ASIHTTPRequestProcessor

-(void) initAFN{
    NSLog(@">>>>> init asi");
    
    //设置ASIHttpRequest，Http客户端组件
    
    //注册联网状态的通知监听器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object: nil];
    self.reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [self.reachability startNotifier];
}

-(void)reachabilityChanged:(NSNotification *) note{
    //NSLog(@">>>>>>> reachability changed");
    Reachability *curReachability = [note object];
    NetworkStatus status = [curReachability currentReachabilityStatus];
    [AppStatus sharedInstance].networkStatus = status;
    if (status == NotReachable) {
        NSLog(@"网络不通");
    }else if(status == ReachableViaWiFi){
        NSLog(@"WIFI联网");
    }else if(status == ReachableViaWWAN){
        NSLog(@"3G/GPRS联网");
    }
    if(status != NotReachable){
        [[GaodeMapProcessor sharedInstance] startLocation];
    }
}
@end
