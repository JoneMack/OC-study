//
//  DcoZoneSelModel.h
//  DrAssistant
//
//  Created by Seiko on 15/10/1.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DcoZoneSelModel : NSObject
/*
 ID	:	6
 
 ORG_NAME	:	郑州市中心医院
 
 ORG_CODE	:	410100102
 
 parent_id	:	2
 
 ORG_TYPE	:	3
 
 alias	:	中心医院
 
 STATUS	:	1
 
 ORG_SEQ	:	410100102

 */
@property (nonatomic, strong) NSArray *data;

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *ORG_NAME;
@property (nonatomic, copy) NSString *ORG_CODE;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, copy) NSString *ORG_TYPE;
@property (nonatomic, copy) NSString *alias;
@property (nonatomic, copy) NSString *STATUS;
@property (nonatomic, copy) NSString *ORG_SEQ;
@end
