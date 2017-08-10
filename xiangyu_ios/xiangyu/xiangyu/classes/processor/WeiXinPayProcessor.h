//
//  WeiXinPayProcessor.h
//  styler
//
//  Created by 冯聪智 on 14-10-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@protocol WeiXinPayProcessorDelegate <NSObject>

@optional
-(void) wxpaymentSuccess:(UINavigationController *)nav;
-(void) wxpaymentFail:(UINavigationController *)nav;


@end

@interface WeiXinPayProcessor : NSObject <WXApiDelegate>
{
    
    //lash_errcode;
    long     last_errcode;
    //debug信息
    NSMutableString *debugInfo;
    NSString *appid,*mchid,*spkey;
}


@property (nonatomic , strong) UINavigationController *navigationController;
@property (nonatomic, unsafe_unretained) id<WeiXinPayProcessorDelegate> delegate;
@property (nonatomic, strong) NSString *type;

-(void)doWeixinpay:(NSString *)payAmount payInfoDtoList:(NSMutableArray *)payInfoDtoList navigationController:(UINavigationController *)navigationController;

+ (WeiXinPayProcessor *) sharedInstance;

@end
