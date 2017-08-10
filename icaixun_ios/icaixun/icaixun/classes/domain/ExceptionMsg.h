//
//  ExceptionMsg.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/16.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExceptionMsg : NSObject

@property int status;
@property int code;
@property (nonatomic, copy) NSString *message;


-(void) readFromJSONDictionary:(NSDictionary *)jsonDict;

@end
