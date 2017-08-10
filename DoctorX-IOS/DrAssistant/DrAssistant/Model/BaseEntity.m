//
//  BaseEntity.m
//  DrAssistant
//
//  Created by hi on 15/8/27.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseEntity.h"

 NSString *const SecureKey = @"dhCKDxtg5vTIkar6twv5FXvl";

@implementation BaseEntity

- (NSDictionary *)dictionaryOfEntity
{
    return nil;
}

- (NSMutableDictionary *)basePramsDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    
    
    return dic;
}

+ (NSDictionary *)sign:(NSArray *)prams
{
    /**
     public static void sign(final AjaxParams params, String... extras) {
     
     long timestamp = System.currentTimeMillis();
     
     StringBuffer buffer = new StringBuffer();
     
     if (extras != null) {
     for (String ex : extras) {
     buffer.append(ex);
     }
     } else {
     buffer.append(getToken());
     }
     params.put("token", buffer.toString());
     buffer.append(timestamp).append(KEY);
     params.put("date", timestamp + "");
     params.put("sign", Encrypt.MD5(buffer.toString()));
     
     }
     **/
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    long long timestamp = [Utils timeStmp];
    NSMutableString *string = [NSMutableString string];
    
    if (prams.count) {
        
        for (NSString *object in prams) {
            
            [string appendString:object];
        }
    }else{
        /**
         *  密码错误，token为空 导致崩溃
         */
        NSString *token = [GlobalConst shareInstance].token;
        if (token != nil) {
            [string appendString:token];
        }
    }
    
    [dic safeSetObject:string forKey:@"token"];
    
    [dic safeSetObject:[NSString stringWithFormat:@"%lld", timestamp] forKey:@"date"];
    
    NSString *signStr = [NSString stringWithFormat:@"%@%lld%@", string, timestamp, SecureKey];
    [dic safeSetObject: [signStr md532BitUpper] forKey:@"sign"];
    
    return dic;
}


@end
