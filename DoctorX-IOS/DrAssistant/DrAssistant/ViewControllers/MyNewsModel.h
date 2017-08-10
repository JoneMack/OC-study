//
//  MyNewsModel.h
//  DrAssistant
//
//  Created by Seiko on 15/10/17.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MyNewsModel : NSObject
/*
 rows:[
         {
         
             "ID": 8,
             "title": "测试推送，查看推送属性",
             "content": "<p>测试推送，查看推送属性</p>",
             "create_time": "2015-10-17 15:31:33",
             "creator": "18625558280",
             "type": 1
         }
      ]
 */
@property (nonatomic, strong) NSArray *rows;

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *creator;
@property (nonatomic, copy) NSString *type;
@end
