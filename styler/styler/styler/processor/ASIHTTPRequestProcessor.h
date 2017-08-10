//
//  ASIHTTPRequestProcessor.h
//  styler
//
//  Created by System Administrator on 14-8-26.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASIHTTPRequestProcessor : NSObject

@property (nonatomic, strong) Reachability *reachability;

-(void) initASI;
-(void)reachabilityChanged:(NSNotification *) note;
@end
